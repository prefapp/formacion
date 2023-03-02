# Cgroups: xestión e utilidades

Existen diversos xeitos para interactuar co sistema de cgroups:

- Mediante o acceso directo ó [sistema de ficheiros de cgroups](https://man7.org/linux/man-pages/man7/cgroups.7.html).
- Empregando os comandos de cgm do paquete [cgmanager](https://linuxcontainers.org/cgmanager/).
- Mediante as ferramentas cgcreate, cgexec e cgclassify do paquete [libcgroup](http://libcg.sourceforge.net/html/main.html).
- Mediante outras ferramentas tales como [lxc](https://linuxcontainers.org/) ou o propio [systemd](https://es.wikipedia.org/wiki/Systemd).

Para comprender o seu funcionamento, ímonos centrar no control dos cgroups mediante manipulación directa do sistema de ficheiros de cgroup.

O kernel monta o sistema de ficheiros de cgroups na ruta ```/sys/fs/cgroup```. Dado que se trata de un sistema de ficheiros, pódese interactuar con él a través das ferramentas "tradicionais" dos sistemas de tipo UNIX.

Existen dous versión do sistema de cgroups: v1 e v2. Aínda que a versión v2 foi desenvolta fai case unha década, é posible que a nosa versión de Linux particular non a teña implementada todavía, ou que fose deshabilitada manualmente a través dun parámetro de kernel. Para comprobar se podemos utilizar cgroups v2, basta con executar o seguinte comando:

```bash
grep cgroup /proc/filesystems
```

Se temos cgroups v2 habilitado, o resultado será o seguinte:

```bash
nodev    cgroup
nodev    cgroup2
```

No caso contrario, o resultado será:

```bash
nodev    cgroup
```

Dado que a estructura das carpetas é distinta en función á versión de cgroups utilizada, a continuación imos diferenciar como se faría a configuración en cada unha delas.

## Xestión de recursos con cgroups v1

Para crear un novo grupo, creamos unha nova carpeta co nome que queiramos darlle:

```bash
mkdir /sys/fs/cgroup/memory/grupo1
```

Se listamos o seu contido (mediante ```ls```) veremos que o Kernel creou unha morea de elementos, en forma de ficheiros, que controlan diversos parámetros de execución dos procesos que estén dentro do grupo.

Unha vez que temos o noso grupo creado,  podemos comezar a establecer limitacións de memoria. Para isto, hay que facer unha actualización/creación do ficheiro ```memory.limit_in_bytes```.

Así, por exemplo, no caso de querer limitar a memoria máxima solicitable por un proceso a ```100MB```, bastaría con:

```bash
echo 100000000  > /sys/fs/cgroup/memory/grupo1/memory.limit_in_bytes
```
Pero, cómo metemos un proceso neste grupo de control? Abonda con introducir o pid do proceso no sistema de control para que estea suxeito ó grupo. 

Así, se temos un proceso con pid 1441, para metelo no noso grupo de control, bastaría con facer:

```bash
echo 1441 >  /sys/fs/cgroup/memory/grupo1/cgroup.procs
```

Se queremos comprobar que realmente está correndo dentro dese grupo de control, poderíamos comprobalo deste xeito:

```bash
ps -o cgroup 1441
```

O sistema permite tamén monitorizar o consumo de memoria do conxunto de procesos que estén dentro do grupo. Así, mediante esta sentencia:

```bash
cat /sys/fs/cgroup/memory/grupo1/memory.usage_in_bytes
```

Poderíamos saber a memoria en bytes que está a empregar o noso proceso (e tódolos seus procesos descendentes).

## Xestión de recursos con cgroups v2

Para comezar, comprobamos que os controladores que nos interesan (neste caso cpu e memory) se atopan no ficheiro `/sys/fs/cgroup/cgroup.subtree_control`. Neste arquivo é onde se indican os controladores ós que terán acceso os cgroup fillos do grupo que estamos a ver:

```bash
cat /sys/fs/cgroup/cgroup.subtree_control
```

Se queremos modificar este ficheiro, ben porque faltan controladores ou ben porque sobran, podemos facelo da seguinte maneira:

```bash
echo [+-]nome_controlador >> /sys/fs/cgroup/cgroup.subtree_control
```

Onde:

- [+-] indica a operación que imos realizar. + indica habilitar un controlador, - indica deshabilitalo.
- nome_controlador é o nome do controlador que queremos habilitar. Os nomes posibles son: `cpuset`, `cpu`, `memory`, `io`, `hugetlb`, `pids`, `rdma`, `mems`, `perf_event` e `misc`. Neste curso só vamos a explicar as opcións para os controladores `cpu` e `memory`. Para máis información, [aquí](https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#controllers) tes un enlace á sección relevante da documentación.

Para poder habilitar un destes controladores nun cgroup fillo é necesario que existan dentro do arquivo `cgroup.controllers` do pai. É dicir:

- Temos un grupo co seguinte arquivo `cgroup.controllers`: ```cpu memory pids```
- Intentamos habilitar o controlador `io` para os seus fillos: ```echo +io >> /sys/fs/cgroup/grupo_fillo/cgroup.subtree_control```
- O resultado será un erro de escritura: non hai tal ficheiro ou directorio

Este ficheiro se creará tamén dentro dos novos cgroups, permitindo flexibilizar que controladores estarán dispoñibles para os seus grupos fillo.

Engadimos un novo grupo, de nome "grupo1", creando unha nova carpeta:

```bash
mkdir /sys/fs/cgroup/grupo1
```

Se listamos o contido da nova carpeta, veremos que o kernel creou tódolos ficheiros necesarios para xestionar as controladoras que especificamos na raíz.

Tras crear o grupo, comezamos establecendo limitacións na memoria. Para isto, actualizaremos o ficheiro `memory.max`. Por exemplo, para limitar a memoria solicitable por un proceso a 100MB, utilizaríamos:

```bash
echo 100000000 > /sys/fs/cgroup/grupo1/memory.max
```

Agora que xa temos o grupo creado e a limitación configurada, imos engadir un proceso a este grupo. 

Para isto, teríamos que localizar o pid do proceso e engadilo ó ficheiro `cgroup.procs` do cgroup. Por exemplo, se temos un proceso co pid 1441, faríamos o seguinte para metelo no grupo de control:

```bash
echo 1441 > /sys/fs/cgroup/grupo1/cgroup.procs
```

Podemos verificar que o proceso esté realmente correndo no grupo de control do seguinte modo:

```bash
ps -o cgroup 1441
```

O sistema permite tamén monitorizar o consumo de memoria que están realizando os procesos que hai dentro do grupo, así como os seus procesos fillos. Faríase consultando o seguinte ficheiro:

```bash
cat /sys/fs/cgroup/grupo1/memory.current
```

### cgroups v2 en profundidade: as opcións dos controladores cpu e memory

A continuación falaremos cun pouco más de detalle das distintas opcións dispoñibles para estos dous controladores. Ó lado do nome de cada opción indicamos se é de só lectura (R) ou lectura-escritura (RW). Sempre que se indique unha duración como posible valor, este virá dado en microsegundos (1000 microsegundos = 1 milisegundo). Sempre que se indique un tamaño de memoria, este virá por defecto dado en bytes (1000000 bytes = 1000 kilobytes = 1 megabyte), aínda que tamén se pode indicar coa mesma notación que utiliza `fdisk` e programas similares (p. e. 1G = 1 gigabyte, 23K = 23 kilobytes, etc...)

`cpu`:
  - `cpu.stat` (R): mostra información sobre o estado da CPU.
  - `cpu.weight` (RW): indica a porcentaxe de CPU que lle corresponde a este grupo cando haxa unha gran carga; isto é, cando os procesos estén pelexándose por conseguir ciclos de CPU. Non fará nada se hai recursos dispoñibles suficientes para satisfacer a tódoslos procesos en execución. O seu valor por defecto é 100 e os valores posibles son os que se atopan no rango [1, 10000].
  - `cpu.weight.nice` (RW): equivalente á opción anterior, só que aceptando valores `nice`. O valor por defecto é 0 e os valores posibles son os que se atopan no rango [-20, 19]. `cpu.weight` ten preferencia sobre esta opción. Modificar unha deberían de modificar a outra, dándolle o mesmo valor de maneira aproximada.
  - `cpu.max` (RW): o máximo ancho de banda da CPU que o cgroup pode consumir nun periodo determinado. O formato é `$MAX $PERIOD`, onde `$MAX` é o tempo que se lle permite consumir de CPU ó cgroup durante `$PERIOD`. O valor por defecto é `max 100000` e os valores posibles son unha duración ou _max_ para `$MAX` (_max_ significa "sen límite") e unha duración para `$PERIOD`. Se só se indica un valor, actualizarase só o de `$MAX`. Cabe notar o valor que se indica para `$MAX` é o uso total do cgroup, **non** dos seus procesos. É dicir, se limitamos a CPU dun grupo ó 25000 microsegundos durante un periodo de 100000 e lanzamos dous procesos intensivos nela, ambos consumirán 12500 microsegundos da CPU cada un (para un total de 25000, a limitación que impuximos) en lugar de 25000 (que sería o dobre da nosa limitación, 50000 microsegundos).
  - `cpu.max.burst` (RW): esta opción non está moi documentada. Permite ò recurso recibir un pequeño empurrón (_burst_) de recursos que excede o límite imposto pola opción anterior. O valor por defecto é 0 e os valores posibles atópanse no rango [0, $MAX]
  - `cpu.pressure` (RW): mostra información referente á presión da CPU. Máis info sobre ese tema [aquí](https://www.kernel.org/doc/html/latest/accounting/psi.html#psi)
  - `cpu.uclamp.min` (RW): utilización mínima da CPU que deben facer as tareas. O valor por defecto é 0 e os valores posibles atópanse no rango [0, 100] (sendo estos valores porcentaxes como números racionais (é dicir, 34.56 -> 34'56%))
  - `cpu.uclamp.max` (RW): utilización máxima da CPU que poder facer as tareas. O valor por defecto é _max_ e os valores posibles atópanse no rango [0, 100] (sendo estos valores porcentaxes como números racionais (é dicir, 76.54 -> 76'54%)) ou _max_ (sen límite)
 
`memory`:
  - `memory.current` (R): mostra o total de memoria que están utilizando o cgroup e os seus cgroup fillos. 
  - `memory.min` (RW): o mínimo de memoria que pode estar utilizando un proceso no cgroup. Isto é, non se reutilizará memoria de procesos que estén consumindo a mesma ou menor cantidade dela que a que ven especificada no seu `cgroup/memory.min`. Se o proceso utiliza máis, esta será reutilizada cando faga falta. No caso de que sexa necesario reutilizar memoria e non haxa ningunha dispoñible para elo, executarase o proceso de eliminación por falta de memoria (Out Of Memory killer, OOM killer). O valor por defecto é 0 e os valores posibles son tamaños de memoria.
