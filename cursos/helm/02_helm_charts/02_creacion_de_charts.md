# De la creación de charts

En el capítulo [anterior](https://prefapp.github.io/formacion/cursos/helm/#/./02_helm_charts/01_valores_y_su_interpolacion) de este módulo hemos creado manualmente nuestra primera chart, empleando los ficheros básicos que la componen y el comando `helm template` para visualizar los cambios que Helm aplica a nuestras *templates*. En este apartado profundizaremos un poco más en la creación de "paquetes de kubernetes" a los que helm denomina **Charts**. 

## Helm create
Como ya sabes, Helm emplea *go templates* para renderizar las plantillas con artefactos de Kubernetes y producir manifiestos. La estructura básica de una *helm chart* se puede crear a mano como hemos hecho en el capítulo [anterior](https://prefapp.github.io/formacion/cursos/helm/#/./02_helm_charts/01_valores_y_su_interpolacion) o podemos dejar que Helm haga el trabajo por nosotros con el comando:
```shell
$ helm create mi-primera-chart
```

Si lo ejecutamos, veremos que helm nos crea una estructura como la siguiente:
```
mi-primera-chart/
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

3 directories, 10 files
```

Este sencillo comando nos crea una **Chart** base sobre la que nosotros podemos comenzar a trabajar cambiando los ficheros de templates por los artefactos de nuestro proyecto y modificando los ficheros para que se ajusten a nuestra aplicación.

Antes de ponernos a modificar los ficheros, vamos a familiarizarnos un poco con los comandos básicos.

### Instalando nuestra Chart
En el [módulo 1](https://prefapp.github.io/formacion/cursos/helm/#/./00_actividades/01_modulo_1?id=creando-a-nosa-primera-release) de este curso ya hemos visto como utilizar el comando `helm install` para crear **releases** a partir de la **Chart** de [MariaDB](https://hub.helm.sh/charts/bitnami/mariadb) del repositorio de Bitnami.

Vamos a emplearlo para lanzar una release de la chart que acabamos de crear:
```shell
helm install <nombre>  mi-primera-chart/ -n <namespace>
```

El flag `-n` nos lanza la release en el namespace que nosotros desginemos. Como ya sabemos, podemos lanzar tantas *releases* como queramos a partir de una *Chart*, incluso en el mismo namespace (en el capítulo siguiente explicaremos cómo evitar que se pisen los nombres de los artefactos). 

Para ver todas nuestras *releases* (en diferentes *namespaces*) empleamos el comando:
 ```shell
 helm list -A
 ```

El `helm create` nos ha generado los archivos de una chart con un servidor de [NGINX](https://nginx.org/en/). Al hacer el `helm install` nos aparecen en la terminal unas instrucciones que explican como visitar el servidor, hablaremos a cerca de estas instrucciones a continuación.

## Adaptando el proyecto por defecto 
Vamos a trabajar sobre los ficheros generados por `helm create`. Crearemos una chart que despliege un pod con un servidor NGINX. Para comenzar a trabajar realizaremos las siguientes modificaciones:

1. Borraremos el contenido de la carpeta `/templates` conservando el archivo `NOTEST.txt`vacío.

1. Vaciaremos el archivo `values.yaml`.

1. Añadiremos a `/templates` nuestros artefactos. En nuestro caso este sencillo pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-nginx
spec:
  containers:
    - name: web
      image: nginx
      ports:
        - name: web
          containerPort: 80
          protocol: TCP
```

Nos quedaría una estructura como esta:

```yaml
mi-primera-chart/
├── Chart.yaml
├── templates
│   ├── NOTES.txt
│   └── pod.yaml
└── values.yaml

1 directory, 4 files
```

### NOTES.txt
Dentro del archivo `NOTES.txt` podemos introducir información que será mostrada por la terminal al hacer `helm install`. Vamos a introducir el siguiente mensaje:

```txt
Puedes conseguir la URL de la aplicación con este comando:
  kubectl --namespace {{ .Release.Namespace }} port-forward pod/web-nginx 8080:80
```

Como veis, podemos utilizar la misma sintaxis que usamos en las *templates* para que el mensaje utilice información adaptada a la *release*. En este caso estamos cogiendo el nombre del namespace en el que se desplegó nuestra *release*.

En esta [web](https://helm.sh/docs/chart_template_guide/builtin_objects/) puedes encontrar todas los objetos que Helm nos expone para modificar nuestra plantillas.

## Template functions y Pipelines
En el capítulo [anterior](https://prefapp.github.io/formacion/cursos/helm/#/./02_helm_charts/01_valores_y_su_interpolacion) hemos visto como añadir información de nuestro `values.yaml` en nuestras plantillas. Esta información era introducida en la plantilla sin modificación alguna. En ocasiones resulta útil operar y transformar la información antes de inyectarla. Para esto Helm nos permite utilizar las [Go templates](https://godoc.org/text/template) junto con la librería [Sprig](https://masterminds.github.io/sprig/). Helm cuenta con más de 60 funciones, puedes verlas en este [enlace](https://helm.sh/docs/chart_template_guide/function_list/).

Ejemplo:
```
#values
coche: Ferrari
---

#template
{{ repeat 3 .Values.coche }}  // Generará: FerrariFerrariFerrari
```


### Pipelines
Una de la características más útiles del *template language* es el concepto de **pipelines**. Basadas en el concepto de UNIX, las *pipelines* son una herramienta que nos permite encadenar una serie de comandos para crear una transformación en serie de forma compacta y legible. 

Las pipelines no son más que una secuencia de transformaciones. Veamos un ejemplo:

```
{{ .Values.coche | upper | repeat 3 | quote }}  
// Generará: "FERRARIFERRARIFERRARI"
```

### Funciones más comunes
- **b64enc** y **b64dec**: Para codificar los secretos, por ejemplo.
- **quote**: Para asegurarnos de que el yaml trata como String a nuesta variable.
- **upper**: Para las variables de entorno.
- **default**: Por si se omite un valor.
- **lookup**: Consultar en este [enlace](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/#using-the-lookup-function)

Puedes ver todas las funciones disponibles [aquí](https://helm.sh/docs/chart_template_guide/function_list/)


## Debugging

#### helm lint
Si tenemos un error durante la instalación de nuestra *Chart* es muy probable que se deba a que los `.yaml` tengan algún error en su estructura. Para comprobar que nuestro proyecto tiene todos los *YAML* sintácticamente correctos podemos emplear el comando:
```shell
$ helm lint <directorioChart>
```
La salida de este comando indicará `1 chart(s) linted, 0 chart(s) failed`, podemos pensar que solo se ha pasado el linter a `Chart.yaml`, pero realmente se le ha pasado a todo el proyecto.

#### --debug
Al añadir la opcion `--debug` tanto a `helm install` como `helm template` obtendremos una salida más verbosa que nos puede ayudar a la hora de depurar nuestras charts

#### --dry-run vs template
Como ya sabemos, si ejecutamos el comando `helm template <dir>` renderizaremos toda la chart en un manifiesto único. Esto es muy útil para poder visualizar los cambios que Helm realiza en nuestras plantillas. 

Si ejecutamos un `helm install <name> <dir> --dry-run` obtendremos un resultado muy similar al del comando `helm template`, en vez de instalarse se nos monstrará el manifiesto renderizado. La diferencia es que el comando *install --dry-run* se comunica con el cluster de Kubernetes mientras que *template* no lo hace.

#### get manifest
Si ejecutamos el comando:
```shell
$ helm get manifest <release>
```
Se nos mostrará el manifiesto de la release que tenemos instalada, muy útil para ver los cambios que Helm ha hecho en nuestras templates de unos artefactos que ya están desplegados.

#### Comentar los YAML
En aquellas ocasiones en las que queremos ver como Helm está inyectando información en las plantillas pero nos salta un error en el parseado del YAML, podemos comentar aquellas líneas que continen *go templates*.

´´´yaml
apiVersion: v2
# some: problem section
# {{ .Values.foo | quote }}
´´´

´´´yaml
apiVersion: v2
# some: problem section
#  "bar"
´´´

Aunque esté comentanda la línea en el YAML, Helm sigue renderizando toda la plantilla, de forma que podemos ver los cambios aunque estos interfieran con la estructura del YAML (Helm inyecta la información en una línea comentada).



## Finalizar y distribuír nuestra Chart
Ahora que ya estamos curtidos en la creación de *Charts* vamos a rematar nuestro proyecto añadiendo una función con pipelining y a distribuir la Chart utilizando `helm package`.

Modificaremos nuestra template `pod.yaml` para que coja la imagen desde nuestro `values.yaml`:
```yaml
#values. yaml
imagen:
  nombre: nginx
  tag: ""
```

```yaml
#pod.yaml
...
containers:
    - name: web
      image: "{{ .Values.imagen.nombre }}:{{ .Values.imagen.tag | default .Chart.AppVersion }}"
      ports:
...
```

Con esta nueva linea, la información de la imagen se formará con el valor *image.nombre* y se le concatenará la tag que, de no estar definida, se cogerá de `Chart.yaml`.

Si nos fijamos en nuestro archivo `Chart.yaml`:
```yaml
apiVersion: v2
name: mi-primera-chart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
```

Veremos que con el proyecto se creó una variable `appVersion`, la cual hace referencia a la version que se emplea en las imágenes de los containers.

Ahora que ya tenemos nuestra *Chart* lista, podemos distribuirla creando un paquete con el comando:
```shell
$ helm package <directorio_de_la_chart>
```
Esto nos producirá un archivo `.tgz` que podremos subir a un repositorio de paquetes de Helm con el comando `helm repo add`.





