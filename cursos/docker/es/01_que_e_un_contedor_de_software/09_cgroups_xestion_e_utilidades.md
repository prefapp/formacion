# Cgroups: gestión y utilidades

Hay varias formas de interactuar con el sistema cgroups:

- Por acceso directo al [sistema de archivos de cgroups](https://man7.org/linux/man-pages/man7/cgroups.7.html).
- Utilizando los comandos cgm del paquete [cgmanager](https://linuxcontainers.org/cgmanager/).
- Utilizando las herramientas cgcreate, cgexec y cgclassify del paquete [libcgroup](http://libcg.sourceforge.net/html/main.html).
- A través de otras herramientas como [lxc](https://linuxcontainers.org/) o el propio [systemd](https://es.wikipedia.org/wiki/Systemd).

Para entender cómo funciona, concentrémonos en controlar cgroups manipulando directamente el sistema de archivos de cgroup.

El kernel monta el sistema de archivos cgroups en la ruta ```/sys/fs/cgroup```. Dado que es un sistema de archivos, se puede interactuar con él utilizando las herramientas "tradicionales" de los sistemas tipo UNIX.

Existen dos versiones del sistema de cgroups: v1 y v2. Aunque la versión v2 se ha desarrollado hace casi una década, es posible que nuestra versión de Linux no la haya implementado todavía o que se haya deshabilitado manualmente a través del kernel. Para comprobar si podemos usar cgroups v2, ejecutamos el siguiente comando:

```bash
grep cgroup /proc/filesystems
```

Si tenemos cgroups v2 habilitado, el resultado será el siguiente:

```bash
nodev    cgroup
nodev    cgroup2
```

En caso contrario, el resultado será:

```bash
nodev    cgroup
```

Dado que la estructura de las carpetas es distinta en función de la versión utilizada, a continuación diferenciamos cómo hacer la configuración en cada una de ellas.

## Gestión de recursos con cgroups v1

Para crear un nuevo grupo, creamos una nueva carpeta con el nombre que queramos darle:

```bash
mkdir /sys/fs/cgroup/memory/grupo1
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

Si queremos modificar este fichero, sea porque faltan controladores o porque sobran, podemos hacerlo del siguiente modo:

```bash
echo [+-]nome_controlador >> /sys/fs/cgroup/cgroup.subtree_control
```

Donde:

- [+-] indica la operación que vamos a realizar. + indica habilitar un controlador, - indica deshabilitarlo.
- nome_controlador es el nombre del controlador que queremos habilitar. Los nombres posibles son: `cpuset`, `cpu`, `memory`, `io`, `hugetlb`, `pids`, `rdma`, `mems`, `perf_event` y `misc`. En este curso solo vamos a explicar las opciones para los controladores `cpu` y `memory`. Para más información, [aquí](https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#controllers) tienes un enlace a la sección relevante de la documentación.

Para poder habilitar uno de estos controladores en un cgroup hijo es necesario que existan dentro del archivo `cgroup.controllers` del padre. Es decir:

- Tenemos un grupo con el siguiente archivo `cgroup.controllers`: ```cpu memory pids```
- Intentamos habilitar el controlador `io` para sus hijos: ```echo +io >> /sys/fs/cgroup/grupo_fillo/cgroup.subtree_control```
- El resultado será un error de escritura: no hay tal archivo o directorio.


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
cat /sys/fs/cgroup/grupo1/memory.current
```

### cgroups v2 en profundidad: las opciones de los controladores cpu y memory

A continuación trataremos un poco más en detalle las distintas opciones disponibles para estos dos controladores. Al lado del nombre de cada opción indicamos si es de solo lectura (R) o de lectura-escritura (RW). Siempre que se indique una duración como posible valor, este vendrá dado en microsegundos (1000 microsegundos = 1 milisegundo). Siempre que se indique un tamaño de memoria, vendrá por defecto en bytes (1000000 bytes = 1000 kilobytes = 1 megabyte), aunque también se puede indicar con la misma notación que utiliza `fdisk` y programas similares (p. e. 1G = 1 gigabyte, 23K = 23 kilobytes, etc...)


`cpu`:
  - `cpu.stat` (R): muestra información sobre el estado de la CPU.
  - `cpu.weight` (RW): indica el porcentaje de CPU que le corresponde a este grupo cuando haya una gran carga, es decir, cuando los procesos estén compitiendo por conseguir ciclos de CPU. No tendrá ningún efecto si hay recursos disponibles suficientes para satisfacer a todos los procesos en ejecución. Su valos por defecto es 100 y los valores posibles son los que se encuentan en el rango [1, 10000].
  - `cpu.weight.nice` (RW): equivalente a la opción anterior, pero aceptando valores `nice`. El valor por defecto es 0 y los valores posibles son los que se encuentran en el rango [-20, 19]. `cpu.weight` tiene preferencia sobre esta opción. Al modificar una se debería modificar la otra, dándole aproximadamente el mismo valor.
  - `cpu.max` (RW): el ancho de banda de la CPU máximo que puede consumir el cgroup en un periodo determinado. El formato es `$MAX $PERIOD`, donde `$MAX` es el tiempo que se le permite consumir de CPU al cgroup durante `$PERIOD`. El valor por defecto es `max 100000` y los valores posibles son una duración o _max_ para `$MAX` (_max_ significa "sin límite") y una duración para `$PERIOD`. Si solo se le indica un valor, se actualizará solo el de `$MAX`. Cabe destacar que el valor que se indica para  `$MAX` es el uso total del cgroup, **non** de sus procesos. Es decir, si limitamos la CPU de un grupo a 25000 microsegundos durante un periodo de 100000 y lanzamos dos procesos intensivos sobre ella, cada uno de ellos consumirá 12500 microsegundos de CPU (para un total de 25000, la limitación que hemos impuesto) en lugar de 25000 (que sería el doble de nuestra limitación, 50000 microsegundos).
  - `cpu.max.burst` (RW): esta opción no está muy documentada. Permite al recurso recibir un pequeño empujón (_burst_) de recursos que excede el límite impuesto por la opción anterior. El valor por defecto es 0 y los valores posibles se encuentran en el rango [0, $MAX]
  - `cpu.pressure` (RW): muestra información referente a la presión de la CPU. Más info sobre este tema [aquí](https://www.kernel.org/doc/html/latest/accounting/psi.html#psi)
  - `cpu.uclamp.min` (RW): utilización mínima de CPU que deben hacer las tareas. El valor por defecto es 0 y los valores posibles se encuentran en el rango [0, 100] (siendo estos valores porcentajes como números racionales, es decir, 34.56 -> 34'56%).
  - `cpu.uclamp.max` (RW): utilización máxima de CPU que pueden hacer las tareas. El valor por defecto es _max_ y los valores posibles se encuentran en el rango [0, 100] (siendo estos valores porcentajes como números racionales, es decir, 76.54 -> 76'54%) o _max_ (sin límite)
 
`memory`:
  - `memory.current` (R): muestra el total de memoria que están utilizando el cgroup y sus cgroup hijos.
  - `memory.min` (RW): el mínimo de memoria que puede estar utilizando un proceso en el cgroup. Esto es, no se reutilizará memoria de procesos que estén consumiento la misma o menor cantidad de memoria de la que viene especificada en su `cgroup/memory.min`. Si el proceso utiliza más, esta será reutilizada cuando haga falta. En caso de que sea necesario reutilizar memoria y no haya nada disponible para ello se ejecutará el proceso de eliminación por falta de memoria (Out Of Memory killer, OOM killer). El valor por defecto es 0 y los valores posibles son tamaños de memoria.
