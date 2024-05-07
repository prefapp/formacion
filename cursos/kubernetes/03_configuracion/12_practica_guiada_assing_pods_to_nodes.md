# Práctica guiada: Asignar Pods a nodos

Nesta práctica repasaremos as distintas formas para asignar Pods a nodos específicos dentro de noso clúster. A práctica desenvolverémola nun clúster local creado coa ferramenta Kind, pero o podemos facer da mesma maneira con calquera outra ferramenta de creación de clústers locais ou con calquera proveedor de cloud:
 -  [AWS](https://www.eksworkshop.com/beginner/140_assigning_pods/)
  -  [Azure](https://learn.microsoft.com/en-us/azure/aks/operator-best-practices-advanced-scheduler#control-pod-scheduling-using-node-selectors-and-affinity)
 - [RedHat](https://docs.openshift.com/container-platform/4.1/nodes/scheduling/nodes-scheduler-node-selectors.html)

Veremos como asociar un Pod a un nodo en concreto de distintas formas:
- Con `nodeSelector` no `spec` do manifesto. ([Ver](#_31-con-nodeselector-no-spec-do-manifesto))
- Con `nodeAffinity` no `spec` indicando unhas regras de dous tipos:
  - `requiredDuringSchedulingIgnoredDuringExecution`. ([Ver](#_321-deploy-practica-guiada-1))
  - `preferredDuringSchedulingIgnoredDuringExecution`. ([Ver](#_322-deploy-practica-guiada-2))
- Indicando o nome do nodo no `spec` con `nodeName`. ([Ver](#indicando-o-nome-do-nodo-no-spec-con-nodename))


## 1. Requísitos para a práctica ✏️
---
- É importante ter preparado noso laboratorio de probas, coma se apuntaba anteriormente, neste caso emplearase un clúster personalizado con Kind seguindo a "[Práctica guiada: crear un clúster personalizado con Kind](03_configuracion/10_practica_guiada_kind.md)".
- Se debe ler e dixerir a documentación "[Asignación de Pods a Nodos](03_configuracion/11_Assigning_Pods_to_Nodes.md)"
- Calquera duda consultar a [documentación oficial](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) de Kubernetes sobre a asignación de Pods a Nodos.


## 2. Preparativos 🛫
---
### 2.1 Creando o clúster con kind

Prepararemos un manifesto de configuración do clúster de Kind cun nodo control-plane e 3 workers. Debe constar:

- O nome do clúster será `practica-guiada-podstonode`
- O role de cada nodo (1 control-plane e 3 workers).
- Cada worker terá a label coa key `size` e os values {`large` | `medium` | `small`}

Manifesto completo:

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

Entrada
```shell
kind create cluster --config config_practica-guiada-PodsToNodos.yaml
```

Saída
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

Agora xa poderemos ver os nodos e súas etiquetas con `kubectl`:

```shell
kubectl get nodes --show-labels
```

Podemos especificar a columna concreta de saída deste modo:

```shell
kubectl get nodes -o custom-columns='NAME:metadata.name,'SIZE\ LABEL':metadata.labels.size'
```

Saída
```shell
NAME                                       SIZE LABEL
practica-guiada-podstonode-control-plane   <none>
practica-guiada-podstonode-worker          large
practica-guiada-podstonode-worker2         medium
practica-guiada-podstonode-worker3         small

```

Unha vez creado o clúster... dámonos conta que olvidámonos de indicar algunhas labels!

Son as seguintes:

- worker --> cpu=2, extra-ram=no
- worker2 --> cpu=4, extra-ram=yes
- worker3 --> cpu=8, extra-ram=yes


Non pasa nada, podemos indicalas mediante a seguinte sintaxis:

```shell
kubectl label nodes <NODE-NAME> <KEY>=<VALUE>
```

Os comandos serían os seguintes:

```shell
kubectl label nodes practica-guiada-podstonode-worker cpu=2 extraram=no

kubectl label nodes practica-guiada-podstonode-worker2 cpu=4 extraram=yes

kubectl label nodes practica-guiada-podstonode-worker3 cpu=8 extraram=yes
```

Podemos ver o resultado final das labels engadidas mediante o seguinte comando:

```shell
kubectl get nodes -o custom-columns="NAME:metadata.name,SIZE:metadata.labels.size,CPU:metadata.labels.cpu,EXTRA-RAM:metadata.labels.extraram"
```

Saída
```shell
NAME                                       SIZE     CPU      EXTRA-RAM
practica-guiada-podstonode-control-plane   <none>   <none>   <none>
practica-guiada-podstonode-worker          large    2        no
practica-guiada-podstonode-worker2         medium   4        yes
practica-guiada-podstonode-worker3         small    8        yes

```

## 3. Asignar pods a nodos concretos 🎯
---
Agora xa temos os nodos preparados coas súas labels, vaiamos pola faena.

### 3.1 Con nodeSelector no spec do manifesto.
Supoñamos que queremos asegurarnos que un pod de nginx alóxase nun nodo con máis memoria. Podemos aproveitar a label `extraram` con `nodeSelector`

```yaml
# noso-nginx.yaml

apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:  # Aquí indicamos a Label
    extraram: "yes"
```


Entrada
```shell
kubectl apply -f noso-nginx.yaml

kubectl get pods

```

Saída
```shell
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          7s

```

Comprobamos se quedou no nodo correcto. Podemos ver tódolos pods, o estado e seu nodo co seguinte comando:

```shell
kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces
```
Pero neste caso interésanos tan so o pod despregado coa etiqueta, se todo saiu ben debería estar no worker2 ou no worker3

Entrada
```shell
kubectl get pod/nginx-pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```

Saída
```shell
NAME        STATUS    NODE
nginx-pod   Running   practica-guiada-podstonode-worker3
```

Parece que tivemos éxito. 🏁


### 3.2 Con nodeAffinity no spec indicando unhas regras de dous tipos:
Agora imaxinemos que queremos despregar 2 Deploys baixo unhas regras concretas:
- **Deploy-practica-guiada-1**: 
  - Sabemos que utilizará ata 3 CPU. (Necesitamos un nodo de 3 ou máis cpu)
  - Necesitará un extra de ram.
  - Queremos 2 réplicas.
  - Non necesitará moito espazo, a prioridade é que cumpra os anteriores requisitos. 
  - É preferíbel que non esté dispoñible se non cumpre estas condiciones. 
- **Deploy-practica-guiada-2**: 
  - Necesitará moito espacio.
  - Queremos 3 réplicas
  - Interésanos a alta dispoñibilidade do mesmo, por ilo, aínda que non cumpra a regra é prioritario co deploy quede running. 

#### 3.2.1 <u>Deploy-practica-guiada-1</u>

Según os requisitos, para cumprir o obxectivo os pods débense despregar nestos nodos:

NAME                                   | SIZE   | CPU | EXTRA-RAM
--------------------------------------:|:------:|:---:|:---:
**practica-guiada-podstonode-worker2** | medium | 4   | yes
**practica-guiada-podstonode-worker3** | small  | 8   | yes

Para cumprir coa condición de que non este dispoñible se non está nun destes, utilizaremos o affinity de tipo `requiredDuringSchedulingIgnoredDuringExecution`. Dentro indicaremos os parámetros requeridos:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: cpu       # Primeira condición, na label cpu
          operator: gt   # Dámoslle un operador "maior que"
          values: "3"    # Co valor 3
        - key: extraram  # segunda condición, na label extraram
          operator: In   # Dámoslle un operador "dentro de"
          values: "yes"  # Co valor yes
```

O manifesto deploy quedará así:

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

Despregamos o pod e comprobamos onde se despregou:

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

Conseguímolo 🏁

#### 3.2.2 <u>Deploy-practica-guiada-2</u> 

Según os requisitos, para cumprir o obxectivo o pod débese despregar neste nodo:

NAME                                   | SIZE   | CPU | EXTRA-RAM
--------------------------------------:|:------:|:---:|:---:
**practica-guiada-podstonode-worker**  | large  | 2   | no

Para cumprir coa condición de que se despregue aínda que non esté large utilizaremos o affinity tipo `preferredDuringSchedulingIgnoredDuringExecution`. Dentro indicaremos os parámetros requeridos:

```yaml
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 50           
          preference:
            matchExpressions:
            - key: size       # Indicamoslle a label de size
              operator: In    # Indicamoslle o operador "Dentro de"
              values:
              - "large"       # Indicamos nosa prioridade no valor da label
```

O manifesto deploy quedará así:

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

Despregamos o pod e comprobamos onde se despregou:

```shell
kubectl apply -f Deploy-practica-guiada-2.yaml

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

Eureka! O temos! 🏁

#### 3.2.3 <u>Deploy-practica-guiada-3</u> 

Pero, qué pasaría se quiseramos neste último deploy un nodo coa etiqueta ultralarge? Desplegaríase igual?

Cambiamos o valor da etiqueta por `ultralarge`, despregamos e comprobamos:

```shell
kubectl apply -f Deploy-practica-guiada-2.yaml

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

Como podemos ver, os pods `practica-1-nginx-pod-3-...` repartíronse en calquera nodo sen importar a condición preferente que indicamos.

*Nota: para as anteriores comprobacións podes abrir unha segunda terminal e deixar monitorizando o comando engadindo diante `watch`:* 

```shell
watch kubectl get pods -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName 
```
*Cada tres segundos actualizará o comando automáticamente.*

### Indicando o nome do nodo no `spec` con `nodeName`.

Nesta ocasión imos despregar un pod indicando o nome do nodo onde queremos que se ubique con `nodeName`. O manifesto quedará así:

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
Despregamos e comprobamos:

```shell
kubectl apply -f Pod-nodename-practica-guiada.yaml

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

Isto é o que nos ten que lanzar o comando ó final da práctica. Veremos que noso último pod ubicouse exactamente onde indicamos en `spec`.

Despois das primeiras prácticas isto era moi fácil 🏁
