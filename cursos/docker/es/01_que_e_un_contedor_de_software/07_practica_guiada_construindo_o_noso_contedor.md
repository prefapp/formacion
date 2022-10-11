# Entonces, ¿qué es un contenedor?

> Usando las herramientas que nos da Linux, vamos a construir un contenedor para una distribución de Debian.

\**Nota: esta práctica se basa en [esto](https://ericchiang.github.io/post/containers-from-scratch/).*

## 1 - El sistema de archivos

Para ejecutar un sistema Debian, obviamente necesitamos el conjunto de herramientas, utilidades y demonios que tiene dicha distribución.

Descarguemos un sistema de archivos con todos los elementos necesarios.

Tomamos el alquitrán de este enlace.

En un directorio de nuestro sistema de archivos, descargamos el tar con el sistema debian:

```bash
wget https://github.com/ericchiang/containers-from-scratch/releases/download/v0.1.0/rootfs.tar.gz
```

Extraigamos el contenido del tar:

```bash
tar xfz rootfs.tar.gz
```

Si enumeramos el contenido del rootfs resultante, veremos que tiene una estructura muy similar a la de un sistema Debian tradicional.

## 2 - Enjaula el proceso en el sistema de archivos usando chroot

La herramienta [chroot](https://en.wikipedia.org/wiki/Chroot), nos permite aislar un proceso con respecto a una ruta específica dentro de nuestro sistema de archivos.

Si ejecutamos este comando desde la ruta donde descubrimos nuestro sistema de archivos:

```bash
chrootrootfs/bin/bash
```

Entraremos en una nueva shell, un nuevo proceso, que se monta desde 6. ```~/rootfs```.

![Contenedor](./../_media/01_que_e_un_contedor_de_software/container_10.png)

¿Tenemos un contenedor real?

La respuesta es no.

Si montamos el proc en una ruta de nuestro proceso:

```bash
montar -t proc proc /proc
```

Y hacemos un ps o un top, seguimos viendo todos los procesos del sistema.

Por lo tanto, nuestro proceso, aunque esté rooteado en rootfs, no está realmente aislado del resto del sistema, ya que todavía pertenece a los espacios de nombres globales.

Es decir, nuestro proceso **todavía está en el espacio de nombres global compartido por el resto de los procesos del sistema**.

![Contenedor](./../_media/01_que_e_un_contedor_de_software/container_11.png)

Como podemos ver, este proceso no está realmente "contenido":

- Puede crear usuarios en el espacio de nombres general de la máquina.
- Puedes ver los procesos de toda la máquina.
- Si modificas iptables, conectas a puertos... afectará al resto de procesos de la máquina.

Esto no es un verdadero aislamiento de nuestro proceso.

Para conseguirlo, recurriremos a los espacios de nombres.

## 3 - Aislar el proceso usando espacios de nombres

Como vimos en el paso 2, en realidad estamos lanzando un proceso que tiene una nueva raíz en el sistema de archivos, pero no está realmente aislado del resto de los recursos del sistema. Si realmente queremos aislarlo, tendríamos que crear una serie de espacios de nombres privados de ese proceso (y el resto de sus hijos).

En un diagrama:

![Contenedor](./../_media/01_que_e_un_contedor_de_software/container_12.png)

El comando [unshare](https://man7.org/linux/man-pages/man1/unshare.1.html) nos permite iniciar un comando o proceso especificando los espacios de nombres que queremos que sean privados.

Iniciemos un proceso nuevamente, pero esta vez a través de unshare:

```bash
unshare -m -i -n -p -u -f chroot rootfs /bin/bash
```

En este comando le estamos diciendo al sistema:

- Inicie el proceso chroot rootfs /bin/bash
- Aislar en nuevos namespaces de mounts, de ipc, de networking, de pids, de UTS al proceso
Sencillo, ¿verdad? Veamos si ese es realmente el caso.

Montamos el proc:

```bash
montar -t proc proc /proc
```

Si ingresamos el comando superior, veremos que tenemos dos procesos.

Vemos qué proceso tiene pid 1, es nuestro /bin/bash.

¿Cómo es posible?

Recordemos que ahora estamos dentro de un nuevo espacio de nombres PIDS, el proceso que creó ese espacio de nombres fue nuestro /bin/bash.

Vamos a hacer otra cosa:

```bash
hostname
```

Veremos el nombre de host de nuestra máquina. Lo cual no es extraño, ya que el espacio de nombres UTS fue clonado de nuestro UTS global.

Pero si ahora cambiamos el nombre de host dentro de nuestro contenedor:

```bash
hostname contenedor-a-man
```

Veremos que, efectivamente, nuestro nombre de host ha cambiado a "container-a-man".

Si abrimos otra terminal en nuestra máquina y hacemos hostname, veremos que conserva el nombre de host original.

Esto es posible porque, después de llamar a **unshare**, nuestro contenedor tiene una UTS (privada) diferente con respecto a la global.

## 4. Conclusión

Pudimos crear un proceso que está dentro de un contenedor (un conjunto de espacios de nombres privados para ese proceso).

De esta forma, acciones que normalmente afectarían a todos los procesos de la máquina:

- Cambiar el nombre de host.
- Creación de usuarios.
- Hacer monturas.
- Conectar aplicaciones para escuchar en puertos específicos.

Están aislados dentro de espacios de nombres de contenedores sin afectar la máquina.

Finalmente, observe que la creación del contenedor tomó casi el mismo tiempo que lanzar un nuevo proceso (hacer la prueba) y que el costo en memoria es insignificante.
