# Comando avanzado _**run**_

Una vez que comprenda el ciclo básico de contenedores **crear-ejecutar-detener-eliminar**, revisemos el comando `run` para ver algunas de sus opciones.

## Ejecutar un comando instantáneo en un contenedor

Imaginemos que queremos saber la versión de nuestro debian, para eso tendríamos que hacer un `cat` del archivo **/etc/issue**.

Vamos a crear un contenedor que haga este trabajo y luego desaparezca.

```shell
docker run --rm prefapp/debian-formacion cat /etc/issue
```

Esto mostrará la siguiente información:

```shell
Debian GNU/Linux 8 \n \l
```

Lo que acaba de pasar es lo siguiente:

1. Docker crea e inicia (_**run**_) un nuevo contenedor.
2. El sistema eliminará el contenedor al final de su ejecución (_**--rm**_).
3. Este contenedor se va a basar en la imagen _**prefapp/debian-formacion**_.
4. El comando para run en el contenedor es _**cat /etc/issue**_.

Tenga en cuenta que el resultado de /etc/issue no es el de la máquina anfitriona sino el del contenedor que se monta con la imagen.

En este ejemplo puedes ver lo livianos que son los contenedores: los creamos y los destruimos en cuestión de décimas de segundo y los usamos para realizar tareas triviales (como hacer un cat).

## run un comando de forma interactiva

Imaginemos que queremos ejecutar una sesión dentro de nuestra imagen de Debian y poder ejecutar comandos dentro de ella.


Para esto, tenemos que crear un contenedor (que inicia un intérprete de comandos) e interactuar con él.

```shell
docker run --rm -ti prefapp/debian-formacion /bin/bash
```

Si ejecutamos este comando, nuestro prompt cambiará a una cadena hexadecimal (el uuid del propio contenedor).

Ahora podríamos interactuar con el contenedor, y cuando hayamos terminado, con _**exit**_ o **Ctrl + D** podemos salir del shell, o cuando finalice el programa de inicio del contenedor, el contenedor en sí muera recupera el control del shell de nuestra máquina.

## Crear y run un contenedor demonizado

Cuando queremos run un contenedor que proporciona un servicio, lo normal es ejecutarlo como un daemon.

Vamos a crear un contenedor que funcione como si fuera un servidor Debian. Este contenedor se ejecutará demonizado (independientemente de nuestra sesión en la máquina). Además, le vamos a poner un nombre para poder gestionarlo de una forma más sencilla.

```shell
docker run --name contedor-formacion -d prefapp/debian-formacion tail -f /dev/null
```

En este caso, le decimos a docker

- Crear e iniciar un contenedor (_**run**_)
- Dale el nombre de contenedor de entrenamiento (_**--name**_)
- Queremos que se ejecute en segundo plano, como un demonio (_**-d**_)
- Nos basamos en la imagen _**prefapp/debian-formacion**_
- El comando a run es _**tail -f /dev/null**_ 



> ⚠️ Se utiliza el uso de _**tail -f /dev/null**_ (`sleep infinity`) para que, siendo el proceso iniciador del contenedor, sobreviva indefinidamente, hasta que sea terminado explícitamente por _**docker stop**_, terminando así todo el contenedor.

Si ejecutamos el comando, veremos que todavía estamos en el shell de nuestra máquina. Al hacer _**docker ps**_, veremos que nuestro contenedor está creado y con el nombre que le pusimos.

```shell
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
21295036cca5        prefapp/debi...     "tail -f /dev/null"      2 seconds ago       Up 1 second                                  contedor-formacion
```

> Una pregunta que nos podemos hacer ahora es: ¿cómo entro en ese contenedor?

La solución es _**docker exec**_.

## Ejecutando un comando dentro de un contenedor: _**docker-exec**_

En la sección anterior vimos que podíamos crear un contenedor como un demonio para runlo en nuestra máquina.

Nos preguntábamos cómo podíamos "acceder" a ese contenedor.

La solución que ofrece docker es el comando [exec](https://docs.docker.com/engine/reference/commandline/exec/): la idea es crear un proceso que se "inserte" dentro del contenedor y se ejecute dentro.

Para lograr esto, Docker usa la llamada al sistema [nsenter](https://man7.org/linux/man-pages/man1/nsenter.1.html) que permite que un proceso "entre" en los espacios de nombres de otro proceso, en este caso, las del contenedor en el que queremos entrar.

Si recordamos el ejemplo anterior, teníamos un contenedor ejecutando nuestra imagen de Debian con el nombre "contedor-formacion".

Para poder ejecutar nuestro proceso por dentro, con un intérprete de comandos, corremos:

```shell
docker exec -ti contedor-formacion /bin/bash
```

Lo que le estamos diciendo a Docker es:

1. Queremos que ejecute un proceso dentro de un contenedor (_**exec**_).
2. Ese proceso tiene que ejecutarse en formato interactivo (_**-ti**_).
3. El contenedor se identifica con el nombre _**formación-contenedor**_.
4. El proceso que se ejecuta es _**/bin/bash**_ para abrir un shell bash dentro del contenedor.