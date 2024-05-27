# Helm: titiritero de Kubernetes

![helm1](../../_media/03/helm1.jpg)

[Helm](https://helm.sh/) es uno de los proyectos más interesantes dentro de la comunidad de Kubernetes.

La idea de Helm es controlar un **despliegue** (lo llaman release) de tal forma que:

- Usando **un solo conjunto de valores** (generalmente expresado en YAML):
  - Todos los artefactos que lo componen (deploys, pods, configmaps, services...) tienen reflejados los valores de configuración correctos.
  - Están declarados correctamente en el clúster K8s.
  - Ante un cambio de valores, se reconfiguran los artefactos correspondientes.
- El release, con **un solo comando**, puede:
  - Listarse
  - Detenerse
  - Actualizarse
  - Reconfigurarse
- Los releases parten de **planes o [charts](https://github.com/helm/charts)**, es decir, repositorios con el código necesario para lanzar una aplicación en Kubernetes:
  - Se encuentran en repositorios públicos.
  - Los hay de todos los tipos (mysql, mongo, Wordpress...).
  - Se pueden descargar y utilizar o ampliar como queramos.

## a) Instalación de Helm

En nuestro ubuntu es muy sencillo:

```shell
snap install helm --classic
```

 **¡Nota! El binario está en /snap/bin/helm, si no está en la ruta, puede incluirlo o crear un enlace simbólico, por ejemplo, a /usr/sbin/helm.*

En versiones anteriores era necesario inicializar helm para empezar a trabajar con él, pero en la versión 3 ya no es así. Si estamos usando una versión anterior, tendremos que lanzar el siguiente comando:

```shell
helm init
```

**¡Nota! Si dice que las versiones son incompatibles, es necesario hacer `helm init --upgrade`.*

**¡Nota 2! helm puede tardar un minuto en ponerse en marcha. Espere hasta que pueda interactuar con él.*

Ahora, podemos crear una release.

## b) Crear una release

Para crear una release, descargue el **chart** o el plano o pídale a helm que lo descargue él mismo.

Los charts están en repositorios.

```shell
# listamos os repos
helm repo list

NAME            URL
local           http://127.0.0.1:8879/charts

# Agregamos bitnami repo, uno de los más usados
 helm repo add bitnami https://charts.bitnami.com

"bitnami" has been added to your repositories

# Listamos los charts disponibles
helm search repo bitnami
NAME                                    CHART VERSION   APP VERSION                     
bitnami/airflow                                 13.0.4          2.3.3           Apache Airflow is a tool to express and execute...
bitnami/apache                                  9.1.18          2.4.54          Apache HTTP Server is an open-source HTTP serve...
bitnami/argo-cd                                 4.0.6           2.4.8           Argo CD is a continuous delivery tool for Kuber...
```

Podemos, por ejemplo, instalar un mariadb:

```shell
helm install bbdd bitnami/mariadb
```
Para ver el release

```shell
helm list

NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
bbdd    default         1               2022-08-11 10:12:54.717064554 -0400 EDT deployed        mariadb-11.1.7  10.6.8      
```

Si exploramos nuestro clúster:

```shell
kubectl get pods

NAME             READY   STATUS    RESTARTS   AGE
bbdd-mariadb-0   1/1     Running   0          98s

```

También creó el servicio vinculado al pod, un secret para password y un configmap.

Es decir, ¡tenemos un MariaDB instalado con las mejores prácticas de la industria para Kubernetes!

Para configurarlo hay que ir a [artifacthub](https://artifacthub.io/packages/helm/bitnami/mariadb), donde nos indican los valores a modificar para gestionar nuestra instalación.

Ponga esos valores en un fichero yaml:

```yaml
# values.yaml
db:
  username: paco
  password: segredo
  database: test
```

Ahora relanzamos nuestro release:

```shell
# borramos el release
helm uninstall bbdd

# relanzamos con los values
helm install maria -f values.yaml bitnami/mariadb
```

Y tendríamos el despliegue con una base de datos creada y un usuario vinculado a ella.
