# Pods de control: límites y pruebas

Sabemos que el pod es la unidad de construcción mínima, el bloque de construcción con el que hacemos nuestras aplicaciones.

Sin embargo, y hasta ahora, no hemos hablado de una serie de características que nos permitirán trabajar mucho mejor con nuestros pods.

Por un lado, Kubernetes funciona alojando nuestras cargas de trabajo (en forma de pods) en los nodos disponibles, esto implica que, de alguna manera, los K8 deben estar informados de la carga que puede esperar del pod, así como el límite máximo que debe permitir para cada uno. uno de ellos

Por otro lado, nuestras cápsulas deberían poder tener "extremos" u "agujeros" especiales para poder decirle a los K8 dos cosas:

* Si el pod está "vivo", la aplicación se ejecuta sin problemas.
* Si el pod está "listo": cuando se inicia el pod, cuando está listo para recibir solicitudes.

Ambos problemas se resuelven en Kubernetes mediante límites y sondeos.

## a) Límites y solicitudes en pods

![pod3](../_media/03/pod3.png)

Scheduler es el componente encargado de alojar los pods en los diferentes nodos de un clúster de Kubernetes. Podemos pensar en ello como jugar Tetris con nuestras cápsulas. Así que necesita conocer el "tamaño de la pieza" con el que está jugando.

En un pod hay que establecer dos medidas muy claras:

* Request: podemos pensar en la solicitud como los recursos mínimos que necesitará un pod para funcionar. Cuando el programador implementa un pod en un nodo, se garantiza que tendrá esos recursos expresados ​​en su solicitud.
* Limits: Esto establece la cantidad máxima que puede pedir un pod.
 
Por lo tanto, un pod se puede expresar en términos de los recursos que solicita de la siguiente manera:

![pod4](../_media/03/pod4.png)

Obviamente, cuando hablamos de "recursos", nos referimos a:

* CPU: que será tratada como se indica en la [documentación oficial](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu). 
* Memoria: que será tratada según lo indicado por la [comunidad](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) de Kubernetes. 

De esta manera, los pods siempre tienen la solicitud satisfecha cuando el programador los aloja en un nodo.

Ahora:

* Un pod siempre tendrá reservados los recursos expresados ​​en su Solicitud. Pero, si no está utilizando más, esos recursos pueden ser utilizados por otros pods.
* Un pod puede solicitar recursos más allá de su Solicitud, y siempre hasta sus Límites.

Por lo tanto, podemos pensar que el programador crea una especie de "bolsa de recursos" con la CPU/Memoria no utilizada o no utilizada por los pods y la distribuye entre los pods que pueden solicitar más de su Solicitud hasta los Límites expresados ​​en su artefacto.

Es en esa parte "verde" del diagrama donde juega el planificador, debiendo siempre respetar la Solicitud (la parte amarilla) y nunca sobrepasar los Límites que está representado por el color rojo.

![pod5.png](../_media/03/pod5.png)

### i) Uso de límites y solicitudes en pods

La expresión de solicitudes y límites tiene los siguientes formatos:

