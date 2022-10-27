# Artefactos en Kubernetes: Pod

Para poder desplegar y controlar aplicaciones en Kubernetes, se ponen a disposición de los usuarios una serie de elementos básicos que actúan como bloques de construcción a través de los cuales se puede expresar una topología y estructura muy flexible que se ajuste a las necesidades de cada caso.

Antes de lanzarse a crear cualquier artefacto de Kubernetes, recuerde que debe estar conectado a un clúster. En nuestro caso, dado que usamos clústeres locales para las pruebas, crearemos un clúster con Tipo, si no lo hemos hecho antes:

```shell
kind create cluster
```

Lo que sigue es una descripción de los elementos principales y su relación con el resto del sistema.

## Pod

Un [pod](https://kubernetes.io/docs/concepts/workloads/pods/) es el elemento mínimo o atómico dentro de Kubernetes.

No podemos pensar en un pod como un contenedor: el pod consta de 1..n contenedores **agrupados lógicamente por su función.**

Por lo tanto, los contenedores desplegados dentro de un pod:

- Siempre se desplegarán de forma conjunta en un único nodo o servidor.
- Comparten configuraciones de red.
- Comparten volúmenes y almacenamiento.

![Pod](./../_media/02/pod1.png)

En un pod agruparemos todos aquellos procesos (aislados en contenedores) que tienen que funcionar "uno al lado del otro":

- podrán hablar a través de la publicación localhost
- constituyen una unidad de despliegue por lo que facilitan el escalado horizontal de la aplicación.
- pueden compartir volúmenes que "sobreviven" a los reinicios y aquellos a los que tienen acceso el resto de procesos.

### a) Definición de Pod

Para definir un pod, Kubernetes nos proporciona un lenguaje potente y descriptivo que utiliza YAML como sintaxis básica.

En el pod de ejemplo que vamos a crear:

- Solo tendremos un contenedor que monte una imagen de ubuntu
- El contenedor dentro de la cápsula, en realidad no hace nada, solo espera

En un archivo en blanco ingresamos lo siguiente:

```yaml
# pod_1.yaml

kind: Pod # o artefacto é un Pod
apiVersion: v1  # a versión da api a empregar
metadata:
  name: primeiro-pod  # o nome do pod
spec:
  containers:
    - name: contedor  # o nome do contedor dentro do pod
      image: ubuntu
      command: ["/usr/bin/tail", "-f", "/dev/null"]
  restartPolicy: Never
```

Como podemos ver, usamos un lenguaje declarativo para expresar lo que queremos, ahora, solo use la herramienta kubectl para que este pod "aparezca" en nuestra instalación de Kubernetes.

```shell
kubectl apply -f pod_1.yaml
```

La herramienta kubectl se comunica con la API en el maestro y se registra una nueva estructura. El sistema verifica que no exista tal pod dentro de los nodos y marca el pod como "necesita ser creado". El planificador elige un nodo donde ejecutar el pod y se inicia a través de Kubelet.

Si ejecutamos este comando

```shell
kubectl get pods
```

Veremos la siguiente salida.

```shell
primeiro-pod   0/1     Pending       0          0s
primeiro-pod   0/1     ContainerCreating   0          0s
primeiro-pod   1/1     Running             0          2s
```

El pod se está ejecutando "en algún lugar" dentro de nuestro clúster.

¿Dónde? realmente no nos importa; y ese es precisamente uno de los puntos clave de Kubernetes: hacer transparente al usuario la complejidad del clúster y crear una “vista” del mismo como si fuera una sola máquina.

### b) Interactuar con el pod

Como vimos en la sección anterior, Kubernetes utiliza un lenguaje declarativo que permite expresar un "debe ser". Luego, usando la herramienta kubectl podemos cargar ese "debe ser" en el sistema que lo aplicará para hacerlo realidad dentro del clúster.

Ya vimos cómo enumerar pods en la sección anterior.

Si quisiéramos tener más detalles de nuestro pod, podríamos hacer:

```shell
kubectl describe pod/primeiro-pod
```

Y obtendríamos muchos datos:

```shell
Name:               primeiro-pod
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               sutelinco/10.0.2.15
Start Time:         Thu, 11 Apr 2019 23:53:23 +0000
Labels:             <none>
Annotations:        kubectl.kubernetes.io/last-applied-configuration:
                      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"primeiro-pod","namespace":"default"},"spec":{"containers":[{"command"...
Status:             Running
IP:                 10.1.1.10
Containers:
  contedor:
    Container ID:  containerd://d5648ba53e23fd45e85f3ee52942694ea8ac51d98eaee453c0189d1fdc17935d
    Image:         ubuntu
    Image ID:      docker.io/library/ubuntu@sha256:017eef0b616011647b269b5c65826e2e2ebddbe5d1f8c1e56b3599fb14fabec8
    Port:          <none>
    Host Port:     <none>
    Command:
      /usr/bin/tail
      -f
      /dev/null
    State:          Running
      Started:      Thu, 11 Apr 2019 23:53:25 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-g42tp (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-g42tp:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-g42tp
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                Message
  ----    ------     ----  ----                -------
  Normal  Scheduled  15m   default-scheduler   Successfully assigned default/primeiro-pod to sutelinco
  Normal  Pulling    15m   kubelet, sutelinco  Pulling image "ubuntu"
  Normal  Pulled     15m   kubelet, sutelinco  Successfully pulled image "ubuntu"
  Normal  Created    15m   kubelet, sutelinco  Created container contedor
  Normal  Started    15m   kubelet, sutelinco  Started container contedor
```

Si quisiéramos "ingresar" al pod, podríamos usar exec:

```shell
# indicamos o pod e o contedor no que queremos "ingresar"
kubectl exec -ti primeiro-pod -c contedor -- bash
```

Tenga en cuenta que la sintaxis del comando es muy similar a [exec] de Docker (https://docs.docker.com/engine/reference/commandline/exec/).

Una vez ejecutado, tendríamos un caparazón dentro del contenedor y podríamos interactuar con el sistema ubuntu que se monta como una imagen.

Para eliminarlo, simplemente pasamos nuestro archivo yaml al sistema:

```shell
kubectl delete -f pod_1.yaml
```
### c) Establecer variables de entorno en el pod

Para aquellos familiarizados con los contenedores de software, no es desconocido que la mayor parte de la configuración se inyecta a través de variables de entorno para poder controlar el programa desde "afuera".

Kubernetes tiene formas avanzadas de crear variables de entorno, secretos, etc.

Sin embargo, para el módulo de alcance es la forma básica de configurar el entorno.

En la sección de contenedores, en cada contenedor puede establecer una entrada env, para ingresar valores:

```yaml
kind: Pod # o artefacto é un Pod
apiVersion: v1  # a versión da api a empregar
metadata:
  name: primeiro-pod  # o nome do pod
spec:
  containers:
    - name: contedor  # o nome do contedor dentro do pod
      image: ubuntu:18.04
      command: ["/usr/bin/tail", "-f", "/dev/null"]
      env:
        - name: VAR   # estamos a establecer VAR=1 no env
          value: foo
        # poderíamos definir as variables de contorna que queramos
  restartPolicy: Never
```

En módulos posteriores, veremos formas mucho más avanzadas de controlar el entorno de tiempo de ejecución de un pod e incluir secretos y otras configuraciones.
