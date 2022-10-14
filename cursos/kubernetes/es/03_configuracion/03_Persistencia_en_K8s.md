# Persistencia en K8s: os volumes

Ata agora as nosas cargas de traballo estánse a executar en pods. O problema que temos é que, en caso de reiniciarse un pod, ou se o borramos, perdemos datos que poden interesarnos. É dicir: os nosos pods non teñen persistencia. 

Para poder dotar de persistencia ós nosos pods, Kubernetes ofrece unha solución: os volumes. 

## A) Definición de volume

Un volume é un recurso de Kubernetes que é externo ós contedores dos nosos pods e que polo tanto non segue o seu ciclo de vida:

* Non se borra cando se borran ou reinician os contedores dun pod. 
* Os pods poden acceder a él e montalo como unha ruta máis do seu sistema de ficheiros. 
* Os volumes poden xestionarse dun xeito totalmente independiente ós pods, deploys e services (volumes persistentes) 

Asemade, os volumes poden ser elementos externos ó propio clúster de Kubernetes:

* Poden ser unha unidade NFS que se monta no clúster. 
* Poder ser un volume iscsi. 
* Hai posibilidade de conectar elementos propios de proveedores de nube privada e pública. 

[Aquí](https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes) pódese atopar unha lista extensa de sistemas de almacenamento que pode empregar Kubernetes como base para crear volumes. 

![pod7.png](../_media/03/pod7.png)

## B) Emprego de volumes locais

Un dos tipos básicos de volumes son os chamados hostPath. 

Permite que o volume creado sexa realmente un directorio do host (nodo onde esté a correr o pod). 

É moi cómodo para desenvolver e para traballar pero ten serias limitacións:

* No momento en que temos máis dun nodo xa non se pode empregar posto que non temos garantido en qué nodo do clúster vai correr o noso pod, polo tanto pode atopar esa ruta ou non. 
* Se cae o nodo, pérdese toda a información do hostPath.  

Nembargantes, podemos usalo para ilustrar algúns dos puntos básicos dos volumes. 

Partamos deste pod:

```yaml
# pod_con_volume.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-con-volume
spec:
  containers:
  - image: frmadem/catro-eixos-k8s-apache2
    name: contedor
    volumeMounts:
    - mountPath: /usr/local/apache2/logs
      name: volume
  volumes:
  - name: volume
    hostPath:
      path: /tmp/logs_apache_k8s
      type: DirectoryOrCreate
```

Vemos que na sección de volumes [13-17]:

* Declaramos un volume
* É de tipo hostPath
* Apuntamos a unha carpeta no noso host (/tmp/logs_apache_k8s)
* Dicimoslle que o cree se non existe (DirectoryOrCreate)

Despois, na parte do contedor [10-12]:

* Montamos o volume nunha sección de volumeMounts
* Establecemos unha ruta de montaxe (/usr/local/apache2/logs)
* E facemos unha referencia ó volume declarado

Temos o seguinte:

![pod8.png](../_media/03/pod8.png)

Agora:

Input
```sh
# arrancamos o pod
kubectl apply -f pod_con_volume.yaml
```

Input
```sh
# exportamos o porto á nosa máquina
kubectl port-forward pod/pod-con-volume --address=0.0.0.0 8888:80
```

Input
```sh
# dende outra shell facemos un curl
curl localhost:8888/
```

Output
```sh
<html><body><h1>It works!</h1></body></html>
```

Input
```sh
# se facemos un cat dende o host a /tmp/logs_apache_k8s/access_log

cat /tmp/logs_apache_k8s/access_log
```

Output
```sh
# vemos os logs

127.0.0.1 - - [15/May/2019:14:32:28 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:28 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:28 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:29 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:29 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:29 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:31 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:31 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:31 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:33 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:34 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:34 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
127.0.0.1 - - [15/May/2019:14:32:35 +0000] "GET / HTTP/1.1" 200 45 "-" "curl/7.61.0"
```

