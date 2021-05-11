#!/bin/bash

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
