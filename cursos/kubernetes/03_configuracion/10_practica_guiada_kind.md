# Práctica guiada: crear un clúster personalizado con Kind

Nesta práctica imos explicar algunhas das opcións que podemos utilizar para crear un clúster de Kind mediante un script.

O clúster que crearemos terá as seguintes características:

- Contará cun registry local.
- Terá o número de nodos que especifiquemos.
- Incluirá unha controladora de Ingress (neste caso, un Nginx).

## Registry local

Para contar cun registry local, usaremos o script que nos facilita Kind na súa [documentación oficial](https://kind.sigs.k8s.io/docs/user/local-registry/). Nos comentarios do código explicamos o que fai cada parte do script.

```bash
#!/bin/sh
set -o errexit

# Especificamos o nome que queremos para o registry e que porto utilizará
reg_name='kind-registry'
reg_port='5001'

# Se o registry non existe, o creamos nun novo contedor
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# Creamos un clúster de Kind e usamos containerd para habilitar o noso registry local
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:5000"]
EOF

# Verificamos que o registry teña acceso á rede do clúster e, se non é así, o conectamos
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  docker network connect "kind" "${reg_name}"
fi

# Documentamos o registry local
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

```

## Modificar o número de nodos

Unha das características máis interesantes de Kind é que permite o control sobre o número e tipo de nodos que terá o clúster, así como as imaxes que terán instaladas. Por defecto, se non modificamos a configuración, Kind creará un único nodo de tipo master (ó que identifica co rol de control-plane), pero podemos engadirlle tódolos workers que queiramos:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
```

Retomando o código do noso script, habería que incluir estes nodos na orden que crea o clúster, é dicir:

```bash
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:5000"]
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
EOF
```
Neste caso, o clúster crearíase con catro nodos: o master e tres workers.

## Engadindo un controlador de Ingress con Nginx

Para que o noso clúster teña a capacidade de usar Ingress, é necesario que teña instalado un controlador.

No noso caso, para facilitar a instalación, imos a lanzar o manifesto de ingress-nginx, que despregará automáticamente tódolos artefactos necesarios para que o controlador funcione. Para despregar estes artefactos, é necesario que o clúster estea xa en funcionamento, polo que será o último paso do script.

```bash
# Install Ingress NGINX controller
echo "\nInstalling Ingress NGINX controller...\n"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Podes consultar o resultado final [nesta páxina](00_solucions/03_solucion/despregar-cluster-con-registry-e-ingress.md).