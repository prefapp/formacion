> Necesita traducción al gallego 👀

# Práctica guiada: Asignar Pods a nodos

En está práctica repasaremos las distintas formas para asginar Pods a los nodos de nuestro clúster. La práctica la desarrollaremos en un clúster local creado con la herramienta Kind, pero lo podemos hacer de la misma manera con cualquier otra herramienta de creación de clústers locales o con cualquier proveedor de cloud:
 -  [AWS](https://www.eksworkshop.com/beginner/140_assigning_pods/)
  -  [Azure](https://learn.microsoft.com/en-us/azure/aks/operator-best-practices-advanced-scheduler#control-pod-scheduling-using-node-selectors-and-affinity)
 - [RedHat](https://docs.openshift.com/container-platform/4.1/nodes/scheduling/nodes-scheduler-node-selectors.html)

Veremos como asociar un Pod a un nodo en concreto de distintas formas:
- Con `nodeSelector` en el `spec` del manifiesto. ([Ver](#con-nodeselector-en-el-spec-del-manifiesto))
- Con `nodeAffinity` en el `spec` indicando unas reglas de dos tipos:
  - `requiredDuringSchedulingIgnoredDuringExecution`. ([Ver](#requiredduringschedulingignoredduringexecution))
  - `preferredDuringSchedulingIgnoredDuringExecution`. ([Ver](#preferredduringschedulingignoredduringexecution))
- Indicando el nombre del nodo en el `spec` con `nodeName`. ([Ver](#indicando-el-nombre-del-nodo-en-el-spec-con-nodename))


## 1. Requísitos para la práctica ✏️
---
- Es importante tener preparado nuestro laboratorio de pruebas, como se apuntaba anteriormente, en este caso se empleará un clúster personalizado con Kind siguiendo la "[Práctica guiada: crear un clúster personalizado con Kind](10_practica_guiada_kind.md)".
- Se debe leer y digerir la documentación "[Asignación de Pods a Nodos](11_Assigning_Pods_to_Nodes.md)"
- Cualquier duda consultar la [documentación oficial](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) de Kubernetes sobre la asignación de Pods a Nodos.


## 2. Preparativos 🛫
---
### 2.1 Creando el clúster con kind

Prepararemos un manifiesto de configuración del clúster de Kind con un nodo control-plane y 3 workers. Debe constar:

- El nombre del clúster será `practica-guiada-podstonode`
- El role de cada nodo (1 control-plane y 3 workers).
- Cada worker tendrá la label con la key `size` y los values {`large` | `medium` | `small`}

Manifiesto completo:

```yaml
# config_practica-guiada-PodsToNodos.yaml

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: practica-guiada-podstonode
nodes:
- role: control-plane
- role: worker
  labels:
    size: large
- role: worker
  labels:
    size: medium
- role: worker
  labels:
    size: small

```

Input
```shell
kind create cluster --config config_practica-guiada-PodsToNodos.yaml
```

Output
```shell
Creating cluster "practica-guiada-podstonode" ...
 ✓ Ensuring node image (kindest/node:v1.25.2) 🖼
 ✓ Preparing nodes 📦 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-practica-guiada-podstonode"
You can now use your cluster with:

kubectl cluster-info --context kind-practica-guiada-podstonode

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
```

Ahora ya podremos ver los nodos y sus etiquetas con `kubectl`:

```shell
kubectl get nodes --show-labels
```

Podemos especificar la columna concreta de salida de este modo:

```shell
kubectl get nodes -o custom-columns='NAME:metadata.name,'SIZE\ LABEL':metadata.labels.size'
```

Output
```shell
NAME                                       SIZE LABEL
practica-guiada-podstonode-control-plane   <none>
practica-guiada-podstonode-worker          large
practica-guiada-podstonode-worker2         medium
practica-guiada-podstonode-worker3         small

```

Una vez creado el clúster ¡nos damos cuenta que nos hemos olvidado de indicar algunas labels!

Son las siguientes:

- worker --> cpu=2, extra-ram=no
- worker2 --> cpu=4, extra-ram=yes
- worker3 --> cpu=8, extra-ram=yes


No pasa nada, podemos indicarlas mediante la siguiente sintaxis:

```shell
kubectl label nodes <NODE-NAME> <KEY>=<VALUE>
```

Los comandos serían los siguientes:

```shell
kubectl label nodes practica-guiada-podstonode-worker cpu=2 extraram=no

kubectl label nodes practica-guiada-podstonode-worker2 cpu=4 extraram=yes

kubectl label nodes practica-guiada-podstonode-worker3 cpu=8 extraram=yes
```

Podemos ver el resultado final de las labels añadidas mediante el siguiente comando:

```shell
kubectl get nodes -o custom-columns="NAME:metadata.name,SIZE:metadata.labels.size,CPU:metadata.labels.cpu,EXTRA-RAM:metadata.labels.extraram"
```

Output
```shell
NAME                                       SIZE     CPU      EXTRA-RAM
practica-guiada-podstonode-control-plane   <none>   <none>   <none>
practica-guiada-podstonode-worker          large    2        no
practica-guiada-podstonode-worker2         medium   4        yes
practica-guiada-podstonode-worker3         small    8        yes

```

## 3. Asignar pods a nodos concretos 🎯
---
Ahora ya tenemos los nodos preparados con sus labels, vayamos a por faena.

### 3.1 Con nodeSelector en el spec del manifiesto.
Supongamos que queremos asegurarnos que un pod de nginx se aloja en un nodo con más memoria. Podemos aprovechar la label `extraram` con `nodeSelector`

```yaml
# nuestro-nginx.yaml

apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:  # Aquí indicamos la Label
    extraram: "yes"
```


Input
```shell
kubectl apply -f nuestro-nginx.yaml

kubectl get pods

```

Output
```shell
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          7s

```

Comprobamos si ha quedado en el nodo correcto. Podemos ver todos los pods, el estado y su nodo con el siguiente comando:

```shell
kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces
```
Pero en este caso nos interesa tan solo el pod desplegado con al etiqueta, si todo ha salido bien debería estar en el worker2 o en el worker3

Input
```shell
kubectl get pod/nginx-pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```

Output
```shell
NAME        STATUS    NODE
nginx-pod   Running   practica-guiada-podstonode-worker3
```

Parece que hemos tenido éxito. 🏁


### 3.2 Con nodeAffinity en el spec indicando unas reglas de dos tipos:
Ahora imaginemos que queremos desplegar 2 Deploys bajo unas reglas concretas:
- **Deploy-practica-guiada-1**: 
  - Sabemos que utilizará hasta 3 CPU. (Necesitamos un nodo de 3 o más cpu)
  - Necesitará un extra de ram.
  - Queremos 2 réplicas.
  - No necesitará mucho espacio, la prioridad es que cumpla los anteriores requisitos. 
  - Es preferible que no este disponible si no cumple estas condiciones. 
- **Deploy-practica-guiada-2**: 
  - Necesitará mucho espacio.
  - Queremos 3 réplicas
  - Nos interesa la alta disponibilidad del mismo, por ello, aunque no cumpla la regla es prioritario que el deploy quede running. 

#### 3.2.1 <u>Deploy-practica-guiada-1</u>

Según los requísitos, para cumplir el objetivo los pods se deben desplegar en estos nodos:

NAME                                   | SIZE   | CPU | EXTRA-RAM
--------------------------------------:|:------:|:---:|:---:
**practica-guiada-podstonode-worker2** | medium | 4   | yes
**practica-guiada-podstonode-worker3** | small  | 8   | yes

Para cumplir con la condición de que no este disponible si no está en uno de estos, utilizaremos el affinity de tipo `requiredDuringSchedulingIgnoredDuringExecution`. Dentro indicaremos los parámetros requeridos:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: cpu       # Primera condición, en la label cpu
          operator: gt   # Le damos un operador "mayor que"
          values: "3"    # Con el valor 3
        - key: extraram  # segunda condición, en la label extraram
          operator: In   # Le damos un operador "dentro de"
          values: "yes"  # Con el valor yes
```

El manifiesto deploy quedará así:

```yaml
# Deploy-practica-guiada-1.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: practica-1-nginx-pod
spec:
  selector:
    matchLabels:
      app: practica-1-nginx-pod
  replicas: 2
  template:
    metadata:
      labels:
        app: practica-1-nginx-pod
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: cpu
                operator: Gt
                values: 
                - "3"
              - key: extra-ram
                operator: In
                values: 
                - "yes"
      containers:
      - name: practica-1-nginx-pod
        image: nginx
```

Desplegamos el pod y comprobamos donde se ha desplegado:

```shell
kubectl apply -f Deploy-practica-guiada-1.yaml

kubectl get pod/nginx-pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```
```shell
NAME                                    STATUS    NODE
nginx-pod                               Running   practica-guiada-podstonode-worker3
practica-1-nginx-pod-6fcc76cff5-6q9lw   Running   practica-guiada-podstonode-worker2
practica-1-nginx-pod-6fcc76cff5-qmkv9   Running   practica-guiada-podstonode-worker3

```

Lo conseguimos 🏁

#### 3.2.2 <u>Deploy-practica-guiada-2</u> 

Según los requísitos, para cumplir el objetivo el pod se debe desplegar en este nodo:

NAME                                   | SIZE   | CPU | EXTRA-RAM
--------------------------------------:|:------:|:---:|:---:
**practica-guiada-podstonode-worker**  | large  | 2   | no

Para cumplir con la condición de que se despliegue aunque no este large utilizaremos el affinity tipo `preferredDuringSchedulingIgnoredDuringExecution`. Dentro indicaremos los parámetros requeridos:

```yaml
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 50           
          preference:
            matchExpressions:
            - key: size       # Le indicamos la label de size
              operator: In    # Le indicamos el operador "Dentro de"
              values:
              - "large"       # Indicamos nuestra prioridad en el valor de la label
```

El manifiesto deploy quedará así:

```yaml
# Deploy-practica-guiada-2.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: practica-1-nginx-pod-2
spec:
  selector:
    matchLabels:
      app: practica-1-nginx-pod-2
  replicas: 2
  template:
    metadata:
      labels:
        app: practica-1-nginx-pod-2
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 50
              preference:
                matchExpressions:
                - key: size
                  operator: In
                  values:
                  - "large"
      containers:
      - name: practica-1-nginx-pod-2
        image: nginx
```

Desplegamos el pod y comprobamos donde se ha desplegado:

```shell
kubectl apply -f Deploy-practica-guiada-1.yaml

kubectl get pods -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```
```shell
NAME                                      STATUS    NODE
nginx-pod                                 Running   practica-guiada-podstonode-worker3
practica-1-nginx-pod-2-668886fc8f-j5zsk   Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-2-668886fc8f-ss428   Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-6fcc76cff5-6q9lw     Running   practica-guiada-podstonode-worker2
practica-1-nginx-pod-6fcc76cff5-qmkv9     Running   practica-guiada-podstonode-worker3
```

¡Eureka! ¡Lo tenemos! 🏁

#### 3.2.3 <u>Deploy-practica-guiada-3</u> 

Pero ¿qué pasaría si quisieramos en este último deploy un nodo con la etiqueta ultralarge? ¿Se desplegaría igual?

Cambiamos el valor de la etiqueta por `ultralarge`, desplegamos y comprobamos:

```shell
kubectl apply -f Deploy-practica-guiada-1.yaml

kubectl get pods -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```

```shell
NAME                                      STATUS    NODE
nginx-pod                                 Running   practica-guiada-podstonode-worker3
practica-1-nginx-pod-2-9b84c6b74-4s7p4    Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-2-9b84c6b74-glx8k    Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-3-554c48cd76-jdcl5   Running   practica-guiada-podstonode-worker2
practica-1-nginx-pod-3-554c48cd76-zjbsl   Running   practica-guiada-podstonode-worker3
practica-1-nginx-pod-6fcc76cff5-6q9lw     Running   practica-guiada-podstonode-worker2
practica-1-nginx-pod-6fcc76cff5-qmkv9     Running   practica-guiada-podstonode-worker3
```

Como podemos ver, los pods `practica-1-nginx-pod-3-...` se han repartido en cualquier nodo sin importar la condición preferente que indicamos.

*Nota: para las anteriores comprobaciones puedes abrir una segunda terminal y dejar monitorizando el comando añadiendo delante `watch`:* 

```shell
watch kubectl get pods -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```
*Cada tres segundos actualizará el comando automáticamente.*

### Indicando el nombre del nodo en el `spec` con `nodeName`.

En esta ocasión vamos a desplegar un pod indicando el nombre del nodo en donde queremos que se ubique con `nodeName`. El manifiesto quedará así:

```yaml
# Pod-nodename-practica-guiada.yaml

apiVersion: v1
kind: Pod
metadata:
  name: nodename-practica-guiada
spec:
  containers:
  - name: nodename-practica-guiada
    image: nginx
  nodeName: practica-guiada-podstonode-worker

```
Desplegamos y comprobamos:

```shell
kubectl apply -f Deploy-practica-guiada-1.yaml

kubectl get pods -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```

```shell
NAME                                      STATUS    NODE
nginx-pod                                 Running   practica-guiada-podstonode-worker3
nodename-practica-guiada                  Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-2-9b84c6b74-4s7p4    Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-2-9b84c6b74-glx8k    Running   practica-guiada-podstonode-worker
practica-1-nginx-pod-3-554c48cd76-jdcl5   Running   practica-guiada-podstonode-worker2
practica-1-nginx-pod-3-554c48cd76-zjbsl   Running   practica-guiada-podstonode-worker3
practica-1-nginx-pod-6fcc76cff5-6q9lw     Running   practica-guiada-podstonode-worker2
practica-1-nginx-pod-6fcc76cff5-qmkv9     Running   practica-guiada-podstonode-worker3
```

Esto es lo que nos tiene que arrojar el comando al final de la práctica. Veremos que nuestro último pod se ha ubicado exactamente donde indicamos en `spec`.

Después de las primeras prácticas esto era muy fácil 🏁
