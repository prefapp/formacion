# A identificación dos artefactos: nomes, espazos de nomes e etiquetas

Os artefactos existentes dentro de Kubernetes agrúpanse por identificadores que permiten facer referencia ós mesmos tanto de forma unívoca como grupal ou lóxica. 

## a) Identificación unívoca: o nome

Cada artefacto dentro de Kubernetes recibe dous identificadores únicos:

- Nome: definido na especificación do artefacto, non pode haber dous artefactos que se chamen igual dentro dun namespace. O nome está formado pola especie ou tipo de artefacto e a cadena elixida polo usuario:
  - pod/o-meu-nome
  - servize/o-meu-nome
- UID: Kubernetes asigna un uid a cada artefacto de xeito automático. 

A partires de aquí, podemos facer referencia ós nosos artefactos para interactuar con eles. 

```shell
# facer un get dun servizo
microk8s.kubectl get servize primer-servizo

# borrar un pod de nome primeiro-pod
microk8s.kubectl delete pod primeiro-pod
```

Dado que existen nomes e identificadores, compre que agrupar os artefactos dun xeito que evite a colisión de nomes: esto é, evitar que de xeito accidental dous usuarios empreguen o mesmo nome e se produza unha colisión. Esta é a razón pola que todo artefacto existe nun espazo de nomes concreto (**namespace**). 

## b) Os espazos de nome (namespaces)

Cada artefacto existente en K8s pertence a un espacio de nomes. Esto evita colisións, esto é, dous artefactos que se chamen igual. 

Ó mesmo tempo, posibilita controlar o acceso dos usuarios ós distintos artefactos, asignándolles namespaces específicos e dereitos sobre os mesmos. 

Realmente, os namespaces posibilitan crear clúster virtuais de K8s dentro dun K8s real. Aportan unha grande flexibilidade e facilitan o traballo con usuarios (desenvolvedores, testeadores, administradores ou alumnos).

### i) Listando os namespaces

Para ver os namespaces:
```shell
microk8s.kubectl get namespaces
NAME              STATUS   AGE
default           Active   4d1h
kube-node-lease   Active   4d1h
kube-public       Active   4d1h
kube-system       Active   4d1h
```

Por defecto, toda instalación de Kubernetes crea dos namespaces (**kube-system** e **default**).

O namespace **kube-system** é o espazo onde viven os principais artefactos do máster de Kubernetes. 

No espazo de **default** é onde crearemos os nosos artefactos. 

### ii) Creando un namespace

Para crear un novo namespace, compre empregar un artefacto como o que sigue:

```yaml
# namespace.yaml

kind: Namespace
apiVersion: v1
metadata:
  name: desenvolvemento
```

Agora, basta con envialo ó sistema:

```shell
microk8s.kubectl apply -f namespace.yaml
```

E xa teríamos un novo namespace creado no sistema. 

### iii) Enviar comandos a un namespace

Por defecto, os comandos que executemos con kubectl van a referirse sempre ó namespace **default**. 

Podemos mudar de contexto para establecer por defecto outro namespace, pero é unha tarefa avanzada que deixaremos para outro módulo. 

Polo pronto, compre empregar o flag **-n <namespace>** nos nosos comandos para establecer o namespace no que executalos. 

```shell
# listar os pods do namespace 'desenvolvemento'
microk8s.kubectl get pods -n desenvolvemento

# borrar un pod do namespace 'desenvolvemento'
microk8s.kubectl delete pod foo -n desenvolvemento
```

A todo isto, únese un poderoso sistema de identificación de artefactos en Kubernetes: as etiquetas ou labels. 

## c) As etiquetas (labels)

As [etiquetas](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) en Kubernetes son pares de clave/valor que permiten identificar un conxunto de obxectos. 

Estas etiquetas teñen sentido para os usuarios pero non interfiren co núcleo de K8s:

- Podemos poñer as etiquetas co senso que queramos
- Existen, nembargantes, unha serie de [restriccións de sintaxe](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#syntax-and-character-set) e **non se pode repetir unha etiqueta dentro dun mesmo artefacto**. 

As etiquetas permiten agrupar os nosos artefactos por diferentes criterios:

- Entorno: (producción,test,desenvolvemento,demo)
- Nivel: (frontend, backend, logs, debug)
- outros que queiramos...

Para crear etiquetas, abonda con poñelas nos nosos artefactos:

Nun pod:

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

Agora, se creamos este artefacto podemos recuperalo de diversos xeitos:

```shell
# ver as labels dos pods
microk8s.kubectl get pods --show-labels

NAME                            READY   STATUS             RESTARTS   AGE     LABELS
primeiro-pod                    0/1     Pending            0          3m19s   contexto=practicas,entorno=probas,tipo=backend
```

E, empregando selectores podemos facer procuras por labels:
```shell
# listar os pods de entorno probas (label entorno = probas)
microk8s.kubectl get pods -l 'entorno = probas'

# listar tódolos artefactos que sexan de probas e de tipo backend
microk8s.kubectl get all -l 'entorno = probas, tipo = backend'

# tamén podemos empregar adverbios como "in"
microk8s.kubectl get pods 'entorno in (probas, evaluacion)'

# asemade temos o adverbio 'notin'
microk8s.kubectl get pods 'entorno notin (evaluacion)'
```
