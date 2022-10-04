# Gestión de volumen

Sabemos que los contenedores son efímeros, es decir, una vez terminado el contenedor (cuando finaliza el proceso que lo inició) desaparecen todos los datos que tenemos en el contenedor.

Para verlo, podemos hacer la siguiente práctica:

# 📖 Actividad 1

Comencemos un contenedor con run desde nuestro debian de entrenamiento:

```shell
docker run --rm -ti prefapp/debian-formacion bash
```

Ahora, actualizamos las fuentes con _**apt-get update**_. Luego instalamos el programa curl.

```shell
apt-get update && apt-get install --yes curl
```

Comprobamos que funciona.

Salimos del contenedor (la opción _**--rm**_ provocará su borrado inmediato).

Si volvemos a lanzar un contenedor con el comando anterior, ¿tenemos curl? ¿Por qué?

# Volúmenes: la conexión del contenedor con el sistema de archivos del anfitrión

Una de las principales soluciones al problema de la no persistencia de los contenedores es la de los volúmenes.

Podemos pensar en un volumen como un directorio en nuestro anfitrión que está "montado" como parte del sistema de archivos del contenedor. El contenedor puede acceder a este directorio y los datos almacenados en él persistirán independientemente del ciclo de vida del contenedor.

![Volumen contenedor](./../_media/02_docker/contedor_volume.png)

Para lograr esto, basta con decirle a Docker qué directorio de nuestro host queremos montar como volumen y en qué ruta queremos montarlo en nuestro contenedor.

En un ejemplo:

```shell
docker run --rm -ti -v ~/meu_contedor:/var/datos prefapp/debian-formacion bash
```

Como podemos ver:

- Le decimos a Docker que queremos un contenedor interactivo que se autodestruya (_**run --rm -ti**_).
- Ejecutemos la imagen _**prefapp/debian**_.
- El comando de entrada es _**bash**_.
- Montamos un volumen: _**-v**_, especificando host_path:container_path _**(~/my_container:/var/data)**_.

# 📖 Actividad 2

>- ✏️ Probemos este comando. Lanzamos un contenedor que crea un volumen, y una vez dentro del contenedor, creamos tres archivos en /var/data.
>- ✏️ Cierre la sesión del contenedor y busque en el directorio del host, ¿qué hay dentro?
>- ✏️ Volvemos a lanzar un contenedor con el mismo comando, si vamos a _**/var/data**_: son los archivos? Si lo son, eliminamos /var/data/a y /var/data/b.
>- ✏️ Volvemos a iniciar sesión, buscamos en el directorio host, ¿qué archivos hay?