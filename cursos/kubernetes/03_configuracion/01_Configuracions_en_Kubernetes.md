# Configuracións en Kubernetes

Un dos problemas que atopamos cos contedores de software é a súa configuración: a saber, cómo establecer os valores e datos que fan que o noso sistema traballe do xeito desexado. 

Dado que un contedor é con contexto aillado compre "inxectar" esa configuración de tal forma que:

* As imaxes estén preparadas para traballar cunha configuración que será dada dende o "exterior"
* O contedor faga as menus "asuncións" posibles de tal xeito que poida correr en calquera contexto cuns cambios mínimos; sexa en desenvolvemento, testeo, producción...
* Dado que a información se inxecta dentro do contedor, compre protexer os datos que sexan sensibles: passwords, contrasinais, claves ssh...

A solución aportada por K8s é a de crear dous novos tipos de artefactos:

* [Configmaps:](https://cloud.google.com/kubernetes-engine/docs/concepts/configmap?hl=es-419) almacenan información non confidencial.  
* [Secrets:](https://kubernetes.io/docs/concepts/configuration/secret/) artefactos que guardan información sensible de acceso limitado.

Estos elementos son repositorios de información que poden ser empregados polos pods de distintos xeitos:

* Como variables de contorno directamente accesibles a través do env.
* Como ficheiros que se montan nalgures dentro do sistema de archivos do contedor. 
* Como directorios de acceso restrinxido.

## Xestionando información non confidencial: Os configmaps 

Un ConfigMap é un artefacto de Kubernetes que contén información de configuración:

* Ó ser un artefacto, pódese interactuar con él a través do Kubectl para crealo, destruilo, editalo e clonalo
* Centraliza configuracións que poden ser empregadas polos pods para xestionar o seu propio comportamento. 

### a) Creando un ConfigMap

Existen diversos xeitos para crear un ConfigMap. 

Imos empregar un artefacto:

```yaml
# configmap_exemplo.yaml
#
apiVersion: v1
kind: ConfigMap # o tipo de artefacto
metadata:
  name: configuracion-exemplo # ten un nome
  labels:
    tipo: "exemplo"  # podemoslle meter labels
    modulo: "3"
data:
  nome: "Francisco" # aquí temos clave=valor como configuración
  curso: "Kubernetes"
  porto: "8080"
```

Se a creamos co noso microk8s:

Input
```sh
microk8s.kubectl apply -f configuracion_exemplo.yaml
```

Veremos que se creou un novo obxecto no noso k8s:

Input
```sh
microk8s.kubectl get configmap
```
Output
```sh
NAME                                DATA   AGE
configuracion-exemplo               3      9s
```

E se facemos un describe da mesma:

Input
```sh
microk8s.kubectl describe configmap configuracion-exemplo
```
Output
```sh
Name:         configuracion-exemplo
Namespace:    default
Labels:       modulo=3
              tipo=exemplo
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"v1","data":{"curso":"Kubernetes","nome":"Francisco","porto":"8080"},"kind":"ConfigMap","metadata":{"annotations":{},"labels...

Data
====
curso:
----
Kubernetes
nome:
----
Francisco
porto:
----
8080
Events:  <none>
```

Podemos tamén editala con "kubect edit" ou modificando o yaml e volvendo a facer un "kubectl apply". 

Por último, podemos borrala:

Input
```sh
microk8s.kubectl delete configmap configuracion-exemplo
```

### b) Empregando o noso configmap

Imaxinémonos que queremos empregar un pequeno programa escrito en nodeJS que precisa dunha configuración sinxela:

* Un porto de escoita
* Un nome de docente/discente
* Un curso ó que pertence ese docente/discente. 

A nosa aplicación podería correr nun pod como o que sigue:

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: pod-saudo
spec:
  containers:
    - name: contedor
      image: frmadem/prefapp-k8s-ej2   # a imaxe a empregar
  restartPolicy: Never
```
Teríamos a seguinte estructura:

![pod.png](../_media/03/pod.png)


A nosa aplicación recolle as súa configuración (porto, curso e nome) da súa contorna a través de env. 

Para inxectar estas variables, poderiamos facelo a través do propio pod:

```yaml
# pod_exemplo_2.yaml
kind: Pod
apiVersion: v1
metadata:
  name: pod-saudo
spec:
  containers:
    - name: contedor
      image: frmadem/prefapp-k8s-ej2   # a imaxe a empregar
      env:
        - name: "nome"
          value: "Francisco"
        - name: "curso"
          value: "Kubernetes"
        - name: "porto"
          value: "80"
  restartPolicy: Never
```

Se lanzamos isto:

Input
```
# arrancamos o pod
microk8s.kubect apply -f pod_exemplo_2.yaml
```
Input
```
# e expoñemos un porto
 microk8s.kubectl port-forward pod/pod-saudo --address=0.0.0.0 8888:80
```
Output
```
Forwarding from 0.0.0.0:8888 -> 80
Handling connection for 8888
```
Input
```
# unha petición dende o noso localhost
curl localhost:8888/saudo
```
Output
```
Hola Francisco benvido/a ó curso de Kubernetes
```

Nembargantes, esto tería diversos problemas:

* Estaríamos a misturar configuración do propio pod (de sistema) coa configuración de programa (de funcionamento interno)
* Non poderíamos mudar fácilmente esta configuración. 


Kubernetes facilita este traballo ofrecendo un novo artefacto: o configmap. 

Se empregamos o configmap anterior:

```yaml
# configmap_exemplo.yaml
#
apiVersion: v1
kind: ConfigMap # o tipo de artefacto
metadata:
  name: configuracion-exemplo # ten un nome
  labels:
    tipo: "exemplo"  # podemoslle meter labels
    modulo: "3"
data:
  nome: "Francisco" # aquí temos clave=valor como configuración
  curso: "Kubernetes"
  porto: "8080"
```

E agora modificamos o noso pod:

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: pod-saudo-configmap
spec:
  containers:
    - name: contedor
      image: frmadem/prefapp-k8s-ej2   # a imaxe a empregar
      env:
        - name: "nome"
          valueFrom:
            configMapKeyRef:
              name: "configuracion-exemplo"
              key: "nome"

        - name: "curso"
          valueFrom:
            configMapKeyRef:
              name: "configuracion-exemplo"
              key: "curso"

        - name: "porto"
          valueFrom:
            configMapKeyRef:
              name: "configuracion-exemplo"
              key: "porto"

  restartPolicy: Never
```

Se aplicamos este artefacto, obteríamos o seguinte:

![pod2.png](../_media/03/pod_2.png)

Á primeira vista, o emprego de ConfigMaps pode facer pensar que é moito máis verboso e que complica os nosos pods, nembargantes:

* Permite que os pods poidan empregar configuracións de diferentes lugares (distintos configmaps)
* Desacopla ou separa a configuración de programa da de sistema (a propia do pod)
* Diferentes artefactos (servizos, pods, deploys) poden "tirar" da mesma configuración. 

Asemade, existen en Kubernetes xeitos de crear ConfigMaps a partir de [ficheiros e directorios](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-a-configmap) e os novísimos [ConfigMap Generators](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/configGeneration.md).

## Xestionando información confidencial e crítica: Os segredos

Un [segredo](https://kubernetes.io/docs/concepts/configuration/secret/#overview-of-secrets) é un artefacto de Kubernetes que empregamos para xestionar e conter información sensible: passwords, tokens de acceso ou claves ssh.  
Os segredos xestionanse de xeito que poden ser empregados polos pods pero como artefactos independentes. 

### a) Creando un segredo

Existen diversos xeitos de crear un segredo, pero ó final, todo resulta nun artefacto que ten a seguinte estrutura:

```yaml
# o_meu_segredo.yaml
apiVersion: v1
kind: Secret
metadata:
  name: meu-segredo
type: Opaque
data: # aquí van os datos
  username: YWRtaW4=
  password: Y29udHJhc2luYWwK
Na sección "data" do artefacto, temos a información en formato clave-valor. Os valores estarán codificados en base64. 
```

Se creamos este segredo no noso k8s:

```shell
microk8s.kubectl apply -f o_meu_segredo.yaml
```
Teremos un artefacto novo no sistema que podemos controlar como sempre:

```shell
# podemos listalo
microk8s.kubectl get secrets

NAME                                                TYPE                                  DATA   AGE
meu-segredo                                         Opaque                                1      80s

# podemos borralo
microk8s.kubectl delete secret meu-segredo

secret "meu-segredo" deleted
```

Os segredos están securizados dentro da api de Kubernetes. Pódese, asemade, limitar ó acceso ós mesmos para os usuarios do clúster. 

### b) Empregando segredos nos pods

Os segredos poden ser empregados nos pods como volumes a montar no seu sistema de ficheiros ou como variables de contorna a inxectar no sistema. 

Un pod que empregue o segredo anterior:

```yaml
# redis.yaml
apiVersion: v1
kind: Pod
metadata:
  name: meu-redis
spec:
  containers:
  - name: contedor
    image: redis
    env:
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: meu-segredo
            key: username
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: meu-segredo
            key: password
  restartPolicy: Never
```

Vemos que o xeito de empregar os segredos como variables de contorna é moi similar ó dos ConfigMaps. 

Se o segredo non existe, a creación do pod será fallida. 
