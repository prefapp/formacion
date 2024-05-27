# Administración de redes

Por defecto los contenedores Docker pueden acceder al exterior (tienen conectividad, siempre dependiendo de la máquina host)

Sin embargo, el contenedor está aislado con respecto a la entrada de datos. Es decir, por defecto, y con la excepción del comando exec, el contenedor es una unidad aislada a la que no se puede acceder.

Por supuesto, debe poder acceder a los contenedores para interactuar con ellos de alguna manera.

La regla básica aquí es: a menos que se indique lo contrario, **todo está cerrado al mundo exterior**.

En esta sección aprenderemos cómo Docker resuelve el problema de proporcionar conectividad a los contenedores.

## Puertos de contenedores

Un contenedor está dentro de su espacio de nombres de red, por lo que puede establecer reglas específicas sin afectar al resto del sistema.

De esta forma, y ​​siempre desde el punto de vista del contenedor, podemos establecer las reglas que queramos y conectar lo que queramos a los 65535 del contenedor sin miedo a colisiones con otros servicios.

Entonces podríamos tener un contenedor con apache conectado al puerto 80:

![Container porto](../../_media/02_docker/contedor_porto.png)

O podríamos tener varios contenedores con servicios apache conectados al puerto 80:

![Containers porto](../../_media/02_docker/contedores_porto.png)

Dado que cada uno de ellos tiene su propio espacio de nombres de red, no habría problemas de colisión entre los servicios conectados al mismo puerto en diferentes contenedores.

> ⚠️ Por supuesto, si dentro de un mismo contenedor ponemos dos servicios escuchando en el mismo puerto, se producirá un error de red.

El problema es que, a pesar de tener esta libertad dentro del contenedor, aún necesitamos conectar el extremo del contenedor con un puerto en la máquina host para que las conexiones externas puedan llegar a nuestro contenedor. Afortunadamente, Docker facilitará mucho ese trabajo.

## Conecta los puertos acoplables al exterior

Como vimos en la sección anterior, dentro de un contenedor tenemos toda la pila de red para hacer lo que queramos.

Sin embargo, eso no es suficiente para llegar a nuestro contenedor desde el mundo exterior. Como esto:

![Container conexión](../../_media/02_docker/contedor_conexion_0.png)

Como podemos ver, nuestro contenedor está aislado del mundo exterior, aunque apache está presente y conectado al puerto 80 dentro del contenedor.

Intentemos comenzar con una imagen que hemos preparado para este curso:

- Está basado en debian:8
- Tienes apache2 instalado
- El proceso de arranque consiste en hacer que apache escuche en el puerto 80

```shell
docker run -d --name apache-probas prefapp/apache-formacion
```

Si hacemos un _**docker ps**_ ahora, veremos nuestro contenedor ejecutándose. El problema: no podemos llegar al servicio de apache que se ejecuta escuchando en el puerto 80, porque nuestro contenedor no tiene conectividad con el exterior.

La única forma de conectarse a apache es ingresar al contenedor:

```shell
docker exec -ti apache-probas /bin/bash
```

Y desde dentro podríamos hacer, por ejemplo, un curl al puerto 80:

```shell
root@378cc9f54153:/# curl localhost:80
```

Y obtendríamos una respuesta adecuada de apache.

Docker nos permite conectar puertos de contenedor a puertos de host de tal manera que este último sea accesible desde el exterior.

Eliminemos nuestro contenedor:

```shell
docker rm -f -v apache-pruebas
```

Y vuelva a implementarlo con una nueva opción:

```shell
docker run -d -p 9090:80 --name apache-tests prefapp/apache-training
```

Como podemos ver, la novedad aquí es el *(-p 9090:80)*:

- Dígale a Docker que necesita conectar un puerto de host a un puerto de contenedor.
- El puerto 9090 corresponde a un puerto host.
- El puerto 80 es el que está dentro del contenedor (donde escucha nuestro apache)
En un diagrama:

![Container conexión](../../_media/02_docker/contedor_conexion_1.png)

Ahora el puerto 80 de nuestro contenedor está conectado al puerto 9090 de la máquina host. Podemos, por tanto, llegar al apache corriendo por dentro sin problema desde fuera:

```shell
curl localhost:9090
```
> ⚠️ El puerto de host es totalmente controlable usando iptables o reglas de firewall para determinar su accesibilidad desde el exterior.

>> Incluso si tenemos libertad en los puertos dentro del contenedor, los puertos host son un recurso limitado y de uso alternativo. Es decir, no puede asignar el mismo puerto a varios puertos de contenedores. Esto representa un problema de gestión a resolver con las herramientas de orquestación, tema del tema 6 de esta asignatura.
