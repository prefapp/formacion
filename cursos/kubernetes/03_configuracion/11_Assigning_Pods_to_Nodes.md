# Asignación de Pods a Nodos 🚀
*nodeSelector, nodeAffinity e nodeName*

📚 [Documentación oficial](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) 

![](https://vergaracarmona.es/wp-content/uploads/2022/10/Historia-de-los-contenedores.png)

En Kubernetes, os pods prográmanse nos nodos mediante *kube-scheduler*. O *kube-scheduler* é un proceso de *control-plane* que **asigna os pods ós nodos**. Determina qué nodos son lugares válidos para cada pod segundo as restriccións establecidas e os recursos dispoñibles. Nembargantes, pode haber casos nos que teñamos un pod que requira da GPU para funcionar segundo as nosas expectativas. Neste suposto, podemos necesitar controlar a programación do pod para asignalo a un nodo que teña GPU dispoñible.

Hai varias formas de controlar a programación (*kube-scheduler*) e tódolos enfoques recomendados utilizan *labels* para facilitar a selección.

## ✔️ Labels nos nodos

Antes de seguir avanzando, vexamos as sintaxis que nos servirán para manexar *labels* nos nodos:

Engadir label a un nodo:

``` shell
# Sintaxis
kubectl label nodes <NODE-NAME> <KEY>=<VALUE>

# Exemplo:
kubectl label nodes node01 gpu=yes

```

Listar os nodos coa columna de tódalas labels separadas por comas. Podemos concretar o nodo que queremos ver se poñemos seu nome:

``` shell
# Sintaxis
kubectl get nodes <NODE-NAME> --show-labels

# Exemplos:
kubectl get nodes --show-labels

kubectl get nodes nodo-01 --show-labels
```

Borrar unha label:

``` shell
# Sintaxis
kubectl label node <NODE-NAME> <LABEL>-

# Exemplo:
kubectl label node node01  gpu-
```

## ✔️ nodeSelector

`nodeSelector` é a forma máis sinxela de asignar pods ós nodos. Na `spec` do Pod podemos engadir o campo `nodeSelector` coas *labels* que ten noso nodo destino. Kubernetes só programará o Pod nos nodos que teñen as mesmas *labels*. 

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
    gpu: "yes" # Label pra seleccionar o nodo
```

⚠️ Se non hai nodos dispoñibles coa *label* especificada o Pod quedará en estado pendente.

### 🚧 Proba nodeSelector

Imos especificar unha etiqueta no arquivo de definición do pod que non está dispoñible na etiqueta do nodo.

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

Cre o pod co manifesto anterior e observe o seu estado:

``` shell
# Crear pod
kubectl create -f nginx-pod.yaml

# Inspeccionar os eventos do pod
kubectl describe pod nginx-pod  | grep -A5 Events
```

Saída:
```
Events:
  Type     Reason            Age    From               Message
  ----     ------            ----   ----               -------
  Warning  FailedScheduling  12m    default-scheduler  0/2 nodes are available: 2 node(s) didn't match Pod's node affinity/selector. preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.
```

Na demostración anterior, podemos ver que *nginx-pod* está nun estado pendente debido á falla de coincidencia de labels. Porén, temos que ter moito cuidado ó especificar unha label no arquivo de definición do Pod.

## ✔️ nodeAffinity

`nodeAffinity` funciona como `nodeSelector` pero é máis expresivo e permítenos especificar *soft rules*. Como vimos na fase anterior, se non hai nodos dispoñibels coa label especificada o pod quedará en estado pendente. Utilizando a regra de `nodeAffinity` podemos superar este problema de modo que o planificador despregue o Pod incluso se non pode atopar un nodo coincidente.

Tipos de `nodeAffinity`:

- `requiredDuringSchedulingIgnoredDuringExecution`: *kube-scheduler* non pode programar o Pod a menos que se cumpra a regra.
- `preferredDuringSchedulingIgnoredDuringExecution`: *kube-scheduler* intenta atopar un nodo que cumpra la regla. Se non hai un nodo que cumpra a regra, o planificador segue despregando o Pod.

A frase común entre os dous tipos de `nodeAffinity` é `IgnoredDuringExecution`. Significa que despois de programar un pod nun nodo, se a etiqueta que determinou a selección do nodo bórrase, o Pod executarase tal cal. O pod non se verá afectado.

Outra gran vantaxe da `nodeAffinity` é que podemos especificar unha lista de valores cun *operador*. Supoñamos que temos tres tipos de nodos dispoñibles e cada tipo está etiquetado como:
- `size: large`
- `size: medium`
- `size: small` 

Queremos asignar noso pod en nodos grandes e medianos. Nese caso, se utilizamos `nodeSelector`  poderemos especificar só unha *label* cada vez, sexa `size: large` ou `size: medium`. Pero se utilizamos `nodeAffinity` poderemos especificar ambas coma nunha lista de valores e o Pod despregarase nos dous nodos.

### 🔍 requiredDuringSchedulingIgnoredDuringExecution

Imos crear un despregue cunha regra de afinidade de nodo especificada no manifesto:

```yaml
# Exemplo 1 requiredDuringSchedulingIgnoredDuringExecution

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

Podemos utilizar o campo `operator` para especificar un operador lóxico que Kubernetes utilizará para implementar as regras. Pode ser `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt` e `Lt`.

```yaml
# Exemplo 2 requiredDuringSchedulingIgnoredDuringExecution

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

### 🔍 preferredDuringSchedulingIgnoredDuringExecution

Na regra `preferredDuringSchedulingIgnoredDuringExecution` podemos especificar un `weight` entre 1 e 100 para cada instancia. Se varios nodos cumpren os requisitos, *kube-scheduler* engade o valor do peso para esa expresión a unha suma. Os nodos co total máis alto priorízanse e os pods prográmanse no nodo que ten a maior prioridade.

Supoñamos que temos dous nodos que cumpren os requisitos: un con `size: large` e outro con `size: medium`. Nese caso *kube-scheduler* tendrá en conta o peso de cada nodo e engadirá o peso ás outras puntuacións para ese nodo e programará o Pod no nodo coa puntuación final máis alta.

```yaml
# Exemplo 1 preferredDuringSchedulingIgnoredDuringExecution

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

### 🚧 Proba preferredDuringSchedulingIgnoredDuringExecution

Despregar un pod con `nodeAffinity` tipo `preferredDuringSchedulingIgnoredDuringExecution`. Engadir especificacións á lista de valores que non están dispoñibles como unha *label* nos nodos.

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

Agora, despregamos o pod e observamos o estado:

```shell
kubectl create -f webserver-pod.yaml

kubectl get pods webserver
```

Saída:

```shell
--------------------------------------------------
NAME        READY   STATUS    RESTARTS   AGE
webserver   1/1     Running   0          4m4s
```

A diferenza do `nodeSelector`, aínda que non haxa ningunha *label* coincidente dispoñíbel nos nodos, os Pods despréganse igual. 

## ✔️ nodeName

`nodeName` é a forma máis directa de programar un pod no nodo desexado. Se o campo `nodeName` especifícase na `spec` do Pod, *kube-scheduler* intenta despregar o Pod no nodo indicado.

`nodeName` ten algunhas deficiencias:

- Se o nodo indicado non existe o Pod non se executará.
- Se o nodo indicado non ten os recursos para acomodar o Pod, o Pod non se executará.
- Os nomes dos nodos en entornos na nube non sempre son predecíbels ou estábels.

A continuación amósase un exemplo de manifesto dun Pod utilizando o campo `nodeName`:

```yaml
# Exemplo de nodeName
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







