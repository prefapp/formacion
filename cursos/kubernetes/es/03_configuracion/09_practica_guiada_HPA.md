# Práctica guiada: empleo de la HPA

Usaremos un HPA para controlar la carga de una implementación simple.

## 1. Preparativos 🛫

- Comencemos desde un nuevo namespace en nuestro clúster: **hpa**

```shell
kubectl create namespace hpa
```

- Ahora vamos a desplegar un deployment que tiene una aplicación con uso intensivo de CPU. Para que pueda hacer el promedio y defina una sección de resources.requests para saber cuál es el consumo esperado de CPU/Memoria. Si no tiene estos valores, el hpa no podrá hacer los cálculos.

```yaml
#
# Vamos a crear un deploy para la aplicación
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
        resources:
          requests:
            cpu: 0.25
```
- Abrimos tráfico a través de un servicio:

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

Es interesante ver cómo no definimos el campo __replicas__ en el deployment. La razón es que no queremos interferir con el trabajo de la HPA.

Ahora si implementamos esto con kubectl:

```yaml
kubectl create -f <ficheiros yaml> -n hpa
```

Veremos que tenemos un servicio y un deployment con una réplica.

¡¡¡Empecemos con esto!!!


## 2. Nuestro servidor de métricas ⏱

Para esta práctica utilizaremos métricas de tipo recurso. Por tanto necesitamos una pieza o elemento que recopile métricas del clúster y las sirva en una de las capas de la API de kubernetes (concretamente en *metrics.k8s.io*).

Un elemento que nos puede servir es el [servidor de métricas](https://github.com/kubernetes-sigs/metrics-server).

Para instalarlo usaremos [Helm](07_Helm.md):

```yaml
# instalar helm (se non o está instalado)
# Podes ver as versións dispoñibles en: https://github.com/helm/helm/releases
wget https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz
tar zvxf helm-v3.9.0-linux-amd64.tar.gz
mv helm /usr/local/bin

# empregamos o chart para lanzar o metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm upgrade --install metrics-server metrics-server/metrics-server --set args="{--kubelet-insecure-tls}"
```

Si todo va bien, podremos realizar consultas a la api de nuestro clúster de prueba (en Kind):

```shell
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/kind-control-plane | jq

# Obtendremos algo parecido a esto

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

¡Ahora tenemos una forma de obtener métricas (CPU/Memoria) de nuestros pods!

Es hora de iniciar un HPA para nuestra aplicación.

## 3. Definición del HPA 📃

Nuestra aplicación hace un uso intensivo de la CPU, por lo que esta es la métrica clave para monitorear.

```yaml
apiVersion: autoscaling/v2
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
```

De hecho, en poco tiempo veremos que la implementación se escala a 1 réplica.

Sin embargo, si comprobamos el estado de nuestro hpa obtendremos lo siguiente:

```shell
kubectl get hpa -n hpa

NAME        REFERENCE                  TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   <unknown>/50%   1         10        1          2m41s
```

¿Por qué? La respuesta es que lleva un tiempo encontrar métricas, a menos que no esté bien configurada.

Ahora, vamos a generar tráfico para ti:

```shell
# Exportamos ó noso service ó porto 8084

kubectl port-forward svc/cpu-intensive -n hpa 8084:80
```

Y en otra terminal:

```shell
watch -n1 "curl localhost:8084/fibo/40"
```

Con esto nuestro servidor comenzará a generar tráfico. 

```shell
# este comando mantennos informados do estado
kubectl get hpa -n hpa -w

NAME        REFERENCE                  TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        1          7m55s
o-meu-hpa   Deployment/cpu-intensive   208%/50%   1         10        1          8m
o-meu-hpa   Deployment/cpu-intensive   306%/50%   1         10        5          8m16s
o-meu-hpa   Deployment/cpu-intensive   186%/50%   1         10        7          8m31s
```

Vemos como el tráfico empieza a ser absorbido por las nuevas réplicas que va levantando la HPA.

De esta forma, llega un momento en el que volvemos a estar por debajo del 50% del consumo medio.

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

Si detenemos el curl que genera tráfico, pronto vemos que el número de réplicas cae:

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

El HPA tardó unos 5 minutos en volver a establecer las réplicas en 1. Podemos modificar este comportamiento con la sección __behavior__.

4. El apartado del comportamiento: el control "fino" de nuestro HPA 🔬

**Nota:**: Para poder hacer esta sección, debes tener una versión de K8s que lo permita. Para comprobarlo, basta con hacer:

```yaml
# comprobar que está autoscaling/v2

kubectl api-versions | grep autoscaling/v2

autoscaling/v2
```

Y hacemos los siguientes cambios en nuestra definición de HPA:

```yaml
apiVersion: autoscaling/v2
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

En esta sección:

1. Establecemos una política que le permite descargar 5 pods cada 15 segundos.
2. Bajamos la ventana de estabilización a 30 segundos.

Ahora, y con el nuevo comportamiento que implementamos, el HPA puede bajar a pasos de 5 pods en períodos de 15 segundos.

Después de parchear nuestro HPA con este comportamiento.

Liberamos carga hasta escalar a 8 réplicas (con el curl anterior).

¡Cortamos el curl! Y vemos el comportamiento:

```shell
kubectl get hpa -n hpa -w

NAME        REFERENCE                  TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
o-meu-hpa   Deployment/cpu-intensive   47%/50%   1         10        8          2m13s
o-meu-hpa   Deployment/cpu-intensive   42%/50%   1         10        8          2m19s
o-meu-hpa   Deployment/cpu-intensive   5%/50%    1         10        8          2m34s
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        7          2m49s
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        2          3m5s
o-meu-hpa   Deployment/cpu-intensive   0%/50%    1         10        1          3m25s
```

Como vemos, se redujo a 1 réplica en un minuto de tiempo.
