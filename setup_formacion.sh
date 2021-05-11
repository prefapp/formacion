#!/bin/bash

# Instructions: Accept name as parameter

NOMBRE=$1
REG_NAME=$NOMBRE-registry
REG_PORT='5000'

# Install Docker
if ! command -v docker --version &> /dev/null; then
  echo -e "\n[ Instalando Docker ]\n"
  apt-get update && \
  apt-get install \
    docker-ce \
    docker-ce-cli \
    containerd.io
else
  echo -e "\n[ Docker ya está instalado ]"
fi

# Install docker-compose
if ! command -v docker-compose --version &> /dev/null; then
  echo -e "\n[ Instalando docker-compose ]\n"
  curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose
else
  echo -e "\n[ docker-compose ya está instalado ]"
fi

# Install kubectl
if ! command -v kubectl version --client &> /dev/null; then
  echo -e "\n[ Instalando kubectl ]\n"
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl
else
  echo -e "\n[ kubectl ya está instalado ]"
fi

# Install HELM
if ! command -v helm version &> /dev/null; then
  echo -e "\n[ Instalando Helm ]\n"
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh && \
  rm get_helm.sh
else
  echo -e "\n[ Helm ya está instalado ]"
fi

# Install Kind
if ! command -v kind version &> /dev/null; then
  echo -e "\n[ Instalando Kind ]\n"
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64 && \
  chmod +x ./kind && \
  mv ./kind /usr/local/bin/kind
else
  echo -e "\n[ Kind ya está instalado ]"
fi

create_cluster () {
  echo -e "\n[ Creando cluster $NAME ]\n"
  cat <<EOF | kind create cluster --name ${NOMBRE} --config=-
  kind: Cluster
  apiVersion: kind.x-k8s.io/v1alpha4
  nodes:
  - role: control-plane
    kubeadmConfigPatches:
    - |
      kind: InitConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "ingress-ready=true"
    extraPortMappings:
    - containerPort: 80
      hostPort: 80
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      protocol: TCP
  containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${REG_PORT}"]
      endpoint = ["http://${REG_IP}:${REG_PORT}"]
EOF
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
}

create_registry () {
  echo -e "\n[ Creando registry $REG_NAME ]\n"
  docker run -d -p 5000:5000 --name $REG_NAME registry:2
  REG_IP="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $REG_NAME)"
  echo -e "\nRegistry IP: ${REG_IP}"
}

# Check registry and cluster
PATH_CODIGO="/home/formacion"
running="$(docker inspect -f '{{.State.Running}}' $REG_NAME 2>/dev/null || true)"
CLUSTER=$(kind get clusters | grep 'formacion' &> /dev/null)
EXIT=$(echo $?)

if [[ "${running}" != 'true' && $EXIT = 1 ]]; then
  echo -e "\n[ No exiten ni el registry $REG_NAME ni el cluster $NOMBRE]"
  create_registry
  create_cluster
elif [[ "${running}" != 'true' && $EXIT == 0 ]]; then
  echo -e "\n[ No exite el registry $REG_NAME pero si el cluster $NOMBRE ]"
  create_registry
  echo -e "\n[ Borrando cluster ]"
  kind delete cluster --name $NOMBRE
  create_cluster
elif [[ "${running}" == 'true' && $EXIT == 1 ]]; then
  echo -e "\n[ Exite el registry $REG_NAME pero no el cluster $NOMBRE ]"
  echo -e "\n[ Borrando registry ]"
  docker rm -f formacion-registry
  create_registry
  create_cluster
elif [[ "${running}" == 'true' && $EXIT == 0 ]]; then
  echo -e "\n[ Exite el registry $REG_NAME y el cluster $NOMBRE ]"
  echo -e "\n[ Nada que hacer!!! ]"
fi
