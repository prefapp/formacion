# Mejorando el Dockerfile web del "gatiño do día"

## 1. Aligerar la imagen
Si construimos la imagen del gatito web a partir de la [actividad anterior](https://prefapp.github.io/formacion/cursos/docker-images/#/./01_creacion_de_images/05_o_dockerfile_construindo_a_imaxe_do_gatinho_do_dia), podemos saber su tamaño.

Solo haz:

```dockerfile
docker images web-gatinhos
```

Para obtener el tamaño de la imagen. Veremos que la imagen pesa 491MB. Este peso es excesivo para los estándares actuales. Pensemos que estas imágenes:

- Se pueden instalar en muchos nodos.
- La rapidez de su provisión depende, en gran medida, de su tamaño ya que hay que descargarlos al host para poder utilizarlos.
- Hoy en día la tendencia es construir imágenes lo más pequeñas posible.

Afortunadamente, Docker y la comunidad van a poner a nuestra disposición una serie de mecanismos para hacer más pequeñas nuestras imágenes.

### A. La estrategia de varias etapas

Repasemos el proceso de construcción de la imagen del "gatiño do día":

1. Partimos de un Ubuntu.
2. Instalamos git y las dependencias básicas de python.
3. Clonamos el repositorio de gatitos del día.
4. Instalamos las librerías de python del proyecto.
5. Definimos el arranque del sistema.

Si lo pensamos bien, usamos git para clonar el repositorio, pero una vez hecho este paso, ¿de qué sirve?

La idea de [multi-stage](https://docs.docker.com/develop/develop-images/multistage-build/) es crear contenedores que hagan un trabajo y dejarlo en directorios que puedan ser utilizados por otros contenedores. El contenedor que hizo un trabajo, se puede descartar y con él todas sus dependencias. Con lo cual nos quedamos con el resultado del trabajo y no con todo el software auxiliar que necesitamos usar para obtenerlo.

En nuestro caso, podemos crear un contenedor, instalar git, clonar el repositorio y luego volcar git y todas sus dependencias. Lo que nos interesa es tener nuestro repositorio en algún lugar para el próximo contenedor que haga el próximo trabajo.

Para hacer una imagen web del "gatiño do día", dividiremos el trabajo en dos etapas:

1. **Builder**: vamos a instalar todo el software necesario para clonar el repositorio e instalar las bibliotecas del proyecto. Todo el software resultante y estrictamente necesario se pondrá en un directorio: el **/venv**. El resto del software del contenedor se desechará.
2. **Final**: Montamos el directorio resultante de la fase anterior (el /venv) en un nuevo contenedor que tendrá lo mínimo necesario para moverlo python (el [pipenv](https://docs.python-guide.org/dev/virtualenvs/)).

![multistaging](./../_media/01_creacion_de_imaxes/multi-staging.png)

Si lo vemos en un Dockerfile:

```dockerfile
# Constructor: stage de produción do /venv con todo o necesario para o noso proxecto
FROM ubuntu:20.04 as builder

# Instalamos o software necesario
RUN apt-get update && \
    apt-get install -y libssl-dev libffi-dev \
    git python3-pip build-essential \
    python3-venv

# Montamos o pipenv e clonamos o repo dos gatiños
RUN bash -c "python3 -m venv /venv && \
    source /venv/bin/activate && \
    git clone https://github.com/prefapp/catweb.git /venv/catweb && \
    pip install -r /venv/catweb/requirements.txt"

# Final: stage final (todo o stage anterior desaparece, salvo odirectorio /venv)
FROM ubuntu:20.04

COPY --from=builder /venv /venv

RUN apt-get update && \
    apt-get install -y python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="/venv/bin:${PATH}" \
    VIRTUAL_ENV="/venv"

EXPOSE 5000

# Comando de arranque do contedor
CMD ["python", "/venv/catweb/app.py"]
```

Como podemos ver:

- Hay dos fases que se inician en dos diferentes de (líneas 6 y 23).
- El trabajo del constructor se convierte en /venv (línea 15).
- El contenedor final "importa" /venv del contenedor del constructor (línea 23).

> ⚠️ Para evitar tener muchos RUN, las cadenas de comando se hacen con && y la línea se corta para que sea más legible.

Si ejecutamos este Dockerfile y creamos otra imagen, veremos que la nueva imagen tiene un tamaño de 205 MB, ¡producimos un ahorro de 286 MB!

> ⚠️ Mostramos dos etapas en este ejemplo, pero podría haber muchas más según nuestras necesidades.

> 👀 Donde también se aprovecha esta técnica es en aplicaciones que se pueden compilar con lenguajes como C, C++ o Go.

> 👀 Para una discusión sobre compilaciones de varias etapas o compilaciones de una sola etapa, puede consultar este artículo.







### B. Aún más.... Jugando con alpine

Las distribuciones de Linux como [Alpine](https://www.alpinelinux.org/about/), están diseñadas para ser muy livianas y seguras, pero mantienen una orientación de propósito general.

Alpine destaca especialmente por su reducido tamaño (5MB) y por ser una de las distros estrella en Dockerhub.

Mediante el uso de microdistribuciones, podemos reducir aún más el tamaño de nuestras imágenes.

```dockerfile
FROM alpine:latest

RUN apk add --update py-pip

RUN pip install --upgrade pip

RUN apk add git

RUN mkdir -p /usr/src/app/templates

RUN git clone https://github.com/prefapp/catweb.git /home/catweb && cp /home/catweb/requirements.txt /usr/src/app/ && cp /home/catweb/app.py /usr/src/app/ && cp /home/catweb/templates/index.html /usr/src/app/templates/

RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

EXPOSE 5000

CMD ["/usr/bin/python3", "/usr/src/app/app.py"]
```

Con este Dockerfile y clonando el [repo](https://github.com/prefapp/catweb) localmente, ¡podemos tener una imagen del "gatito del día" de 60 MB!

### C. Usando BUildKit

Desde la versión 19.03 de Docker podemos usar BuildKit para construir las imagenes.

[BuildKit](https://github.com/moby/buildkit) es un backend encargado de construir imagenes que incluye caracteristicas nuevas, veremos algunas de las más importantes.

Cabe resaltar que las últimas versiones del cliente de Docker ya usa por defecto. Para hacer explícito el uso de BuildKit usaremos la variable de entorno `DOCKER_BUILDKIT`, tal como se muestra en el siguiente ejemplo.

```
DOCKER_BUILDKIT=0 docker build . -t prueba-sin-buildkit
DOCKER_BUILDKIT=1 docker build . -t prueba-usando-buildkit
```

#### Paralelismo

Antes construíamos una imagen multi-stage procesando el fichero de forma secuencial. Usando BuildKit podemos reducir considerablemente el tiempo de construcción de imágenes, ya que analiza el Dockerfile y crea un grafo de dependencias para determinar que elementos se pueden ignorar, ejecutar en paralelo o cuáles tienen que ser ejecutados secuencialmente.

Prueba a construir la siguiente imagen sin usar BuildKit y a continuación prueba a usarlo, ¿cuál es la diferencia?

```Dockerfile
FROM alpine AS capa1
RUN sleep 10
 
FROM alpine AS capa2
RUN sleep 10
 
FROM alpine AS final
```

#### Nuevos tipos de mounts

Anteriormente, vimos la importancia de usar volúmenes para mantener el estado de los contenedores. Sin embargo, existen otros tipos que nos permiten hacer un uso más eficiente y seguro de los contenedores.

##### Secrets

Los secrets permiten definir información confidencial que no debería quedar expuesta en la imagen, pero es necesaria para la ejecución de un comando. A continuación se enseña un Dockerfile que usa esta característica:

```Dockerfile
FROM python:3

# Procesa a información sensible
RUN --mount=type=secret,id=confidencial.key md5sum /run/secrets/confidencial.key

COPY app /app
WORKDIR /app
CMD ["python","app.py"]
```

Como se puede ver, los secretos se almacenan temporalmente en el directorio `/run/secrets`, pero si mostramos el contenido desde dentro de un contenedor, veremos que está vacío. Usaremos el argumento `--secret` para especificar el archivo:

```
docker build --secret id=confidencial.key,src=/tmp/segredo .
```

##### SSH


También nos permite usar claves SSH, esto podría servirnos para descargar archivos usando `scp` o para clonar un repositorio privado de GitHub como se ve en el siguiente ejemplo:

```Dockerfile
# syntax=docker/dockerfile:experimental
FROM alpine
# Instala ssh
RUN apk add --no-cache openssh-client git
# Descargamos a clave pública de GitHub
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
# Clonamos o repositorio
RUN --mount=type=ssh git clone git@github.com:usuario/repositorio_privado.git myproject
```

Esta vez usamos el parámetro `--ssh`. Recuerda crear una clave SSH y agregarla al ssh-agent (Ver la [documentación de GitHub](https://docs.github.com/es/authentication/connecting-to-github-with-ssh/generating-a -nueva-clave-ssh-y-agregándola-al-agente-ssh#generando-una-nueva-clave-ssh))

```
docker build --ssh default=${SSH_AUTH_SOCK} .
```

# 🕮 Actividad

>- ✏️ Intentemos construir la imagen del "gatito del día" con el multietapa y veamos cuál es su tamaño.

## 2. Construyendo diferentes versiones de la web

En el caso de tener diferentes versiones de la web, siempre que el proceso de construcción sea el mismo, parece útil poder utilizar el mismo Dockerfile para ambas construcciones.

Imaginemos que tenemos un repositorio git (como [gatiños](https://github.com/prefapp/catweb)) con dos ramas:

- **master**: tiene la versión 1 de la web.
- **v2**: tiene la versión 2 de la web.

Sería interesante tener un Dockerfile que, según le pasemos un argumento u otro, pueda construir diferentes versiones.

Para lograrlo contamos con los [ARGS](https://docs.docker.com/engine/reference/builder/#arg) del Dockerfile. Los args son valores que podemos pasar a **docker-build** al construir la imagen.

Estos ARGS se pueden interpolar en las distintas instrucciones del Dockerfile.

Imaginemos que tenemos dos ramas en nuestro repositorio web "gatinho do día" (master, v2), podemos modificar nuestro Dockerfile original para que solo una de las ramas se descargue en el clon.

Es decir, en lugar de usar esto:

```dockerfile
RUN git clone https://github.com/prefapp/catweb.git
```

Usemos la siguiente oración:

```dockerfile
RUN git clone https://github.com/prefapp/catweb.git --single-branch -b $branch
```

De esta forma, git solo descargará una de las ramas del proyecto (master, v2, v3...).

El problema. obviamente, es como establecer el valor de la variable _**$branch**_.

Para ello, vamos a utilizar un ARG.

```dockerfile
ARG branch=master

RUN git clone https://github.com/prefapp/catweb.git --single-branch -b $branch
```

Ahora, nuestro Dockerfile espera un argumento de rama cuando se invoca. Si no se recibe dicho argumento, arg se inicializa con un valor predeterminado de "master".

Si ahora hacemos:

```shell
docker build --build-arg branch=master . -t web-gatinhos:v1
```

Le estamos diciendo a Docker:

- Construir una imagen (compilación acoplable).
- Pasar un argumento "branch" con valor "master" (--build-arg branch=master).
- El dockerfile está en esta ruta (.).
- La imagen resultante debe ser web-catinhos:v1

Si ahora hacemos lo mismo pero para v2:
```shell
docker build --build-arg branch=v2 . -t web-gatinhos:v2
```

Tendremos una imagen web-gatinhos:v2 con los nuevos cambios.

> ⚠️ Pasar contraseñas de ARGS u otra información confidencial es peligroso, porque permanece en la imagen producida.
