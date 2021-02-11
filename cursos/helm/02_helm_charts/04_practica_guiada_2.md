# Continuación de la Práctica Guiada: Mejorando nuestra Meiga

Si has tenido algún problema con en el capítulo anterior, aquí puedes descargar el proyecto Meiga pasado a Helm ([archivos resultantes de la práctica guiada anterior](https://github.com/prefapp/formacion/tree/master/cursos/helm/codigo_practica_guiada_meiga/meiga-helm))


## Cambiando la BBDD a una sub-Chart.
En el anterior capítulo convertimos a Helm el [proyecto Meiga](https://github.com/prefapp/formacion/tree/master/cursos/helm/codigo_practica_guiada_meiga/meiga-k8s) original. Este proyecto constaba ya en *Docker* de un servidor Php que servía una web. Para tener persistencia del número de visitas y el tamaño de la luna, el container de Php guardaba su información en una base de datos que no era si no un container con una imagen de *mysql:5.7*. 

Esta dependencia de la base de datos nos obligaba a crear y mantener un container que no es específico para nuestra aplicación. En este apartado vamos a liberarnos de trabajar con el *deployment* y el *servicio* del *mysql* añadiendo la base de datos a través de un **subchart**.

Una [subchart](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/) es una *Chart* de Helm guardada en nuestro proyecto en la carpeta `/charts` que se despliega a la vez que **nuestra Chart**. Podemos cambiar los values de una *subchart* desde el `values.yaml` raíz de nuestro proyecto (lo veremos más adelante). Sin embargo, una subchart no puede acceder a los valores de la *Chart* principal: la *Subchart* no tiene dependencia explícita de la *Chart* que tiene por encima.

Nosotros vamos a añadir una [*Subchart* de mysql](https://artifacthub.io/packages/helm/bitnami/mysql) creada por Bitnami. Los pasos para hacer este cambio son los siguientes:

1. Borramos de nuestra carpeta `/templates` los archivos `bbdd-service.yaml` y `bbdd-deploy.yaml`.

1. Añadimos al archivo `Chart.yaml`  la siguiente dependencia:
  ```yaml
  #meiga-project/Chart.yaml
  apiVersion: v2
  name: meiga-project
  description: A Helm chart for Kubernetes
  type: application
  version: 0.1.0

  #nueva dependencia
  dependencies:
  - name: mysql
    version: "8.3.1" 
    repository: https://charts.bitnami.com/bitnami
  ```

1. Modificamos nuestro `values.yaml` para editar la configuración de la *Subchart*:

  ```yaml
  # meiga-project/values.yaml
  #SUBCHART mysql
  mysql:
    image:
      tag: 5.7
    auth:
      rootPassword: contrasinal  
      database: "meiga"  
  ...
  ```
  Aquellos valores del `values.yaml` raíz que se encuentren dentro de *mysql* machacarán los *Values* de la subchart.

1. Ejecutamos el siguiente comando para bajarnos del repo la *Subchart* indicada en `Chart.yaml`:
  ```shell
  $ helm dependency build
  ```

> Ahora ya podemos hacer un `helm install` de nuestra *Chart* "meiga-project" y comprobar que la base de datos se crea y el php es capaz de conectarse correctamente.



## Añadir un Ingress para nuestro servicio



## Crear un NOTES.txt 



## Tests de unidad para Helm
