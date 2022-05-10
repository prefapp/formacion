# Cgroups: xestión e utilidades

Existen diversos xeitos para interactuar co sistema de cgroups:

- Mediante o acceso directo ó [sistema de ficheiros de cgroups](https://man7.org/linux/man-pages/man7/cgroups.7.html).
- Empregando os comandos de cgm do paquete [cgmanager](https://linuxcontainers.org/cgmanager/).
- Mediante as ferramentas cgcreate, cgexec e cgclassify do paquete [libcgroup](http://libcg.sourceforge.net/html/main.html).
- Mediante outras ferramentas tales como [lxc](https://linuxcontainers.org/) ou o propio [systemd](https://es.wikipedia.org/wiki/Systemd).

A - Control dos cgroups mediante manipulación directa do sistema de ficheiros de cgroup

O kernel monta o sistema de ficheiros de cgroups na ruta ```/sys/fs/cgroup```. Dado que se trata de un sistema de ficheiros, pódese interactuar con él a través das ferramentas "tradicionais" dos sistemas de tipo UNIX. 

## Xestión de recursos con cgroups v1

Así, pódese crear un novo grupo:

```bash
mkdir /sys/fs/cgroup/memory/grupo1
```

Con esto creamos un grupo (de nome "grupo1").

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

Comprobamos que os controladores que nos interesan (neste caso cpu e memory) se atopan no ficheiro /sys/fs/cgroup/cgroup.subtree_control:

```bash
cat /sys/fs/cgroup/cgroup.subtree_control
```

En caso de non ser así, podemos engadir os que nos falten do seguinte xeito:

```bash
echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control
```

Este ficheiro se creará tamén dentro dos novos cgroups, permitindo flexibilizar que controladores estarán dispoñibles para os seus grupos fillo.

Engadimos un novo grupo, de nome "grupo1", creando unha nova carpeta:

```bash
mkdir /sys/fs/cgroup/grupo1
```

Se listamos a nova carpeta, veremos que o kernel creou tódolos ficheiros necesarios para xestionar as controladoras que especificamos na raíz.

Pódese consultar que controladoras están dispoñibles nunha carpeta consultando a seu ficheiro cgroup.controllers:

```bash
cat /sys/fs/cgroup/grupo1/cgroup.controllers
```

Agora que xa temos o grupo creado, comezamos establecendo limitacións na memoria. Para isto, actualizaremos o ficheiro memory.max. Por exemplo, para limitar a memoria solicitable por un proceso a 100MB, utilizaríamos:

```bash
echo 100000000 > /sys/fs/cgroup/grupo1/memory.max
```

Agora que xa temos o grupo creado e a limitación configurada, imos ver como teríamos que facer para engadir un proceso a este grupo. 

Para isto, teríamos que localizar o pid do proceso e engadilo ó ficheiro cgroup.procs do cgroup. Por exemplo, se temos un proceso co pid 1441, faríamos o seguinte para metelo no grupo de control:

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
