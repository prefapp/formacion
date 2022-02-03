# Práctica guiada: emprego do HPA

Imos empregar un HPA para controlar a carga dun deployment sinxelo. 

## 1. Preparativos 🛫

- Imos partir dun namespace novo no noso cluster: **hpa**

```bash

kubectl create namespace hpa 

```

- Agora imos despregar un deployment que teña unha aplicación de emprego intensivo de cpu

```yaml

#
# Imos crear un deploy para a aplicación
#

apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-intensive
  labels:
    app: cpu-intensive
    concern: test
spec:
  selector:
    matchLabels:
      app: cpu-intensive
      concern: test
  template:
    metadata:
      labels:
        app: cpu-intensive
        concern: test
    spec:
      containers:
      - name: app
        image: frmadem/k8s-training-cpu-intensive-app:v1
        ports:
        - containerPort: 8080

```
- Abrimoslle tráfico mediante un service:

```yaml

#
# Abrímoslle tráfico mediante un service
#

apiVersion: v1
kind: Service
metadata:
  name: cpu-intensive
spec:
  selector:
    app: cpu-intensive
    concern: test
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080

```

É interesante ver cómo non definimos o campo __replicas__ no deployment. A razón é que non queremos que interferir co traballo do HPA. 

Agora se aplicamos isto co kubectl:

```yaml

kubectl create -f <ficheiros yaml> -n hpa

```

Veremos que temos un service e un deployment con 0 réplicas. 

Imos facer que esto comece a andar!!!


## 2. O noso servidor de métricas ⏱

Para esta práctica imos empregar métricas de tipo resource. Polo tanto necesitamos unha peza ou elemento que recolla métricas do clúster e as sirva nunha das Layer do Api de kubernetes (concretamente no metrics.k8s.io).


