Wordpress en alta disponibilidad
----

Este ejemplo esta pensado para una web basada en wordpress que pueda aguantar bastantes visitas, en este caso los pods de php de wordpress comparten la carpeta wp-config a través de un sistema de ficheros nfs con filestore de google, el servicio de base de datos sería recomendable usar el propio sistema de google pero en este caso creamos una base de datos mysql con un volumen de datos persistente (PVC). 

Un dato a tener en cuenta, es que para conectarnos al nfs de google, antes de nada, tenemos que comprobar si tenemos un filestore generado:

```
gcloud filestore instances list
```

En caso de no tenerlo, podemos generarlo con el siguiente comando : 

```
gcloud filestore instances create nfs-server --zone=europe-west4-a --tier=standard --file-share=name="wp_content",capacity=1024Gi --network=name="default"
```

Y si, el minimo en el tier "standard" es de 1Tb, para ver mas sobre el comando anterior asi como los diferentes tipos de tier y velocidades de disco, entra en https://cloud.google.com/filestore/docs/creating-instances?hl=es-419. 

Una vez lo tenemos generado, al hacer el comando de instances list veriamos lo siguiente:

```
rcastrelo@prefapp:~$ gcloud filestore instances list
INSTANCE_NAME  ZONE            TIER      CAPACITY_GB  FILE_SHARE_NAME  IP_ADDRESS      STATE  CREATE_TIME
nfs-server     europe-west4-a  STANDARD  1024         wp_content       10.133.189.202  READY  2021-02-19T08:18:23
```
Co anterior xa teriamos o suficiente para executar o helm da carpeta, a partir de aqui explicamos como funciona o chamamento do volumen en NFS. 

Ahora lo primero que hacemos es generar un volumen persistente (PV) en kubernetes, para ello empleamos el siguinte codigo : 

```
apiVersion: v1
kind: PersistentVolume
metadata:
 name: wordpress-volume #este es el nombre del volumen persistente
spec:
 storageClassName: storage-nfs 
 capacity:
   storage: 1T #aqui indicamos la capacidad
 accessModes:
 - ReadWriteMany # aqui indicamos el tipo de acceso
 nfs:
   path: "/wp_content" #aqui indicamos el share compartido.
   server: "10.133.189.202" # en este apartado indicamos la ip o FQDN de nuestro nfs. 

```

Una vez generamos el pv, si ejecutamos el comando "kubectl get pv" podemos ver como este volumen no fue reclamado.

```
rcastrelo@prefapp:~/formacion/cursos/helm/00_solucions/99_wordpress_practice/wordpress_ha/templates$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                                           STORAGECLASS   REASON   AGE
wordpress-volume                           1T         RWX            Retain           Available                                                   storage-nfs             7s

```
Ahora o que temos que facer e coller ese volumen xerando unha reclamación de volumen persistente (PVC), para elo executamos o seguinte:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
 name: "wp-content" #nome do recurso. 
spec:
 accessModes:
 - ReadWriteMany
 storageClassName: "storage-nfs" 
 resources:
  requests:
   storage: 1T #capacidade
```

Unha vez feito o anteiror, podemos comprobar que o pv xa foi reclamado:
```
rcastrelo@prefapp:~$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                           STORAGECLASS   REASON   AGE
wordpress-volume                           1T         RWX            Retain           Bound    r-castrelo/wp-content                           storage-nfs             14m

```

E no pvc podemos ver o seguinte:
```
rcastrelo@prefapp:~$ kubectl get pvc
NAME         STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS   AGE
wp-content   Bound    wordpress-volume   1T         RWX            storage-nfs    2m32s

```
