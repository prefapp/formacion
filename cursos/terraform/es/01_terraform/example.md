# Proceso y Kernel: Los recursos

> El kernel de un Sistema Operativo tiene como misión fundamental mediar entre las aplicaciones que se ejecutan en una máquina, los procesos y los diferentes dispositivos físicos y virtuales que la componen. Para ello se crea una abstracción fundamental: el **recurso**.

Los recursos pueden tener:

- una disponibilidad limitada.
- un acceso restringido.
- un trabajo privado.

Es tarea del kernel impedir que se monopolice el uso de los mismos, que se produzca un acceso indebido o que se utilicen simultáneamente recursos de uso exclusivo.

![Container](../../_media/01_que_e_un_contedor_de_software/container_1.png)

Además, el kernel realiza una importante labor de homogeneización, ocultando los detalles del funcionamiento de los diferentes dispositivos y ofreciendo a los procesos interfaces limpias y unificadas que estandarizan el uso de hardware de distintos orígenes.

> Podemos concluir, por tanto, que los procesos no "ven" **los dispositivos que componen la máquina donde se ejecutan, sino la representación que les ofrece el kernel**.

![Container](../../_media/01_que_e_un_contedor_de_software/container_2.png)
