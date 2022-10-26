# La identificación de artefactos: nombres, namespaces y labels

Los artefactos existentes dentro de Kubernetes están agrupados por identificadores que le permiten referirse a ellos de forma única, grupal o lógica.

## a) Identificación única: el nombre

Cada artefacto dentro de Kubernetes recibe dos identificadores únicos:

- Nombre: definido en la especificación del artefacto, dos artefactos no pueden tener el mismo nombre dentro de un namespaces. El nombre consta de la especie o tipo de artefacto y la cadena elegida por el usuario:
  - pod/o-mi-nombre
  - servicio/mi-nombre
- UID: Kubernetes asigna automáticamente un uid a cada artefacto.

Desde aquí, podemos hacer referencia a nuestros artefactos para interactuar con ellos.

```shell
# facer un get dun servizo
kubectl get service primer-servizo

# borrar un pod de nome primeiro-pod
kubectl delete pod primeiro-pod
```

Dado que los nombres y los identificadores existen, debe agrupar los artefactos de forma que se eviten las colisiones de nombres: es decir, evitar que dos usuarios utilicen accidentalmente el mismo nombre y provoquen una colisión. Esta es la razón por la cual cada artefacto existe en un namespaces específico (**namespaces**).

## b) namespaces (namespaces)

Cada artefacto en K8s pertenece a un namespaces. Esto evita colisiones, es decir, dos artefactos con el mismo nombre.

Al mismo tiempo, permite controlar el acceso de los usuarios a los diferentes artefactos, asignándoles namespaces específicos y derechos sobre los mismos.

Los namespaces en realidad hacen posible crear clústeres virtuales de K8 dentro de un K8 real. Aportan una gran flexibilidad y facilitan el trabajo con los usuarios (desarrolladores, testers, administradores o estudiantes).

### i) Listado de namespaces

Para ver los namespaces:

```shell
kubectl get namespaces
NAME              STATUS   AGE
default           Active   4d1h
kube-node-lease   Active   4d1h
kube-public       Active   4d1h
kube-system       Active   4d1h
```

De forma predeterminada, cada instalación de Kubernetes crea dos namespaces (**kube-system** y **default**).

El namespaces **kube-system** es donde residen los principales artefactos maestros de Kubernetes.

En el espacio **default** es donde crearemos nuestros artefactos.

### ii) Creación de un namespace

Para crear un nuevo namespace, use un artefacto como el siguiente:

```yaml
# namespace.yaml

kind: Namespace
apiVersion: v1
metadata:
  name: desenvolvemento
```

Ahora, simplemente envíelo al sistema:

```shell
kubectl apply -f namespace.yaml
```

Y ya tendríamos un nuevo namespaces creado en el sistema.

### iii) Enviar comandos a un namespace

De forma predeterminada, los comandos que ejecutamos con kubectl siempre se referirán al namespaces **default**.

Podemos cambiar el contexto por defecto a otro namespaces, pero esa es una tarea avanzada que dejaremos para otro módulo.

Por ahora, utilice el indicador **-n <namespace>** en nuestros comandos para establecer el namespace en el que ejecutarlos.

```shell
# listar os pods do namespace 'desenvolvemento'
kubectl get pods -n desenvolvemento

# borrar un pod do namespace 'desenvolvemento'
kubectl delete pod foo -n desenvolvemento
```
A todo ello se une un potente sistema de identificación de artefactos en Kubernetes: las etiquetas.

## c) Las etiquetas (labels)

Las etiquetas en Kubernetes son pares clave/valor que identifican un conjunto de objetos.

Estas etiquetas tienen sentido para los usuarios, pero no interfieren con el núcleo de K8:

- Podemos poner las etiquetas de la forma que queramos
- Sin embargo, hay una serie de [restricciones de sintaxis](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#syntax-and-character-set) y **usted no puede repetir una etiqueta dentro del mismo artefacto**.

Las etiquetas nos permiten agrupar nuestros artefactos por diferentes criterios:

- Entorno: (producción, prueba, desarrollo, demostración)
- Nivel: (frontend, backend, registros, depuración)
- otros queremos...

Para crear etiquetas, simplemente colócalas en nuestros artefactos:

En una pod:

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: primeiro-pod
  labels:
    entorno: probas
    tipo: backend
    contexto: practicas

spec:
  containers:
    - name: contedor
      image: ubuntu:18.04
      command: ["/usr/bin/tail", "-f", "/dev/null"]
  restartPolicy: Never
```

Ahora bien, si creamos este artefacto podemos recuperarlo de varias formas:

```shell
# ver as labels dos pods
kubectl get pods --show-labels

NAME                            READY   STATUS             RESTARTS   AGE     LABELS
primeiro-pod                    0/1     Pending            0          3m19s   contexto=practicas,entorno=probas,tipo=backend
```
Y, usando selectores podemos buscar labels:

```shell
# listar os pods de entorno probas (label entorno = probas)
kubectl get pods -l 'entorno = probas'

# listar tódolos artefactos que sexan de probas e de tipo backend
kubectl get all -l 'entorno = probas, tipo = backend'

# tamén podemos empregar adverbios como "in"
kubectl get pods -l 'entorno in (probas, evaluacion)'

# asemade temos o adverbio 'notin'
kubectl get pods -l 'entorno notin (evaluacion)'
```
