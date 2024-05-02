# Continuación de la Práctica Guiada: Mejorando nuestra Meiga

Si has tenido algún problema con en el capítulo anterior, aquí puedes descargar el proyecto Meiga pasado a Helm ([archivos resultantes de la práctica guiada anterior](https://github.com/prefapp/formacion/tree/master/cursos/helm/codigo_practica_guiada_meiga/meiga-helm))


## Cambiando la BBDD a una sub-Chart.
En el anterior capítulo convertimos a Helm el [proyecto Meiga](https://github.com/prefapp/formacion/tree/master/cursos/helm/codigo_practica_guiada_meiga/meiga-k8s) original. Este proyecto constaba ya en *Docker* de un servidor Php que servía una web. Para tener persistencia del número de visitas y el tamaño de la luna, el container de Php guardaba su información en una base de datos que no era si no un container con una imagen de *mysql:5.7*. 

Esta dependencia de la base de datos nos obligaba a crear y mantener un container que no es específico para nuestra aplicación. En este apartado **vamos a liberarnos** de trabajar con el *deployment* y el *servicio* del *mysql* añadiendo la base de datos a través de un **subchart**.

Una [subchart](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/) es una *Chart* de Helm guardada en nuestro proyecto en la carpeta `/charts` que se despliega a la vez que **nuestra Chart principal**. Podemos cambiar los *values* de una *subchart* desde el `values.yaml` raíz de nuestro proyecto (lo veremos más adelante). 

Sin embargo, una subchart no puede acceder a los valores de la *Chart* padre: la *Subchart* no tiene dependencia explícita de la *Chart* que tiene por encima. Esto permite utilizarlas de modo "stand-alone". Si queremos utilizar un valor común a todas las *Charts* debemos emplear [Global Chart Values](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/#global-chart-values).

Gracias a las *Subcharts* podemos trabajar con *Charts* específicas creadas por equipos como [Bitnami](https://bitnami.com/). Esto nos permite emplear *Charts* muy avanzadas y actualizadas sin tener que preocuparnos de su funcionamiento ni de su mantenimiento, solo tenemos que seleccionar la versión que queremos y configurar los *values* para adaptar la *Chart* a nuestras necesidades. 

Nosotros vamos a añadir una [Subchart de mysql](https://artifacthub.io/packages/helm/bitnami/mysql) creada por Bitnami. Los pasos para hacer este cambio son los siguientes:

1. Borramos de nuestra carpeta `/templates` los archivos `bbdd-service.yaml` y `bbdd-deploy.yaml`.

2. Añadimos al archivo `Chart.yaml`  la siguiente dependencia:
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
    version: "10.1.0" 
    repository: https://charts.bitnami.com/bitnami
  ```

3. Modificamos nuestro `values.yaml` para editar la configuración de la *Subchart*:

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
  Aquellos valores del `values.yaml` raíz que se encuentren dentro de "mysql:" machacarán los *Values* de la subchart. Al hacer el install, todo lo que se encuentra dentro de "mysql:" en el `values.yaml` raíz se utilizará para crear un archivo *values* que se le pasa a la *Subchart mysql* cambiando así sus valores por defecto.

4. Por último tenemos que volver a editar el _MYSQL_HOST_ nuestro configmap para apuntar nuestro nuevo service creado en la *Subchart*:

```yaml
...
data:
  MYSQL_HOST: {{ .Release.Name }}-mysql
...
```
> Lo más importante es fijarnos el nombre del service que nos crea la *Subchart*, que en este caso es el arriba indicado, pero puede diferir según la chart que empleemos.

5. Ejecutamos el siguiente comando para bajarnos del repo la *Subchart* indicada en `Chart.yaml`:
  ```shell
  $ helm dependency build
  ```

> Ahora ya podemos hacer un `helm install` de nuestra *Chart* "meiga-project" y comprobar que la base de datos se crea y el php es capaz de conectarse correctamente.



## Añadir un Ingress para nuestro servicio
Actualmente estamos accediendo a nuestro servidor php haciendo un `kubectl port-forward` del servicio. Esto método es válido para hacer pruebas y comprobar que nuestra aplicación funciona correctamente, sin embargo no es una manera correcta de exponer nuestra aplicación al mundo. Como vimos en el [módulo 3 de curso de Kubernetes](https://prefapp.github.io/formacion/cursos/kubernetes/#/03_configuracion/05_Ingress_controlando_o_trafico), la forma adecuada de exponer nuestro servicio al mundo es utilizando un **ingress**.

Para añadir un **ingress** a nuestro proyecto vamos a necesitar dos elementos:
- Un artefacto de kubernetes `ingress.yaml` en el que definiremos las reglas de ingress.
- Un controlador que lea estas reglas y conecte la dirección del ingress con los servicios internos que le correspondan (que actúe como *reverse proxy* y *loadbalancer*).

Para nuestro controlador ingress utilizaremos la *Chart* [ingress-nginx](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx).

Debemos seguir los siguiente pasos para configurar todo correctamente:

1. Añadir la *Subchart* como dependencia en nuestro `Chart.yaml`:
  ```yaml
  ...
  dependencies:
  - name: ingress-nginx
    version: "3.23.0"
    repository: https://kubernetes.github.io/ingress-nginx
  ...
  ```

1. Configurar el ingress para que trabaje dentro de nuestro *namespace* y se adpate a nuestro cluster: 

  ```yaml
  #values.yaml
  ...
  ingress-nginx:
    controller:
      scope:
        enabled: true # defaults to .Release.Namespace
  #Ajustes para Google Cloud 
      service:
        internal:
          enabled: true
          annotations:
            # Create internal LB
            cloud.google.com/load-balancer-type: "Internal"
            # Any other annotation can be declared here.
  ...
  ```
  En este tutorial estamos mostrando los ajustes para trabajar en un cluster GKE, puedes consultar qué valores necesitas para tu cluster en la [documentación de la Chart](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx).

1. Dentro de `/templastes` debemos crear un artefacto de kubernetes de tipo *Ingress* donde definiremos las reglas de redireccionamiento:
  ```yaml
  #templates/ingress.yaml
  apiVersion: networking.k8s.io/v1beta1
  kind: Ingress
  metadata:
    name: {{ .Release.Name }}-ingress
    annotations:
      kubernetes.io/ingress.class: nginx
  spec:
    rules:
    - http:
        paths:
        - path: /
          backend:
            serviceName: servizo-{{ .Release.Name }}-php
            servicePort: 80
  ```
  En nuesto caso estamos redireccionando cualquier path al servidor meiga, pues no tenemos ningún otro servicio, pero podríamos crear reglas de reverse-proxy mucho más complejas utilizando hostname, paths y diferentes *services*.


1. Por último, antes de hacer el `helm install` de nuestro proyecto debemos lanzar el comando:
  ```shell
  $ helm dependency update
  ```


Una vez instalada la nueva *release*, si ejecutamos el comando:
```shell
$ kubectl describe ing <release_name>-ingress -n <namespace>
```

Deberiamos obtener la información del ingress que acabamos de crear. Ahí nos aparecerá la dirección que podemos utilizar para acceder a nuestra web Meiga-php.

## Crear un NOTES.txt 
Ahora que ya tenemos nuestro proyecto expuesto al exterior, vamos utilizar lo que aprendimos en el [capítulo 2](https://prefapp.github.io/formacion/cursos/helm/#/./02_helm_charts/02_creacion_de_charts?id=notestxt) para crear un archivo `NOTES.txt` dentro de la carpeta `templates/` que mostrará al administrador un mensaje al instalar la *Chart*. 

Escribiremos unas instrucciones indicando cómo obtener la dirección del ingress que apunta a Meiga-php:

```txt
#templates/NOTEST.txt
***INSTRUCCIONES***
  Puedes acceder a la web Meiga-php en la dirección proporcionada por el ingress:
  $ kubectl describe ing {{ .Release.Name }}-ingress -n {{ .Release.Namespace }}
```
Utilizamos los [Built-in Objects](https://helm.sh/docs/chart_template_guide/builtin_objects/) de Helm para obtener información del nombre de la *release* y su *namespace*.


## Tests de unidad para Helm
Para finalizar, vamos a añadir unos [tests de unidad](https://github.com/quintush/helm-unittest) a nuestra chart de Helm para validar que hemos seguido todos los pasos correctamente. Puedes obtener los tests de unidad específicos para esta práctica guiada en este [enlace](https://github.com/prefapp/formacion/tree/master/cursos/helm/codigo_practica_guiada_meiga/meiga-helm-v2/tests).

Lo primero que debemos hacer es instalar el [plugin](https://github.com/quintush/helm-unittest) de Helm que nos permite pasar los tests:
```shell
$ helm plugin install https://github.com/quintush/helm-unittest
```

A continuación, debemos colocar nuestros tests dentro de nuesto proyecto en la carpeta `/tests`. Al finalizar la práctica, nuestro proyecto debería tener una estructura como esta:
```
proyecto-meiga/
├── Chart.yaml
├── charts
│   ├── ingress-nginx-3.23.0.tgz
│   └── mysql-8.3.1.tgz
├── templates
│   ├── NOTES.txt
│   ├── configmap.yaml
│   ├── frontend-deploy.yaml
│   ├── frontend-service.yaml
│   ├── ingress.yaml
│   └── secret.yaml
├── tests
│   ├── __snapshot__
│   ├── configmap_test.yaml
│   ├── frontend-deploy_test.yaml
│   ├── frontend-service_test.yaml
│   ├── ingress_test.yaml
│   └── secret_test.yaml
└── values.yaml

4 directories, 15 files
```

Para ejecutar los tests sólo tenemos que aplicar el comando:
```shell
helm unittest -3 <directorio_proyecto>
```

Una vez finalizada la práctica guiada deberían ejecutarse los 6 tests correctamente. Si tienes algún problema con la realización de la práctica o algún test de unidad falla, puedes comparar tus archivos con la solución final de la práctica guiada Meiga que encontrarás en este [enlace](https://github.com/prefapp/formacion/tree/master/cursos/helm/codigo_practica_guiada_meiga/meiga-helm-v2).