Un elemento que nos pode servir é o [metrics server](https://github.com/kubernetes-sigs/metrics-server).

Para instalalo imos empregar [Helm]():

```yaml

# instalar helm (se non o está instalado)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# empregamos o chart para lanzar o metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm upgrade --install metrics-server metrics-server/metrics-server --set args="{--kubelet-insecure-tls}"

```

Se todo vai ben poderemos facer xa consultas ó api do noso cluster de probas (en Kind):

```
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/kind-control-plane | jq

# Obteremos algo parecido a esto

{
  "kind": "NodeMetrics",
  "apiVersion": "metrics.k8s.io/v1beta1",
  "metadata": {
    "name": "kind-control-plane",
    "creationTimestamp": "2022-02-02T10:14:14Z",
    "labels": {
      "beta.kubernetes.io/arch": "amd64",
      "beta.kubernetes.io/os": "linux",
      "kubernetes.io/arch": "amd64",
      "kubernetes.io/hostname": "kind-control-plane",
      "kubernetes.io/os": "linux",
      "node-role.kubernetes.io/control-plane": "",
      "node-role.kubernetes.io/master": "",
      "node.kubernetes.io/exclude-from-external-load-balancers": ""
    }
  },
  "timestamp": "2022-02-02T12:14:09Z",
  "window": "20.219s",
  "usage": {
    "cpu": "242713548n",
    "memory": "707676Ki"
  }
}

```

Xa temos un xeito de obter métricas (CPU/Memoria) dos nosos pods!

É o momento de arrancar un HPA para a nosa app. 

## 3. Definindo o HPA 📃

A nosa app fai un uso intensivo de CPU polo tanto é a métrica clave para a controlar.

```yaml

apiVersion: autoscaling/v2beta2 # hai varias versións en funcionamento a día de hoxe
kind: HorizontalPodAutoscaler

metadata:
  name: o-meu-hpa  

spec: 

  #-------------------------------------------------
  # Esta é a parte de selección de pods a escalar
  #-------------------------------------------------
  scaleTargetRef: 
    kind: Deployment
    name: cpu-intensive


  #-------------------------------------------------
  # Nesta parte establecemos os límites do escalado
  #-------------------------------------------------
  minReplicas: 1
  maxReplicas: 2

  
  #---------------------------------------------------
  # Nesta sección definimos os criterios (métricas)
  # segundo as que escalar
  #---------------------------------------------------
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50  

```

Efectivamente, ó pouco tempo veremos que nos escala o deploy a 1 réplica. 

Non obstante, de consultar o estado do noso hpa obteremos o seguinte:

```bash
kubectl get hpa -n hpa

NAME        REFERENCE                  TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   <unknown>/50%   1         10        1          2m41s
```

Por qué? A resposta é que tarda un pouco en atopar métricas, salvo que non esté ben configurado. 

Agora, imos xerarlle tráfico:

```bash
# Exportamos ó noso service ó porto 8084

kubectl port-forward svc/cpu-intensive -n hpa 8084:80

```

E noutro terminal:

```bash
watch -n1 "curl localhost:8084/fibo/40"
```

Con isto comenzará a xerar tráfico o noso servidor. 

```bash
# este comando mantennos informados do estado
kubectl get hpa -n hpa -w                                                                          

NAME        REFERENCE                  TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        1          7m55s
o-meu-hpa   Deployment/cpu-intensive   208%/50%   1         10        1          8m
o-meu-hpa   Deployment/cpu-intensive   306%/50%   1         10        5          8m16s
o-meu-hpa   Deployment/cpu-intensive   186%/50%   1         10        7          8m31s
```

Vemos como o tráfico comeza a ser absorbido polas novas réplicas que o HPA vai levantando.

Deste xeito, chega un momento que volvemos a estar por debaixo 50% de media de consumo

```bash
kubectl get hpa -n hpa

NAME        REFERENCE                  TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   306%/50%   1         10        5          8m16s
o-meu-hpa   Deployment/cpu-intensive   186%/50%   1         10        7          8m31s
o-meu-hpa   Deployment/cpu-intensive   58%/50%    1         10        7          8m46s
o-meu-hpa   Deployment/cpu-intensive   48%/50%    1         10        7          9m1s
o-meu-hpa   Deployment/cpu-intensive   51%/50%    1         10        7          9m16s
o-meu-hpa   Deployment/cpu-intensive   48%/50%    1         10        7          9m31s
o-meu-hpa   Deployment/cpu-intensive   48%/50%    1         10        7          10m
o-meu-hpa   Deployment/cpu-intensive   48%/50%    1         10        7          10m
o-meu-hpa   Deployment/cpu-intensive   49%/50%    1         10        7          10m
o-meu-hpa   Deployment/cpu-intensive   49%/50%    1         10        7          11m
o-meu-hpa   Deployment/cpu-intensive   47%/50%    1         10        7          11m
o-meu-hpa   Deployment/cpu-intensive   48%/50%    1         10        7          11m
o-meu-hpa   Deployment/cpu-intensive   52%/50%    1         10        7          11m
o-meu-hpa   Deployment/cpu-intensive   47%/50%    1         10        7          12m
``` 

Se paramos o curl que xera tráfico, o pouco tempo vemos que o número de réplicas baixa:

```bash
NAME        REFERENCE                  TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   45%/50%   1         10        8          20m
o-meu-hpa   Deployment/cpu-intensive   32%/50%   1         10        8          20m
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        8          20m
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        8          25m
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        6          25m
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        4          25m
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        2          26m
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        1          26m

```
O HPA tardou aproximadamente 5 min e volver a poñer as réplicas a 1. Podemos modificar este comportamento cunha sección __behavior__. 

4. A sección behavior: o control "fino" do noso HPA 🔬

**Nota:**: para poder facer esta sección, compre ter unha versión de K8s que o permita. Para comprobalo abonda con facer:

```yaml
# comprobar que está autoscaling/v2beta2

kubectl api-versions | grep autoscaling/v2beta2

autoscaling/v2beta2

```

E metemos os seguintes cambios na definición do noso HPA:

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler

metadata:
  name: o-meu-hpa  

spec: 

  #-------------------------------------------------
  # Esta é a parte de selección de pods a escalar
  #-------------------------------------------------
  scaleTargetRef: 
    apiVersion: apps/v1
    kind: Deployment
    name: cpu-intensive


  #-------------------------------------------------
  # Nesta parte establecemos os límites do escalado
  #-------------------------------------------------
  minReplicas: 1
  maxReplicas: 10

  
  #---------------------------------------------------
  # Nesta sección definimos os criterios (métricas)
  # segundo as que escalar
  #---------------------------------------------------
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50  

  #
  # Control da desescalada
  #
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
      policies:
      - type: Pods
        value: 5
        periodSeconds: 15

```


Nesta sección:

1. Establecemos unha política que permite baixar de 5 en 5 pods cada 15 seg. 
2. A ventá de estabilización a baixamos a 30 seg. 

Agora, e co novo behavior que puxemos, o HPA é quen de baixar a escalóns de 5 pod en períodos de 15 segundos. 

Despois de parchear o noso HPA con este behavior. 

Lanzamos carga ata que escale a 8 réplicas (co curl anterior). 

Cortamos o curl!. 

Se vemos o comportamento:

```bash
kubectl get hpa -n hpa -w                                                                        

NAME        REFERENCE                  TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   47%/50%   1         10        8          2m13s
o-meu-hpa   Deployment/cpu-intensive   42%/50%   1         10        8          2m19s
o-meu-hpa   Deployment/cpu-intensive   5%/50%    1         10        8          2m34s
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        7          2m49s
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        2          3m5s
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        1          3m25s

```

Como vemos baixou a 1 réplica nun minuto de tempo.




