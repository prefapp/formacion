# Orígenes de los contenedores de software

> Vamos a repasar una serie de herramientas y tecnologías que han ido surgiendo a lo largo de los años en diferentes sistemas operativos, para dar respuesta al problema planteado en el módulo 1 sobre la gestión de recursos dentro de un SO.

---

## **Jaulas Chroot (1979)**

![chroot](../../_media/02_docker/chroot.png)

En el desarrollo del sistema Unix V7, se agregó una nueva llamada al sistema (chroot) que permitía cambiar el directorio raíz de un proceso y sus descendientes a una nueva ubicación en el sistema de archivos.

Este avance fue el comienzo del aislamiento a nivel de proceso, lo que hizo posible controlar el acceso a los archivos por proceso.

Actualmente esa herramienta sigue estando disponible en cualquier sistema Unix, y por supuesto en Linux. Puedes probarlo siguiendo el siguiente ejemplo:

```shell
# copiamos los binarios que queremos ejecutar en la celda chroot
mkdir -p chroot/bin
sudo cp /bin/{ls,bash,mkdir,rm} chroot/bin/
sudo cp /usr/bin/tree chroot/bin/
```

```shell
# montamos librerías
mkdir chroot/{lib,lib64}
for i in {lib,lib64}; do sudo mount --bind /$i chroot/$i ; done
```

```shell
# chroot
sudo chroot chroot/
```

```shell
# probamos ejecutar estos comandos básicos de Unix
ls
tree -d -L 2
mkdir /probando
```

```shell
# desmontamos
for i in {lib,lib64}; do sudo umount chroot/$i ; done
```

---

## **FreeBSD Jails (2000), Solaris Zones (2004)**

![Cárcel del mal](../../_media/02_docker/evil_jail.png)
![Solaris](../../_media/02_docker/solaris.png)

Dos décadas después, un proveedor de hosting lanzó un servicio sobre jaulas BSD para lograr una clara separación de recursos entre sus servicios y los de sus clientes, y de esta forma mejorar la seguridad y facilitar la administración de los mismos.

Las jaulas de FreeBSD permiten a un administrador particionar un sistema FreeBSD en varios sistemas BSD independientes con menos recursos, aislados y con la capacidad de agregar una IP a cada uno de ellos.

Oracle ha agregado una función similar a Solaris, que combina el control de los recursos que puede consumir un proceso con la zonificación de los procesos que se ejecutan en la máquina.

---

## **OpenVZ (2005)**

![OpenVZ](../../_media/02_docker/opevz.png)

Un año después, la empresa Virtuozzo creó un nuevo sistema de virtualización basado en contenedores, sobre el kernel de Linux, que permitía crear múltiples contenedores aislados y seguros en una misma máquina, como si de un servidor privado virtual se tratase.

El código OpenVZ, aunque de código abierto, nunca ha sido parte de la distribución oficial del kernel de Linux y se incorpora como una serie de parches adicionales que se aplican sobre el código del kernel.

---

## **linuxcontainers (2008) y Docker (2013)**

![LinuxContainers](../../_media/02_docker/linuxcontainers.png)
![Docker](../../_media/02_docker/docker_logo.png)

La primera herramienta de contenedor de software que encontró una amplia aceptación dentro de la comunidad de Linux fue [LXC](https://linuxcontainers.org/), principalmente debido a las tecnologías que reunió y que se introdujeron en el kernel de Linux (**Namespaces y cgroups**).

Su objetivo es tener un contenedor como entorno lo más similar posible a una máquina virtual, pero sin la sobrecarga de emular hardware.

La gestión de este contenedor se realiza a través de una serie de archivos de configuración, donde el usuario tiene que descargar y preparar el sistema de archivos, y definir y configurar los espacios de nombres donde quiere conectarse al contenedor, conectarse a la red... lo que lo convierte en una herramienta muy hostil para un desarrollador.

La empresa dotCloud, donde trabajaron los creadores de Docker, y que utilizó LXC para brindar a sus clientes uno de los primeros [servicios de hosting PaaS](https://azure.microsoft.com/es-es/overview/what-is-paas/) que apareció en el mercado, buscando la forma de facilitar la adopción de su servicio, y tratando de hacer más accesible la tecnología de contenedores a los desarrolladores de aplicaciones, creó el proyecto que sería el precursor de Docker.

Docker se lanza como un proyecto [de código abierto](https://github.com/moby/moby) el 13 de marzo de 2013 y hoy, a pesar del cambio de estrategia y nombre, tiene más de 50 000 estrellas en Github y casi 2000 colaboradores, y se ha convertido en la tecnología líder para la gestión de contenedores.

* **Aprende más**

  - [Una breve historia de los contenedores](https://blog.aquasec.com/a-brief-history-of-containers-from-1970s-chroot-to-docker-2016)

  - [Confinamiento de la raíz omnipotente](http://phk.freebsd.dk/pubs/sane2000-jail.pdf)