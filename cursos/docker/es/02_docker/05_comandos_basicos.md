# Comandos básicos

La interacción con Docker (con su daemon) se puede realizar principalmente de dos formas:

- A través de una [api](https://docs.docker.com/engine/api/v1.30/).
- Usando su línea de comando

En este curso vamos a utilizar la línea de comandos.

El shell de Docker es el comando [docker](https://docs.docker.com/engine/reference/commandline/cli/).

## Lista de contenedores del sistema

Para conocer los contenedores existentes en una máquina, usaremos el comando [_**ps**_](https://docs.docker.com/engine/reference/commandline/ps/).

```shell
docker ps
```

Lo que obtenemos es:

```shell
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
b3b0f3dff0cd        mongo               "docker-entrypoint..."   7 second ago        Up 6 seconds        27017/tcp                mongo
```

¿Cómo podemos comprobar:

- Docker asigna un uuid a los contenedores.
- Nos informa sobre la imagen que montas (más sobre imágenes en el siguiente tema).
- Nos informa sobre el comando que lanzó este contenedor.
- Sus tiempos de inicio (CREATED) y el tiempo que lleva encendido (STATUS).
- La conectividad del contenedor.
- El nombre asignado al contenedor. Si no le damos uno lo pone aleatorio.

## Creando y arrancando contenedores

El comando básico de creación de contenedores es [_**create**_](https://docs.docker.com/engine/reference/commandline/create/). (Originalmente [_**docker run**_](https://docs.docker.com/engine/reference/commandline/run/), que todavía está disponible y combina varios objetos con los que trabaja Docker: contenedores, volúmenes y redes)

Podemos enviarle un elemento obligatorio:

Imagen de creación, (similar al disco de arranque del contenedor), es un plano a partir del cual se ensamblará el contenedor.

Así, el siguiente comando:

```shell
docker create prefapp/debian-formacion
```

Devolverá una cadena en hexadecimal que será el identificador único del contenedor creado.

Sin embargo, si hacemos _**docker ps**_ no lo veremos en la tabla de contenedores.

El motivo es que se detendrá el contenedor creado. Para iniciarlo, ejecute el comando [_**start**_](https://docs.docker.com/engine/reference/commandline/start/).

```shell
docker start <uuid de contenido>
```

Con esto ya tendremos el nuevo contenedor ejecutándose, y si hacemos un _**docker ps**_ podremos verlo en la tabla de contenedores en ejecución.

Es normal unificar estos dos pasos en uno, usando el comando [_**run**_](https://docs.docker.com/engine/reference/commandline/run/). Este comando crea e inicia el contenedor.

## Detener el contenedor

Para detener un contenedor en ejecución, solo use el comando [_**stop**_](https://docs.docker.com/engine/reference/commandline/stop/).

```shell
docker stop <uuid de contenido>
```

Una vez que se lance el comando el contenedor se detiene, por lo que ya no aparecerá en la tabla _**docker ps**_. Podemos usar _**docker ps -a**_ para enumerar los contenedores detenidos.

## Limpiando el contenedor

El comando docker [_**rm**_](https://docs.docker.com/engine/reference/commandline/rm/) elimina el contenedor.

```shell
docker rm <uuid de contenido>
```

**Enlaces de interés**
- Docker [hoja de trucos](https://dockerlux.github.io/pdf/cheat-sheet-v2.pdf)