* Memoria: E, P, T, G, M, K se pueden utilizar para expresar la cantidad de memoria o sus equivalentes en potencias de dos (Ei, Pi, Ti, Gi, Mi, Ki.)
* CPU: se mide en unidades de CPU (independientemente del número de cores) por lo que 200m implicaría 200 milicores. Hay una explicación más detallada en este [artículo](https://medium.com/@betz.mark/understanding-resource-limits-in-kubernetes-cpu-time-9eff74d3161b).

En la plantilla del pod, refleje de esta manera:

```yaml
# pod_limits_requests.yaml
kind: Pod
apiVersion: v1
metadata:
  name: pod-limites-requests
spec:
  containers:
    - name: contedor
      image: nginx   # a imaxe a empregar
      resources:
        requests:
          memory: "64Mi"
          cpu: "250m"
        limits:
          memory: "128Mi"
          cpu: "500m"
  restartPolicy: Never
```

Como podemos ver, estamos configurando solicitudes (la cantidad mínima de recursos) en 64 Mi de RAM y 250 mo 250 milicores.

Los límites se fijan en 128Mi de RAM y 500m o 500 milicores.

## b) pruebas en las vainas

Como dijimos al comienzo de esta unidad, los K8 deben saber acerca de una cápsula:

* Si está en funcionamiento.
* Si está listo para recibir solicitudes.
 
 Kubernetes resuelve estos problemas a través de pruebas.

Las pruebas son solicitudes o comandos http que se ejecutarán dentro del pod (desde los contenedores del pod) para determinar si su ejecución es exitosa o no. De lo contrario, los K8 pueden concluir que el módulo no se puede usar (el programa principal no se está ejecutando) o que aún no está listo para funcionar (el programa principal del módulo aún se está iniciando).

![pod6.png](../_media/03/pod6.png)

Hay dos tipos esenciales de pruebas:

* Readiness probe: prueba para determinar si el contenedor del pod está listo o no para recibir solicitudes.
* Liveness probe: prueba que determina la "salud" del contenedor, si está funcionando correctamente.

### i) Definición de prueba

Las pruebas, como decíamos, son programas para ejecutar o peticiones http para realizar.

Una prueba, independientemente de su tipo, tiene las siguientes partes:

* Solicitud de comando o URL.
* Argumentos de comando
* Segundos de espera antes de enviar la primera prueba.
* Segundos de espera entre el envío de una prueba y la siguiente.
 
En un ejemplo, tenemos el siguiente pod:

```yaml
# pod_prueba_live.yaml
kind: Pod
apiVersion: v1
metadata:
  name: pod-sonda-live
spec:
  containers:
    - name: contedor
      image: frmadem/catro-eixos-k8s-sonda
      livenessProbe:
        exec:
          command: # o comando a executar
            - cat
            - /etc/san
        initialDelaySeconds: 5
        periodSeconds: 5
```

Como podemos ver, se declara una prueba de actividad en el pod.

Ejecute un comando (cat /etc/san) y se ejecutará después de los primeros 5 segundos del inicio del contenedor (initialDelaySeconds) y se repetirá cada 5 segundos (periodSeconds).

Si lo iniciamos:

Input
```sh
kubectl apply -f pod_sonda_live.yaml
```

Input
```sh
kubectl get pods
```

Output
```sh
NAME                                      READY   STATUS             RESTARTS   AGE
pod-sonda-live                            1/1     Running            0          3m19s
```

Ahora, desde otro shell accedemos al pod:

Input 
```sh
kubectl exec -ti pod-sonda-live -- bash
```

Output
```sh
root@pod-sonda-live:/#
```

Y borramos el fichero /etc/san

Input
```sh
root@pod-sonda-live:/# rm /etc/san
```
En poco tiempo, veremos que K8s "nos echa" del contenedor:

Output
```sh
root@pod-sonda-live:/# command terminated with exit code 137
```

Y si vamos a ver los detalles de nuestro pod, veremos lo siguiente:

Input
```sh
kubectl describe pod pod-sonda-live
```

Output
```sh
Events:
  Type     Reason     Age                 From                Message
  ----     ------     ----                ----                -------
  Normal   Scheduled  7m5s                default-scheduler   Successfully assigned default/pod-sonda-live to sutelinco
  Warning  Unhealthy  61s (x3 over 71s)   kubelet, sutelinco  Liveness probe failed: cat: /etc/san: No such file or directory
  Normal   Killing    61s                 kubelet, sutelinco  Container contedor failed liveness probe, will be restarted
```

Vemos que la prueba en vivo falló y el contenedor se reinició. De hecho, si miramos la información de los pods:

Input
```sh
kubectl get pods
```
Output
```sh
NAME                                      READY   STATUS             RESTARTS   AGE
pod-sonda-live                            1/1     Running            1          8m6s
```

Y vemos que hay un reinicio de nuestro contenedor (en el momento en que borramos el archivo). Cuando se reinicie, el archivo volverá a estar en su lugar porque está incluido en la imagen.

### ii) Definición de una prueba de tipo de petición http

En este caso, vamos a crear una sonda ready (pod preparado) mediante una petición http.

Tenemos el siguiente pod:

```yaml
# pod_sonda_http.yaml
kind: Pod
apiVersion: v1
metadata:
  name: pod-sonda-http
spec:
  containers:
    - name: contedor
      image: nginx:1.15
      readinessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 15
        periodSeconds: 5
```

Lanzamos un pod con nginx. Creamos una sonda lista y después de esperar 15 segundos hará un `GET /`. Repetirá esta operación cada 5 segundos hasta que responda con 200.

Una vez que responde, el pod entra en estado listo y estará listo para recibir solicitudes.

### iii) Uso de pruebas con servicios y deploys

Las pruebas en live y ready son muy importantes cuando se trabaja con deploy que tienen una gran cantidad de réplicas. Pensemos:

* Cada vez que se inicia una nueva réplica, el pod no recibirá solicitudes a través del servicio hasta que esté en estado **ready**, es decir, hasta que la prueba (readinessProbe) no devuelva ok.
* Si un pod falla (el programa principal deja de funcionar), la prueba de salud (livenessProbe) detecta el fallo y reinicia el contenedor. Mientras no vuelva a estar **ready** no recibirá peticiones a través del servicio.
 
Estas dos pruebas nos permiten monitorear los pods y garantizar que no se envíen peticiones a un pod que se encuentra en un estado inestable.