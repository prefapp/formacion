# Servicios en profundidad

En el anterior tema sobre la [Arquitectura de K8s](https://prefapp.github.io/formacion/cursos/kubernetes/#/./02_kubernetes/05_arquitectura_kubernetes_service) vimos la importancia de los *services* como una abstracción de pods backend para una aplicación cliente. Mediante los services cualquier aplicación cliente puede "despreocuparse" de dónde se están realizando las llamadas a los programas o aplicaciones que sirven como backend.

![Servizo2](./../_media/02/servizo2.png)

En este capítulo veremos los siguientes tipos de *Service*, con sus casos de uso y sus debilidades:
- [Servicios en profundidad](#servicios-en-profundidad)
  - [ClusterIP](#clusterip)
  - [NodePort](#nodeport)
  - [LoadBalancer](#loadbalancer)
    - [LoadBalancer local con Kind](#loadbalancer-local-con-kind)

Desplegaremos el siguiente deploy para mostrarlo con cada tipo de servicio y así apreciar las diferencias entre cada *service kind* : 

```yaml
#deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: despregue-web
spec:
  selector:
    matchLabels:
      app: pod-web
  replicas: 5 
  template:
    metadata:
      labels:
        app: pod-web
    spec:
      containers:
      - name: pod-web
        image: frmadem/catro-eixos-k8s-ej1:v1
        env:
          - name: PUERTO_APP
            value: "80"
        command: ["npm", "run", "iniciar"]
        ports:
          - containerPort: 80
```

No es más que un servidor web que muestra un pequeño mensaje con la versión del servidor y la máquina que sirve los datos.

Si hacemos una aplicación de nuestro `deploy.yaml`. Tendremos 5 pods ejecutando el servidor web.

## ClusterIP

Para exponer nuestro deploy primero usaremos un servicio de tipo `ClusterIp`, que es el tipo por defecto en los *services* de k8s:

```yaml
# clusterip-service.yaml
kind: Service
apiVersion: v1
metadata:  # esta es la parte identificativa del servicio
  name: servizo-clusterip
spec:
  selector:   # esta es la parte de selección
    app: pod-web
  ports:  # esta es la parte de especificación propia
  - port: 80
    targetPort: 80
```

Si hacemos varios curl desde dentro de un contenedor veremos que van cambiando los pods que devuelve la petición:

![Servizo1](./../_media/03/servizo1.png)

Sin embargo, si hacemos un `port-forward` de nuestro servicio para acceder desde el exterior, podemos comprobar que siempre nos devuelve el mismo pod.

![Servizo2](./../_media/03/servizo2.png)

## NodePort

El comando `port-forward`, aunque indiquemos un servicio nos mostrará un pod, el primero que encuentre a través del servicio. Si queremos exponer el servicio tenemos que usar un servicio de tipo `Nodeport`:

```yaml
# nodeport-service.yaml
kind: Service
apiVersion: v1
metadata:  
  name: servizo-nodeport
spec:
  type: NodePort # tipo de servizo
  selector:   
    app: pod-web
  ports:  
  - port: 80
    targetPort: 80
    nodePort: 31415   
```

NodePort, como sugiere el nombre, abre un puerto específico en todos los nodos del clúster y todo el tráfico enviado a este puerto (`nodePort: 31415`) se reenvía al servicio.
 
![Servizo3](./../_media/03/servizo3.png)

Esta opción tiene varios problemas:
- Solo se puede tener un servicio por puerto.
- Solo se pueden usar los puertos 30000–32767.
- Debemos tener un mecanismo de ajuste en caso de que cambie la IP del nodo.

## LoadBalancer

Para solucionar las carencias de *Nodeport* aparece un servicio más avanzado que permite exponer nuestro servicio a través de su propia IP pública. Para utilizar este servicio necesitas un proveedor de Kubernetes, ya que su despliegue proporciona una IP externa desde la que acceder a tu servicio.

```yaml
# loadbalancer-service.yaml
kind: Service
apiVersion: v1
metadata:  # esta é a parte de identificación do servizo
  name: servizo-loadbalancer
spec:
  type: LoadBalancer
  selector:  # esta é a parte de selección
    app: pod-web
  ports:  # esta é a parte de especificación propia
  - port: 6000
    targetPort: 80
```

![Servizo4](./../_media/03/servizo4.png)

Si desea exponer un servicio directamente, este es el método predeterminado. Todo el tráfico en el puerto especificado se reenviará al servicio. Sin filtrado, sin enrutamiento, etc. Esto significa que pueden enviarle casi cualquier tipo de tráfico, como HTTP, TCP, UDP, Websockets, gRPC o cualquier otro.

La gran desventaja es que cada servicio expuesto con un *LoadBalancer* obtendrá su propia dirección IP y tendremos que pagar por cada servicio expuesto, lo que puede ser costoso.

Si estás usando tráfico HTTP, un Ingress te permitirá usar una única IP y hacer enrutamiento por path y subdominio, como veremos en el [siguiente apartado](./06_Ingress_controlando_o_trafico.md) del tema.

### LoadBalancer local con Kind

Para probar el funcionamiento de servicios tipo LoadBalancer en un clúster local, Kind permite la instalación de [metallb](https://metallb.universe.tf/), lo que nos dará la posibilidad de asignar un pool de IPs locales a nuestro pods usando LoadBalancer.

Los pasos a seguir serían:

**1. Creamos namespace para metallb:**

```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
```

**2. Aplicamos el manifiesto metallb**, el cual creará todos los artefactos necesarios para su funcionamiento:

```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
```

Antes de continuar, debemos esperar hasta que los pods de metallb estén en estado de ejecución:

```shell
kubectl get pods -n metallb-system --watch
```

**3. Asignar a metallb el rango de IPs que controlará.** Para esto, primero debemos verificar cuál es el rango de red de tipo en la ventana acoplable:

```shell
docker network inspect -f '{{.IPAM.Config}}' kind
```

Lo cual nos devolverá una subclase similar a 172.19.0.0/16. Tenemos que escoger un rango dentro de este, por ejemplo, en el caso anterior, las IPs de 172.19.255.200 a 172.19.255.250, y especificarlas en un configmap como el siguiente:

```yaml
# configmap_metallb.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.19.255.200-172.19.255.250
```

**4. Creamos el servicio de tipo LoadBalancer:**

```yaml
# loadbalancer-service.yaml
kind: Service
apiVersion: v1
metadata:  # esta é a parte de identificación do servizo
  name: servizo-loadbalancer
spec:
  type: LoadBalancer
  selector:  # esta é a parte de selección
    app: pod-web
  ports:  # esta é a parte de especificación propia
  - port: 6000
    targetPort: 80
```
Y obtenemos la IP externa con la que se creó:

```shell
> kubectl get svc/servizo-loadbalancer -o wide
NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)          AGE     SELECTOR
servizo-loadbalancer   LoadBalancer   10.96.64.63   172.18.255.200   6000:32131/TCP   2m42s   app=pod-web
```

**5. Ahora, con este LoadBalancer configurado, podemos hacer un `curl` a dicha IP para acceder a nuestro despliegue: **

```shell
curl 172.18.255.200:6000
```

