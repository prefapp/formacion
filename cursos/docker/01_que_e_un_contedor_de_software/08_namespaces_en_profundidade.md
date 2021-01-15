# Namespaces en profundidad

## 1 - Tipos de namespaces

Como xa falaramos noutra sección, os namespaces son un mecanismo de aillamento de certos recursos que permite crear vistas "privadas" do SO para un proceso ou conxunto de procesos. 

Cada un dos namespaces ailla un tipo concreto de recurso ou familia de recursos:

- _Pids_: identificadores de procesos, grupos de procesos e sesións. Máis información en [1](https://lwn.net/Articles/531114/), [2](https://lwn.net/Articles/531419/) e [3](https://lwn.net/Articles/532748/).
- _Network_: redes, pilas de red, regras de cortalumes. Máis información [aquí](https://lwn.net/Articles/580893/).
- _Usuarios_: xestión de usuarios e grupos de usuarios. Máis información neste [artigo](https://lwn.net/Articles/532593/).
- _UTS_: (Unix Time-sharing System) para hostname e domainname. Discútense neste [fío](https://lwn.net/Articles/179345/) e neste [artigo](https://lwn.net/Articles/531114/).
- _IPC_: sockets, memoria compartida, semáforos. Neste [artigo](https://lwn.net/Articles/531114/) hai mais información.
- _Mount_: montaxe de sistemas de ficheiros por proceso ou grupo de proceso. Hai unha discusión en profundidade neste [artigo](https://lwn.net/Articles/689856/).

## 2 - Comandos de xestión de namespaces

Existen una serie de comandos que nos permiten interactuar cos namespaces, son:

- **unshare**: acepta un comando a lanzar como parámetro e crea novos namespaces para él segundo os flags que se lle pasen. 
 - Mediante esta utilidade pódense lanzar procesos conterizados isto é, aillados en namespaces propios para eles e os seus procesos-fillo.
 - Permite un control fino dos namespaces (UTS, pids, rede, usuarios, ipc...)
 - Pódese atopar máis información do comando na páxina do manual de linux.
- **nsenter**: trátase do comando inverso ó anterior. Se unshare permítenos aillar un proceso, o comando nsenter permite "entrar" ou unirse a un namespace existente. 
 - Pódese atopar máis información do comando na páxina do [manual de linux](http://man7.org/linux/man-pages/man1/nsenter.1.html).

### A - Emprego do comando unshare

O comando **unshare** permite alterar o entorno de execución dun proceso mediante a creación de namespaces propios para él.

Nun exemplo sinxelo:

```bash
unshare -fp /bin/bash
```

O que estamos a facer é:

- Lanzar o comando ```/bin/bash```.
- O flag ```-fp``` indica a unshare que, hay que crear un novo namespace (de pids) para o proceso de ```/bin/bash``` e que debe correr nun fork novo.
Se executamos esa sentencia no noso terminal, non notaremos ningún cambio. De feito, se probamos a facer un top ou un ps non hai diferencia ningunha: seguimos a ver os procesos da nosa máquina. 

Sen embargo, o bash que corremos **xa non está no namespace global de pids**. 

![Container](./../_media/01_que_e_un_contedor_de_software/namespaces_1.png)

Para probar isto, imos sair do bash creado:

```bash
exit
```

E imos correr outra vez o comando anterior, pero solicitando ó sistema que nos monte un proc novo acorde ó noso namespace de pids.

```bash
unshare -fp --mount-proc /bin/bash
```

Se agora facemos un ```top``` ou un ```ps``` veremos só dous procesos. Isto é, **o proceso que lanzamos "vive" nun namespace de pids propio**. O proceso ```/bin/bash``` lanzado terá pid 1. Se abrimos outra terminal e buscamos na nosa árbore de procesos o ```/bin/bash``, veremos que ten un pid diferente que non é o pid 1. 


Unha pregunta moi interesante neste punto é saber a razón de que o proceso de /bin/bash teña pid 1. Unha discusión sobre este tema pódese atopar [aquí](https://hackernoon.com/the-curious-case-of-pid-namespaces-1ce86b6bc900).

### B - Inserción de procesos noutros namespaces: o comando nsenter

Tal e como dixemos, o comando **nsenter** permite que un proceso se inserte nun ou varios namespaces xa existentes.

#### i) Listaxe dos namespaces
Para procurar os namespaces, como regra xeral, basta con acudir a ```/proc/<pid do proceso>/ns```. Ahí veremos os namespaces dun proceso concreto.

Estes namespaces poden referenciarse mediante a súa ruta. 

#### ii) Empregando nsenter
Tal e como dixemos, basta con especificar o pid do proceso creador dos namespaces para poder ter acceso a eles cun proceso novo. 

Imos empregar o comando da sección anterior para lanzar unha shell que corra no seu propio namespace de pids e co seu propio ```/proc```.

```bash
unshare -fp --mount-proc /bin/bash
```

Abrimos outro terminal e buscamos o pid do proceso /bin/bash lanzado por (aparecerá colgando dun proceso unshare)

Agora lanzamos o seguinte comando:

```bash
nsenter --target <pid> -p -m
```

Esto implica:

- Lanzar un comando (se non especificamos será por defecto o intérprete contido en ```$SHELL```).
- Buscando os namespaces propios do proceso co pid expresado en ```--target```.
- Insertarse no seu espazo de pids (```-p```).
- Participar dos seus mounts (```-m```).

Se agora facemos dende a nova ```shell``` un ```top``` ou un ps veremos os procesos que corren no namespace de pids creado polo unshare. 

Nun diagrama:

![Container](./../_media/01_que_e_un_contedor_de_software/namespaces_2.png)

**Σ Webgrafía**
- Abrams, Vish. "The curious case of pid namespaces" [en liña](https://hackernoon.com/the-curious-case-of-pid-namespaces-1ce86b6bc900) [Consulta: 06-xan-2018].