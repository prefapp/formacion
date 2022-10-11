# Artefactos en Kubernetes: o Deployment

Na sección anterior exploramos os Pods como artefacto básico de composición de aplicacións dentro de Kubernetes. 

A pesar de ser un concepto clave para entender o resto do sistema, a verdade é que **rara vez imos empregar directamente un pod** no noso traballo en Kubernetes. A meirande parte do tempo imos traballar con Deployments. 

## a) Por qué deployments?

Os deployments agregan "intelixencia" ós nosos pods, é dicir, trátase de elementos externos ós pods que os controlan e inspeccionan de xeito constante para poder:

- Vixilar (o número de pods correndo é exactamente o especificado). 
- Escalalos (aumentar ou reducir o seu número segundo as necesidades establecidas)
- Actualizalos: permiten un cambio de configuración ou de imaxe dos pods dun xeito controlado. 
- Pausalos / reanudalos

![Deploy1](./../_media/02/deployment.png)

## b) Definir un Deployment

Para definir un deployment, temos que pensar que se trata dunha estrutura que está por enriba do pod:

![Deploy2](./../_media/02/deployment2.png)

No seguinte exemplo:

- Imos crear un deployment de nome "despregue-nginx". 
- Ten a capacidade de despregar pods de nginx. En cada pod correrá un contedor cunha imaxe de nginx.
- O contedor ten exposto o porto 80.

```yaml
# deployment_1.yaml

apiVersion: apps/v1
kind: Deployment  # esta parte define o Deployment
metadata:
  name: despregue-nginx
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template: # a partir de aquí definimos o pod
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

Se enviamos este ficheiro ó kubernetes:

```shell
microk8s.kubectl apply -f deployment_1.yaml
```

Veremos como se crea un pod.

```shell
despregue-nginx-6dd86d77d-4prgf   0/1     Pending       0          0s
despregue-nginx-6dd86d77d-4prgf   0/1     ContainerCreating   0          0s
despregue-nginx-6dd86d77d-4prgf   1/1     Running             0          2s
```

E teremos un novo tipo de artefacto: o deployment. 

Podemos listalos:

```shell
microk8s.kubectl get deploy
```

E veremos

```shell
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
despregue-nginx   1/1     1            1           7m48s
```

### i) A tarefa de "vixiante" do deployment

Se agora listásemos os pods que temos correndo, e borrásemos o pod de nginx:

```shell
# o nome variará na vosa máquina
 microk8s.kubectl delete pod despregue-nginx-976fb94cd-l8ksl
 ```

Veremos que se borra o pod e que, inmediatamente, se creou un novo:

```shell
despregue-nginx-976fb94cd-l8ksl   1/1     Running   0          90s
despregue-nginx-976fb94cd-l8ksl   1/1     Terminating   0          2m42s
despregue-nginx-976fb94cd-ngw7t   0/1     Pending       0          0s
despregue-nginx-976fb94cd-ngw7t   0/1     ContainerCreating   0          0s
despregue-nginx-976fb94cd-ngw7t   1/1     Running             0          1s
```

Qué pasou? Por qué se borrou ese pod e se creou un novo?

A razón está no deployment.

1. O deployment está a vixilar os pods (neste caso hai un só)
2. Borramos o pod a man (mediante delete pod)
3. O deployment detecta que non está a correr o pod
4. Inmediatamente crea un novo pod coa mesma configuración e imaxe

É dicir: o deployment controla calqueira alteración ou falla dos pods e procura que o sistema se "recupere" da caída. 

### ii) A tarefa de escalado / degradado do deployment

Neste momento, temos un pod solo correndo o nginx. Imaxinemos que queremos correr tres pods (tres réplicas, posto que terían todos a mesma configuración).

Podemos facer este traballo directamente con [kubectl scale](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment):

```shell
 microk8s.kubectl scale deploy despregue-nginx --replicas=3
```

Se vemos os pods teremos:

```shell
>  microk8s.kubectl get pods -w

despregue-nginx-976fb94cd-ngw7t   1/1     Running   0          7m28s
despregue-nginx-976fb94cd-4z54k   0/1     Pending   0          0s
despregue-nginx-976fb94cd-v2jrc   0/1     Pending   0          0s
despregue-nginx-976fb94cd-4z54k   0/1     ContainerCreating   0          0s
despregue-nginx-976fb94cd-v2jrc   0/1     ContainerCreating   0          0s
despregue-nginx-976fb94cd-v2jrc   1/1     Running             0          1s
despregue-nginx-976fb94cd-4z54k   1/1     Running             0          2s
```


E se listamos os deployments:

```shell
> microk8s.kubectl get deploy

NAME              READY   UP-TO-DATE   AVAILABLE   AGE
despregue-nginx   3/3     3            3           22m
```

Para voltar á situación inicial dunha soa réplica (pods = 1), abondaría con facer:

```shell
microk8s.kubectl scale deploy despregue-nginx --replicas=1
```

E veríamos como dous pods serían eliminados restando soamente un deles. 

![Deploy3](./../_media/02/deployment3.png)

### iii) A tarefa de actualización de pods do deployment

Nestes exemplos estamos a correr a versión 1.7.9 do nginx. Imaxinemos que queremos correr a versión 1.15. 

Para isto, tamén nos podemos servir do deployment e facer unha actualización ordenada e "civilizada" dos nosos pods. 

Asumamos, tamén, que queremos deixar constancia do cambio no noso artefacto orixinal (deployment_1.yaml)

Imos editalo e modificar a liña de image do mesmo:

```yaml
# deployment_1.yaml

apiVersion: apps/v1
kind: Deployment  # esta parte define o Deployment
metadata:
  name: despregue-nginx
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template: # a partir de aquí definimos o pod
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15 # este é o cambio!!!!
        ports:
        - containerPort: 80
```

Basta con aplicar de novo este ficheiro modificado:

```shell
# aplicamos o ficheiro
microk8s.kubectl apply -f deployment_1.yaml

# facemos un listado dos pods
microk8s.kubectl get pods -w
```

Veremos que os pods iniciales poñense a estado "terminating" e se lanzan uns novos (coa nova imaxe). 

O deploy encárgase de facer esta tarefa por nos. 

Se non queremos modificar o código yaml do noso ficheiro de deploy, existe outra opción: **a edición do artefacto existente en Kubernetes**. 

Compre empregar o comando **edit**:

```shell
microk8s.kubectl edit deploy despregue-nginx
```

O comando kubectl abrirá unha instancia de vim co código en yaml do artefacto para poder facer cambios que, unha vez gardados, faránse automáticamente no deploy e nos seus pods. 








