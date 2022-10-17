# Pero, ¿qué é un contedor?

> Un contedor é unha [técnica de virtualización a nivel de sistema operativo](http://en.wikipedia.org/wiki/Operating-system-level_virtualization) que illa un proceso, ou grupo de procesos, ofrecéndolles un contexto de execución “completo”. Se entendo por contexto, ou entorno de execución, o conxunto de recursos (PIDs, red, sockets, puntos de montaje…) que lle son relevantes ao proceso.

Dentro do mundo Linux que é co tipo de contedores cos que vamos a traballar, un contedor está baseado nas tecnoloxías de namespaces e cgroups, as cais permiten  "separar" os procesos que corren dentro do contedor, do resto do sistema.

![Container](./../_media/01/contedor.png)

A medio camiño entre o chroot e as solucións del virtualización completas (KVM, VirtualBox, VMWare, Xen) o contedor no incurre no custo de virtualizar o hardware ou o kernel do SO ofrecendo, así e todo, un nivel de control e illamento moi superior ao do chroot.

O contedor é moito máis rápido en ser aprovisionado que a máquina virtual (VM), non precisa arrancar unha emulación de dispositivos nin o núcleo do sistema operativo, a costa dun nivel de illamento menor: procesos en distintos contedores comparten o mismo kernel.
## Namespaces

Os contedores de software consisten nunha técnica de virtualización a nivel de SO, tamén se coñocen como virtualización a nivel de proceso.

A idea é sinxela, dado que o SO é, dende o punto de vista do proceso, un conxunto de recursos, podemos ofrecerlle unha vista "privada" ou virtual desos recursos.

![Container](./../_media/01/contedor1.png)

A virtualización desos recursos globais de tal forma que, desde o punto de vista do proceso, sexan privados para él, **é no que consiste un contedor**.

> "De igual xeito que na virtualización a nivel de plataforma o SO "cree" estarse a executar nunha máquina real, na  containerización, o proceso "cree" ter un SO para sí mesmo"

A técnica de usar contedores é superior a da virtualización de plataforma en que:

- No supón un custe de recursos adicionais por ter que emular hardware e correr en él un SO: se poden ter milleiros de contedores nun servidor.
- O arranque/parada dun container é prácticamente igual ao arranque/parada dun proceso (< 1'').

A costa de:

- Compartir o Kernel do SO.

Ademais, non é alternativa a técnica de virtualización de plataforma: ao contrario, é **totalmente compatible**. Precisamente, é como se está a empregar en moitos sitios:

![Container](./../_media/01/contedor2.png)

**Σ Webgrafía**
- Kerrisk Michael, "**Namespaces in operation, part 1: namespaces overview**" [en liña]. Dispoñible: [enlace](https://lwn.net/Articles/531114/) [Consulta: 06-Xaneiro-2019]
 - O primeiro de 9 artigos a consultar para explorar en profundidade os namespaces en Linux e a súa condición de elemento fundamental para os contedores. 
 ## Cgroups

Sabemos que o Kernel de Linux ten como traballo evitar a monopolización por parte dos procesos de recursos básicos tales como:

- CPU
- Memoria
- Operacións E/S

A pregunta que xorde é: permite un control fino de acceso e consumo destes recursos?

A resposta é que, previamente á versión 2.6.24, existían mecanismos de control (fundamentalmente o comando [nice](https://linux.die.net/man/1/nice)) pero eran moi limitados.

Todo isto cambia coa adopción polo kernel de Linux, en xaneiro de 2008, dos [control groups](https://wiki.archlinux.org/index.php/cgroups) (abreviado cgroups) impulsados principalmente polos enxeñeiros de Google.

Os cgroups pódense ver como unha árbore en que os procesos están pendurados dunha pola de control de tal xeito que podense establecer, para ese proceso e os seus fillos:

- Limitacións de recursos.
- Prioridades de acceso a recursos.
- Monitorización do emprego dos recursos.
- Xestión a baixo nivel de procesos.

A flexibilidade que permiten é moi grande. Pódense crear distintos grupos de limitacións e control e asignar un proceso, e os seus fillos, a distintos grupos, facendo combinacións que permiten un grao moi alto de personalización.

![Container](./../_media/01/contedor3.png)
## Evolución das tecnoloxías de contedores

> Vamos a revisar unha serie de ferramentas e tecnoloxías que xurdiron ao longo dos anos en diferentes sistemas operativos, para dar resposta ao problema que se plantexaba no módulo 1 sobre a xestión de recursos dentro dun SO.

---
### **Xaulas chroot (1979)**

![chroot](./../_media/01/chroot.png)

No desenrolo do sistema Unix V7, agregouse unha nova chamada de sistema (chroot) que permitía cambiar o directorio raíz dun proceso, e os seus descendentes, a unha nova localización do sistema de ficheiros.

Este avance foi o comezo do illamento a nivel de proceso, posibilitando controlar o acceso aos ficheiros por proceso. 

Na actualidade esa ferramenta aínda está dispoñible en calquer sistema Unix , e por suposto en Linux. Podedes probala seguindo o seguinte exemplo:

```shell
# copiamos los binarios que queremos executar na xaula chroot
mkdir -p chroot/bin
sudo cp /bin/{ls,bash,mkdir,rm} chroot/bin/
sudo cp /usr/bin/tree chroot/bin/
```

```shell
# montamos librerias
mkdir chroot/{lib,lib64}
for i in {lib,lib64}; do sudo mount --bind /$i chroot/$i ; done
```

```shell
# chroot
sudo chroot chroot/
```

```shell
# probamos a executar estos comandos básicos de unix
ls
tree -d -L 2
mkdir /probando
```

```shell
# desmontamos
for i in {lib,lib64}; do sudo umount chroot/$i ; done
```

---

### **FreeBSD Jails (2000), Solaris Zones (2004)**

![Evil Jail](./../_media/01/evil_jail.png)
![Solaris](./../_media/01/solaris.png)

Duas décadas despois, un proveedor de hosting sacou un servizo sobre xaulas BSD para lograr unha separación de recursos clara entre os seus servizos e os dos seus clientes, e deste xeito mellorar a seguridade e facilitar a administración dos mesmos.

As xaulas de FreeBSD permiten a un administrador, particionar un sistema FreeBSD en varios sistemas BSD independentes e con menos recursos, illados, e coa capacidade de agregar unha IP a cada un deles.

Oracle agregou unha característica similar a Solaris, que combina o control de recursos que pode consumir un proceso, ca separación en zonas dos procesos que se executan na máquina.

---

### **OpenVZ (2005)**

![OpenVZ](./../_media/01/opevz.png)

Un ano máis tarde, a compañía Virtuozzo creou un novo sistema de virtualización basado en contedores, sobre o kernel de Linux, que permitía crear multiples contedores illados e seguros, nunha mesma máquina, como se dun servidor privado virtual se tratara.

O código de OpenVZ, aínda que está aberto, nunca formou parte da distribución oficial do kernel de Linux e se incorpora como unha serie de parches extra que se aplican sobre o código do kernel.

---

### **linuxcontainers (2008) e Docker (2013)**

![LinuxContanirs](./../_media/01/linuxcontainers.png)
![Docker](./../_media/01/docker_logo.png)

A primeira ferramenta de contedores de software que encontrou ampla acollida dentro da comunidade de Linux foi [LXC](https://linuxcontainers.org/), principalmente polas tecnoloxías que aglutinaba e que foron introducidas dentro do kernel de linux (**Namespaces e cgroups**).

O seu obxectivo e dispor dun contedor como un entorno o máis similar posible a unha máquina virtual, pero sen o sobrecoste de emular hardware.

A xestión de este contedor se fai mediante unha serie de ficheiros de configuración, donde o usuario ten que encargarse de descargar e preparar o sistema de ficheiros, e definir e configurar os namespaces onde quere conectar ao container, conectar a rede ... o que o convirte en unha ferramenta moi pouco amigable para un desenvolvedor.

A compañía dotCloud, onde traballaban os creadores de Docker, e que empregaba LXC para proporciona aos seus clientes un dos primeiros [servizos de aloxamento PaaS](https://azure.microsoft.com/es-es/overview/what-is-paas/) que apareceu no mercado, buscando unha forma de facilitar a adopción do seu servizo, e trantando de facer máis accesible a tecnoloxía de contedores aos desenvolvedores de aplicacións, creou o proxecto que sería o precursor de Docker.

Docker se libera como proxecto de [código aberto](https://github.com/moby/moby) o 13 de marzo de 2013, e na actualidade a pesar do cambio de estratexia e de nome, ten máis de 50.000 estrelas en Github e casi 2.000 contribuidores, e convertiuse na principal tecnoloxía para a xestión de contedores.

* **Saber máis**

 - [A brief history of containers](https://blog.aquasec.com/a-brief-history-of-containers-from-1970s-chroot-to-docker-2016)

 - [Confining the omnipotent root](http://phk.freebsd.dk/pubs/sane2000-jail.pdf)
