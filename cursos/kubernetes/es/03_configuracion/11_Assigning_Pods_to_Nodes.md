# Asignación de Pods a Nodos
nodeSelector, nodeAffinity y nodeName. 

[Documentación oficial](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) 

![](https://vergaracarmona.es/wp-content/uploads/2022/10/Historia-de-los-contenedores.png)

En Kubernetes, los pods se programan en los nodos mediante *kube-scheduler*. El *kube-scheduler* es un proceso de *control-plane* que **asigna los pods a los nodos**. Determina qué nodos son lugares válidos para cada pod según las restricciones establecidas y los recursos disponibles. Sin embargo, puede haber casos en los que tengamos un pod que requiera de la GPU para funcionar según nuestras expectativas. En este supuesto, podemos necesitar controlar la programación del pod para asignar el pod a un nodo que tenga GPU disponible.

Hay varias formas de controlar la programación (*kube-scheduler*) y todos los enfoques recomendados utilizan *labels* para facilitar la selección.

## Labels en los nodos

Antes de seguir avanzando, veamos las sintaxis que nos servirán para manejar *labels* en los nodos:

Añadir label a un nodo:

``` shell
# Sintaxis
kubectl label nodes <NODE-NAME> <KEY>=<VALUE>

# Ejemplo:
kubectl label nodes node01 gpu=yes

```

Listar los nodos con la colunma de todas las labels separadas por comas. Podemos concretar el nodo que queremos ver si ponemos su nombre:

``` shell
# Sintaxis
kubectl get nodes <NODE-NAME> --show-labels

# Ejemplos:
kubectl get nodes --show-labels

kubectl get nodes nodo-01 --show-labels
```

Borrar una label:

``` shell
# Sintaxis
kubectl label node <NODE-NAME> <LABEL>-

# Ejemplo:
kubectl label node node01  gpu-
```

## nodeSelector

`nodeSelector` es la forma más sencilla de asignar pods a los nodos. En la `spec` del Pod podemos añadir el campo `nodeSelector` con las *labels* que tiene nuestro nodo destino. Kubernetes sólo programará el Pod en los nodos que tienen las mismas *labels*. 

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector: 
    gpu: "yes" # Label para seleccionar el nodo
```

⚠️ Si no hay nodos disponibles con la *label* especificada el Pod quedará en estado pendiente.

### Prueba nodeSelector

Vamos a especificar una etiqueta en el archivo de definición del pod que no está disponible en la etiqueta del nodo.

```yaml
# nginx-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    ssd: "yes"
```

Cree el pod con el manifiesto anterior y observe el estado del pod:

``` shell
# Crear pod
kubectl create -f nginx-pod.yaml

# Inspeccionar los eventos del pod
kubectl describe pod nginx-pod  | grep -A5 Events
```

Output:
```
Events:
  Type     Reason            Age    From               Message
  ----     ------            ----   ----               -------
  Warning  FailedScheduling  12m    default-scheduler  0/2 nodes are available: 2 node(s) didn't match Pod's node affinity/selector. preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.
```

En la demostración anterior, podemos ver que *nginx-pod* está en un estado pendiente debido a la falta de coincidencia de labels. Por lo tanto, tenemos que tener mucho cuidado al especificar una label en el archivo de definición del Pod.

## nodeAffinity

`nodeAffinity` funciona como `nodeSelector` pero es más expresivo y nos permite especificar *soft rules*. Como hemos visto en la fase anterior, si no hay nodos disponibles con la label especificada el pod quedará en estado pendiente. Utilizando la regla de `nodeAffinity` podemos superar este problema de modo que el planificador despliegue el Pod incluso si no puede encontrar un nodo coincidente.

Tipos de `nodeAffinity`:

- `requiredDuringSchedulingIgnoredDuringExecution`: *kube-scheduler* no puede programar el Pod a menos que se cumpla la regla.
- `preferredDuringSchedulingIgnoredDuringExecution`: *kube-scheduler* intenta encontrar un nodo que cumpla la regla. Si no hay un nodo que cumpla la regla, el planificador sigue desplegando el Pod.

La frase común entre los dos tipos de `nodeAffinity` es
`IgnoredDuringExecution`. Significa que después de programar un pod en un nodo, si la etiqueta que determinó la selección del nodo se borra, el Pod se ejecutará tal cual. El pod no se verá afectado.

Otra gran ventaja de la `nodeAffinity` es que podemos especificar una lista de valores con un *operador*. Supongamos que tenemos tres tipos de nodos disponibles y cada tipo está etiquetado como:
- `size: large`
- `size: medium`
- `size: small` 

Queremos asignar nuestro pod en nodos grandes y medianos. En ese caso, si utilizamos `nodeSelector`  podremos especificar solo una *label* cada vez, ya sea `size: large` o `size: medium`. Pero si usamos `nodeAffinity` podremos especificar ambas como en una lista de valores y el Pod se desplegará en el los dos nodos.

### requiredDuringSchedulingIgnoredDuringExecution

Vamos a crear un despliegue con una regla de afinidad de nodo especificada en el manifiesto:

```yaml
# Ejemplo 1 requiredDuringSchedulingIgnoredDuringExecution

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: webserver
  name: webserver
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webserver
    spec:
       affinity:
         nodeAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             nodeSelectorTerms:
             - matchExpressions:
               - key: size
                 operator: In
                 values:
                 - large
                 - medium
       containers:
        - image: nginx
          name: webserver
```

Podemos utilizar el campo `operator` para especificar un operador lógico que Kubernetes utilizará para implementar las reglas. Puede ser `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt` y `Lt`.

```yaml
# Ejemplo 2 requiredDuringSchedulingIgnoredDuringExecution

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: webserver
  name: webserver
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webserver
    spec:
       affinity:
         nodeAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             nodeSelectorTerms:
             - matchExpressions:
               - key: Size
                 operator: Exists
       containers:
        - image: nginx
          name: webserver
```

### preferredDuringSchedulingIgnoredDuringExecution

En la regla `preferredDuringSchedulingIgnoredDuringExecution` podemos especificar un `weight` entre 1 y 100 para cada instancia. Si varios nodos cumplen los requisitos, *kube-scheduler* añade el valor del peso para esa expresión a una suma. Los nodos con el total más alto se priorizan y los pods se programan en el nodo que tiene la mayor prioridad.

Supongamos que tenemos dos nodos que cumplen los requisitos: uno con `size: large` y otro con `size: medium`. En ese caso *kube-scheduler* tendrá en cuenta el peso de cada nodo y añadirá el peso a las otras puntuaciones para ese nodo y programará el Pod en el nodo con la puntuación final más alta.

```yaml
# Ejemplo 1 preferredDuringSchedulingIgnoredDuringExecution

apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 15
          preference:
            matchExpressions:
            - key: size
              operator: In
              values:
              - large
        - weight: 20
          preference:
            matchExpressions:
            - key: size
              operator: In
              values:
              - medium
  containers:
  - name: webserver
    image: nginx
```

### Prueba preferredDuringSchedulingIgnoredDuringExecution

Desplegar un pod con `nodeAffinity` tipo `preferredDuringSchedulingIgnoredDuringExecution`. Añadir especificaciones a la lista de valores que no están disponibles como una *label* en los nodos.

```yaml
# webserver-pod.yamlapiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 15 # peso 1
          preference:
            matchExpressions:
            - key: key
              operator: In
              values: # valores
              - bar
              - foo
        - weight: 20 # peso 2
          preference:
            matchExpressions:
            - key: key
              operator: In
              values: # valores
              - foo
              - bar
  containers:
  - name: webserver
    image: nginx
```

Ahora, desplegamos el pod y observamos el estado:

```shell
kubectl create -f webserver-pod.yaml

kubectl get pods webserver
```

Output:

```shell
--------------------------------------------------
NAME        READY   STATUS    RESTARTS   AGE
webserver   1/1     Running   0          4m4s
```

A diferencia del `nodeSelector`, aunque no haya ninguna *label* coincidente disponible en los nodos, los Pods se despliegan igual. 

## nodeName

`nodeName` es la forma más directa de programar un pod en el nodo deseado. Si el campo `nodeName` se especifica en la `spec` del Pod, *kube-scheduler* intenta desplegar el Pod en el nodo indicado.

Hay algunas deficiencias de `nodeName`:

- Si el nodo indicado no existe el Pod no se ejecutará.
- Si el nodo indicado no tiene los recursos para acomodar el Pod, el Pod no se ejecutará.
- Los nombres de los nodos en entornos cloud no siempre son predecibles o estables.

A continuación se muestra un ejemplo de manifiesto de un Pod utilizando el campo `nodeName`:

```yaml
# Ejemplo de nodeName
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: node01
```







