# Cgroups: gestión y utilidades

Hay varias formas de interactuar con el sistema cgroups:

- Por acceso directo al [sistema de archivos de cgroups](https://man7.org/linux/man-pages/man7/cgroups.7.html).
- Utilizando los comandos cgm del paquete [cgmanager](https://linuxcontainers.org/cgmanager/).
- Utilizando las herramientas cgcreate, cgexec y cgclassify del paquete [libcgroup](http://libcg.sourceforge.net/html/main.html).
- A través de otras herramientas como [lxc](https://linuxcontainers.org/) o el propio [systemd](https://es.wikipedia.org/wiki/Systemd).

Para entender cómo funciona, concentrémonos en controlar cgroups manipulando directamente el sistema de archivos de cgroup.

El kernel monta el sistema de archivos cgroups en la ruta ```/sys/fs/cgroup```. Dado que es un sistema de archivos, se puede interactuar con él utilizando las herramientas "tradicionales" de los sistemas tipo UNIX.

Dado que la estructura de las carpetas es diferente según la versión de cgroups utilizada, a continuación diferenciaremos cómo se haría la configuración en cada una de ellas.

## Gestión de recursos con cgroups v1

Para crear un nuevo grupo, creamos una nueva carpeta con el nombre que queramos darle:

```bash
mkdir /sys/fs/cgroup/memoria/grupo1
```

Si enumeramos su contenido (usando ```ls```) veremos que el Kernel ha creado una gran cantidad de elementos, en forma de archivos, que controlan varios parámetros de ejecución de los procesos que están dentro del grupo.

Una vez que hayamos creado nuestro grupo, podemos comenzar a establecer limitaciones de memoria. Para ello, debe actualizar/crear el archivo ```memory.limit_in_bytes```.

Así, por ejemplo, si desea limitar la memoria máxima que puede solicitar un proceso a ```100 MB```, sería suficiente con:

```bash
echo 100000000 > /sys/fs/cgroup/memory/grupo1/memory.limit_in_bytes
```
Pero, ¿cómo ponemos un proceso en este grupo de control? Basta con ingresar el pid del proceso en el sistema de control para que quede sujeto al grupo.

Así, si tenemos un proceso con pid 1441, para ponerlo en nuestro grupo de control, bastaría con hacer:

```bash
echo 1441 > /sys/fs/cgroup/memory/grupo1/cgroup.procs
```

Si queremos verificar que realmente se está ejecutando dentro de ese grupo de control, podríamos verificarlo así:

```bash
ps -o cgroup 1441
```

El sistema también permite monitorear el consumo de memoria del conjunto de procesos que se encuentran dentro del grupo. Así, a través de esta sentencia:

```bash
cat /sys/fs/cgroup/memory/grupo1/memory.usage_in_bytes
```

Podríamos saber la memoria en bytes que está usando nuestro proceso (y todos sus procesos descendientes).

## Gestión de recursos con cgroups v2

Para empezar, comprobamos que los controladores que nos interesan (en este caso cpu y memoria) están en el archivo /sys/fs/cgroup/cgroup.subtree_control:

```bash
cat /sys/fs/cgroup/cgroup.subtree_control
```

Si no, podemos agregar los que faltan de la siguiente manera:

```bash
echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control
```

Este archivo también se creará dentro de los nuevos cgroups, lo que permite flexibilidad en cuanto a qué controladores estarán disponibles para sus grupos secundarios.

Agregamos un nuevo grupo, llamado "group1", creando una nueva carpeta:

```bash
mkdir /sys/fs/cgroup/grupo1
```

Si enumeramos el contenido de la nueva carpeta, veremos que el kernel ha creado todos los archivos necesarios para administrar los controladores que especificamos en la raíz.

Puede verificar qué controladores están disponibles en una carpeta mirando en su archivo `cgroup.controllers`:

```bash
cat /sys/fs/cgroup/grupo1/cgroup.controllers
```

Después de crear el grupo, comenzamos estableciendo límites en la memoria. Para ello, actualizaremos el archivo `memory.max`. Por ejemplo, para limitar la memoria solicitable por un proceso a 100 MB, usaríamos:

```bash
echo 100000000 > /sys/fs/cgroup/grupo1/memory.max
```

Ahora que tenemos el grupo creado y la regulación configurada, agreguemos un proceso a este grupo.

Para ello tendríamos que localizar el pid del proceso y añadirlo al fichero `cgroup.procs` del cgroup. Por ejemplo, si tenemos un proceso con pid 1441, haríamos lo siguiente para ponerlo en el grupo de control:

```bash
echo 1441 > /sys/fs/cgroup/grupo1/cgroup.procs
```

Podemos verificar que el proceso se está ejecutando realmente en el grupo de control de la siguiente manera:

```bash
ps-o cgroup 1441
```

El sistema también le permite monitorear el consumo de memoria de los procesos dentro del grupo, así como sus procesos secundarios. Esto se haría consultando el siguiente archivo:

```bash
cat /sys/fs/cgroup/grupo1/memoria.actual
```