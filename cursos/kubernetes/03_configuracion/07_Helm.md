# Helm: o marionetista de Kubernetes

![helm1](./../_media/03/helm1.jpg)

[Helm](https://helm.sh/) é un dos proxectos máis interesantes dentro da comunidade de Kubernetes. 

A idea de Helm é a de controlar un **despregue** (chámanlle release) de tal xeito que:

- Mediante un único conxunto de valores (normalmente expresado en YAML):
  - Tódolos artefactos que o compoñan (deploys, pods, configmaps, services...) teñan reflictidos os valores correctos de configuración.
  - Se declaren correctamente no clúster de K8s.
  - Ante un cambio de valores, se reconfiguren os artefactos apropiados. 
- O release, cun solo comando, poida:
  - Listarse
  - Deterse
  - Actualizarse
  - Reconfigurarse
- As releases partan de planiñas ou [charts](https://github.com/helm/charts) é dicir, repositorios co código necesario para lanzar unha aplicación no kubernetes:
  - Atópanse en repos públicos.
  - Hainas de tódolos tipos (mysql, mongo, Wordpress...).
  - Pódense descargar e empregar ou extendelas como queiramos.

## a) Instalación de helm

Na nosa ubuntu é moi sinxelo:
```shell
snap install helm --classic
```

 **Nota! O binario atópase en /snap/bin/helm, se non se atopa no path podedes ben incluílo ou ben crear un link simbólico, por exemplo a /usr/sbin/helm.*

En versións previas, era preciso inicializar helm para empezar a traballar con el, mais isto deixou de ser así na versión 3. Se estamos utilizando unha versión máis antiga, teremos que lanzar o seguinte comando: 

```shell
helm init
```

**Nota!  No caso de dicir que as versións son incompatibles, compre facer `helm init --upgrade`.*
**Nota(2)! Pode levarlle un minuto iniciar ó helm. Compre agardar ata poder interactuar con él.* 

Agora, podemos crear unha release. 

## b) Creando unha release

Para crear unha release, compre descargar a **chart** ou planiña ou indicarlle ó helm que a descargue por sí mesmo. 

As charts atópanse en repositorios. 

```shell
# listamos os repos
helm repo list

NAME            URL
local           http://127.0.0.1:8879/charts

# Engadimos o repo de bitnami, un dos máis utilizados
 helm repo add bitnami https://charts.bitnami.com

"bitnami" has been added to your repositories

# Listamos os charts dispoñibles
helm search repo bitnami
NAME                                    CHART VERSION   APP VERSION                     
bitnami/airflow                                 13.0.4          2.3.3           Apache Airflow is a tool to express and execute...
bitnami/apache                                  9.1.18          2.4.54          Apache HTTP Server is an open-source HTTP serve...
bitnami/argo-cd                                 4.0.6           2.4.8           Argo CD is a continuous delivery tool for Kuber...
```

Podemos, por exemplo, instalar unha mariadb:
```shell
helm install bbdd bitnami/mariadb
```

```shell
# para ver a release
helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
bbdd    default         1               2022-08-11 10:12:54.717064554 -0400 EDT deployed        mariadb-11.1.7  10.6.8      
```

Se exploramos o noso clúster:
```shell
kubectl get pods

NAME             READY   STATUS    RESTARTS   AGE
bbdd-mariadb-0   1/1     Running   0          98s

```

Ademáis creou o servizo vinculado ó pod, un segredo para as passwords e un configmap.

É dicir, temos instalada unha MariaDB coas mellores prácticas da industria para Kubernetes!

Para configurala, habería que ir ó [artifacthub](https://artifacthub.io/packages/helm/bitnami/mariadb), onde nos comentan os valores a modificar para manexar a nosa instalación. 

Eses valores, compre metelos nun ficheiro de yaml:
```yaml
# values.yaml
db:
  username: paco
  password: segredo
  database: test
```

Agora relanzamos a nosa release:

```shell
# borramos a release
helm uninstall bbdd

# relanzamos cos values
helm install maria -f values.yaml bitnami/mariadb
```

E teríamos o desplegue cunha base de datos creada e un usuario vinculado á mesma. 