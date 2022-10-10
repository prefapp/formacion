# Helm: o marionetista de Kubernetes

![helm1](./../_media/03/helm1.jpg)

[Helm](https://helm.sh/) é un dos proxectos máis interesantes dentro da comunidade de Kubernetes. 

A idea de Helm é a de controlar un **despregue** (chámanlle release) de tal xeito que:

- Mediante un único conxunto de valores (normalmente expresado en YAML)
  - Tódolos artefactos que o compoñan (deploys, pods, configmaps, services...) teñan reflictidos os valores correctos de configuración
  - Se declaren correctamente no clúster de K8s
  - Ante un cambio de valores, se reconfiguren os artefactos apropiados. 
- O release, cun solo comando, poida:
  - Listarse
  - Deterse
  - Actualizarse
  - Reconfigurarse
- As releases partan de planiñas ou [charts](https://github.com/helm/charts) é dicir, repositorios co código necesario para lanzar unha aplicación no kubernetes. 
  - Atópanse en repos públicos
  - Hainas de tódolos tipos (mysql, mongo, Wordpress...)
  - Pódense descargar e empregar ou extendelas como queiramos

## a) Instalación de helm

Na nosa ubuntu é moi sinxelo:
```shell
snap install helm --classic
```

 **Nota! O binario atópase en /snap/bin/helm, se non se atopa no path podedes ben incluílo ou ben crear un link simbólico, por exemplo a /usr/sbin/helm.*

Dado que helm se basa en kubectl, e na configuración que del teñamos, compre instalalo tamén (non o microk8s.kubectl)

```shell
snap install kubectl --classic

# agora, hai que volcar a configuración de microk8s nun lugar no que o kubectl (e tamén o helm) o poidan atopar

microk8s.kubectl config view --raw > $HOME/.kube/config

# comprobamos que o kubectl nos funciona
kubectl get nodes

NAME        STATUS   ROLES    AGE   VERSION
nodo-m      Ready    <none>   22d   v1.14.1
```

E, por fin, iniciamos o helm
```shell
helm init
```

**Nota!  No caso de dicir que as versións son incompatibles, compre facer `helm init --upgrade`.*
**Nota(2)! Pode levarlle un minuto iniciar ó helm. Compre agardar ata poder interactuar con él.* 

O que instalará un pequeno pod no noso microk8s co que helm controla as releases que creemos. 

Agora, podemos crear unha release. 

## b) Creando unha release

Para crear unha release, compre descargar a **chart** ou planiña ou indicarlle ó helm que a descargue por sí mesmo. 

As charts atópanse en repositorios. 

```shell
# listamos os repos
helm repo list

NAME            URL
local           http://127.0.0.1:8879/charts

# Engadimos o repo de stable oficial
 helm repo add stable https://kubernetes-charts.storage.googleapis.com

"stable" has been added to your repositories

# Listamos os charts dispoñibles
helm search stable
NAME                                    CHART VERSION   APP VERSION                     
stable/acs-engine-autoscaler            2.2.2           2.1.1                           
stable/aerospike                        0.2.8           v4.5.0.5                        
stable/airflow                          2.8.6           1.10.2                       
```

Podemos, por exemplo, instalar unha mariadb
```shell
helm install -n bbdd stable/mariadb
```

O parámetro -n dalle un nome á release. 

```shell
# para ver a release
helm list
NAME    REVISION        UPDATED                         STATUS          CHART           APP VERSION     NAMESPACE
maria   1               Mon May  27 23:40:04 2019        DEPLOYED        mariadb-6.2.0   10.3.15         default
```

Se exploramos o noso microk8s:
```shell
kubectl get pods

NAME                                      READY   STATUS    RESTARTS   AGE
maria-mariadb-master-0                    1/1     Running   0          12m
maria-mariadb-slave-0                     0/1     Running   4          12m
```

Ademáis nos creou servizos para o master e o slave, un segredo para as passwords e tres configmaps para o master, o slave e os tests. 

É dicir, temos instalada unha MariaDb con máster-slave e as mellores prácticas da industria para Kubernetes!

Para configurala, habería que ir ó [repo oficial](https://github.com/helm/charts/tree/master/stable/mariadb), onde nos comentan os valores a modificar para manexar a nosa instalación. 

Eses valores, compre metelos nun ficheiro de yaml:
```yaml
# values.yaml
db:
  user: paco
  password: segredo
  name: test
```

Agora relanzamos a nosa release:

```shell
# borramos a release
helm delete --purge maria

# relanzamos cos values
helm install -n maria -f values.yaml stable/mariadb
```

E teríamos o desplegue cunha base de datos creada e un usuario vinculado á mesma. 