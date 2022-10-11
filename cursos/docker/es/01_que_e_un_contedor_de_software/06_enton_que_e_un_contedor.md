# Entonces, ¿qué es un contenedor?

> Un contenedor es una [técnica de virtualización a nivel de sistema operativo](https://en.wikipedia.org/wiki/OS-level_virtualization) que aísla un proceso o grupo de procesos, dándoles un contexto de ejecución "completo". Si entiendo por contexto, o entorno de ejecución, el conjunto de recursos (PIDs, red, sockets, puntos de montaje...) que son relevantes para el proceso.

El contenedor se basa en espacios de nombres que lo mantienen "separado" del resto del sistema.

![Contenedor](./../_media/01_que_e_un_contedor_de_software/container_9.png)

A medio camino entre chroot y las soluciones de virtualización completa (KVM, VirtualBox, VMWare, Xen), el contenedor no incurre en el costo de virtualizar el hardware o el kernel del sistema operativo y aún ofrece un nivel mucho más alto de control y aislamiento para el chroot.

El contenedor es mucho más rápido de aprovisionar que la máquina virtual (VM), no necesita arrancar una emulación de dispositivo o el kernel del sistema operativo, a costa de un menor nivel de aislamiento: los procesos en diferentes contenedores comparten el mismo kernel.

