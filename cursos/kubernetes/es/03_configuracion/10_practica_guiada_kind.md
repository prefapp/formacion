# Práctica guiada: creación de un clúster personalizado con Kind

En esta práctica explicaremos algunas de las opciones que podemos usar para crear un clúster Kind usando un script.

El clúster que crearemos tendrá las siguientes características:

- Tendrá un registry local.
- Tendrá el número de nodos que especifiquemos.
- Incluirá un controlador Ingress (en este caso, un Nginx).

## Registry local

Para tener un registro local, usaremos el script provisto por Kind en su [documentación oficial](https://kind.sigs.k8s.io/docs/user/local-registry/). En los comentarios del código explicamos qué hace cada parte del script.

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

## Modificar el número de nodos

Una de las características más interesantes de Kind es que permite controlar el número y tipo de nodos que tendrá el clúster, así como las imágenes que tendrán instaladas. Por defecto, si no modificamos la configuración, Kind creará un único nodo de tipo master (el identificado con el rol de control-plane), pero podemos añadirle todos los workers que queramos:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
```

Volviendo al código de nuestro script, debemos incluir estos nodos en el orden que crea el clúster, es decir:

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
En este caso, el clúster se crearía con cuatro nodos: el master y tres workers.

## Agregar un controlador de ingress con Nginx

Para que nuestro clúster pueda usar Ingress, debe tener un controlador instalado.

En nuestro caso, para facilitar la instalación, vamos a lanzar el manifiesto ingress-nginx, que desplegará automáticamente todos los artefactos necesarios para que el controlador funcione. La implementación de estos artefactos requiere que el clúster ya esté en funcionamiento, por lo que será el último paso del script.

```bash
# Install Ingress NGINX controller
echo "\nInstalling Ingress NGINX controller...\n"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Puede consultar el resultado final [en esta página](00_solucions/03_solucion/despregar-cluster-con-registry-e-ingress.md).