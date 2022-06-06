# Proceso e Kernel: os recursos

> O kernel dun SO ten como misión fundamental a de mediar entre as aplicacións que se executan nunha máquina, os procesos, e os distintos dispositivos físicos e virtuais que a compoñen. Para esto, se crea unha abstracción fundamental: o **recurso**.

Os recursos poden ter:

- una dispoñibilidade limitada.
- un acceso restrinxido.
- un empleo privativo.

É tarefa do kernel impedir que se monopolice o uso dos mesmos, que se produzan accesos indebidos ou que se simultanee o uso de recursos de utilización exclusiva.

![Container](./../_media/01_que_e_un_contedor_de_software/container_1.png)

Ademais, o kernel leva a cabo unha importante labor de homoxeneización, ocultando os detalles do funcionamento dos diferentes dispositivos e ofrecendo aos procesos interfaces limpas e unificadas que, estandarizan o emprego de hardware de distinta procedencia.

> Podemos concluir, por tanto, que os procesos non “ven” **os dispositivos que conforman a máquina onde corren, senón a representación que dos mesmos lles ofrece o kernel**.

![Container](./../_media/01_que_e_un_contedor_de_software/container_2.png)
