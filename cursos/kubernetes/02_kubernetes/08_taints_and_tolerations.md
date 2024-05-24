# Que son las Taints y las toleratins

Las [taints y tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) en kubernetes son unas herramientas que te permiten controlar qué pods se pueden desplegar en qué nodos. Las taints son aplicadas a los nodos y las tolerations a los pods. Así, puedes evitar que ciertos pods se ejecuten en nodos que no sean adecuados para ellos, por ejemplo, por cuestiones de rendimiento, seguridad o disponibilidad.

Ejemplo:
  Imagina que tienes una casa con varias habitaciones y quieres que solo tus amigos puedan entrar en tu habitación. Puedes poner un cartel en la puerta que diga “Solo amigos” (eso sería el taint). Entonces, solo las personas que sepan que son tus amigos y que tú les has dado permiso podrán entrar en tu habitación (eso sería la toleration). Las demás personas no podrán entrar porque no tienen la toleration adecuada.

## Como definir una toleration

Para definir una tolerancia en un pod, se debe usar el campo tolerations en la especificación del pod. Una tolerancia tiene los siguientes atributos: key, operator, value y effect. La clave y el valor son cadenas arbitrarias que identifican la contaminación(taint). El operador puede ser Equal o Exists. El efecto puede ser NoSchedule, PreferNoSchedule o NoExecute.

## Como definir una taint

Para aplicar un taint a un nodo, puedes usar el comando ``` kubectl taint nodes <node-name> <key>=<value>:<effect> ```. Para eliminar un taint de un nodo, puedes usar el mismo comando con un signo menos(-) al final: ```kubectl taint nodes <node-name> <key>=<value>:<effect>-```

### Ejemplo toleration:

``` 
apiVersion: v1
kind: Pod
metadata:
  name: dev-pod
spec:
  containers:
  - name: dev-container
    image: nginx
  tolerations:
  - key: "type"
    operator: "Equal"
    value: "dev"
    effect: "NoSchedule"
```


## Practica de taints:

Para poder hacer una practica necesitamos un cluster con minimo 3 nodos.
Para esto vamos a utilizar kind.

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
#featureGates:
#  TaintNodesByCondition: true 
nodes:
- role: control-plane
  image: kindest/node:v1.26.0
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        node-labels: "master=master"
        system-reserved: memory=1000m,cpu="1"
  extraPortMappings:
  - containerPort: 8080
    hostPort: 8080
    protocol: TCP
  - containerPort: 4443
    hostPort: 4443
    protocol: TCP
- role: worker
  image: kindest/node:v1.26.0
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        node-labels: "worker=worker"
        system-reserved: memory=1000m,cpu="1"
- role: worker
  image: kindest/node:v1.26.0
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        node-labels: "worker=worker"
        system-reserved: memory=1000m,cpu="1"

```

Ejercicio: 

a) Aplicar taints a un nodo y ver el comportamiento de los pods:

b) Verificar que la taint se ha aplicado correctamente usando el comando kubectl describe node <node-name>.

c) Crear un pod con una toleration que coincida con la taint usando el campo tolerations en el archivo YAML del pod.

d) Verificar que el pod se ha programado en el nodo con la taint usando el comando kubectl get pods -o wide.

Repetir los pasos anteriores con diferentes combinaciones de taints y tolerations para ver cómo afectan al comportamiento de los pods y los nodos.



# PodAffinity y NodeAffinity

Otra forma de controlar en que nodo se van a desplegar los pods es mediante el uso de podAffinity y nodeAffinity.

[Pod affinity y node affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/) son dos conceptos de Kubernetes que permiten asignar pods a nodos según ciertas condiciones. Pod affinity se refiere a la preferencia o requerimiento de que un pod se ejecute en el mismo nodo que otro pod existente. Node affinity se refiere a la preferencia o requerimiento de que un pod se ejecute en un nodo que tenga ciertas etiquetas o atributos.

Ejemplo de podAffinity:

```
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        - key: name
          operator: In
          values:
          - web-app
      topologyKey: kubernetes.io/hostname
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: type
            operator: In
            values:
            - primary
        topologyKey: kubernetes.io/hostname

    nodeAffinity:  
      requiredDuringSchedulingIgnoredDuringExecution: 
        nodeSelectorTerms:
        - matchExpressions:
          - key: type
            operator: NotIn 
            values:
            - primary
  containers:
  - name: node-affinity
    image: nginx

```

Estas 2 practicas para controlar pods se pueden combinar para formar reglas mas precisas que controlen el funcionamiento de los pods en nodos de kubernetes




