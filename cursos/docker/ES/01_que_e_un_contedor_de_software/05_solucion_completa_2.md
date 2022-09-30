# Solución completa (2): os cgroups

Sabemos que o Kernel de Linux ten como traballo evitar a monopolización por parte dos procesos de recursos básicos tales como:

- CPU
- Memoria
- Operacións E/S 

> A pregunta que xorde é: permite un control fino de acceso e consumo destes recursos? 

A resposta é que, previamente á versión 2.6.24, existían mecanismos de control (fundamentalmente o comando nice) pero eran moi limitados.

Todo isto cambia coa adopción polo kernel de Linux, en xaneiro de 2008, dos [control groups](https://wiki.archlinux.org/index.php/cgroups) (abreviado cgroups) impulsados principalmente polos enxeñeiros de Google. 

Os cgroups pódense ver como unha árbore en que os procesos están pendurados dunha pola de control de tal xeito que podense establecer, para ese proceso e os seus fillos:

- Limitacións de recursos.
- Prioridades de acceso a recursos.
- Monitorización do emprego dos recursos.
- Xestión a baixo nivel de procesos.

A flexibilidade que permiten é moi grande. Pódense crear distintos grupos de limitacións e control e asignar un proceso, e os seus fillos, a distintos grupos, facendo combinacións que permiten un grao moi alto de personalización. 

![CGroups](./../_media/01_que_e_un_contedor_de_software/cgroups_1.png)

A partir da versión 4.5 do kernel de Linux, aparece unha nova versión de cgroups. A principal diferenza que implementa cgroups v2 é a forma na que se establece a xerarquía.

A nova versión deixa de utilizar distintas árbores para cada controlador (memoria, CPU, etc.), e funciona de tal xeito que, ó crear un novo grupo, este pasa a ser a raíz, da cal penduran os distintos controladores. 

Grazas a este cambio, xa non é preciso crear o mesmo grupo dentro de cada un dos distintos controladores, senón que se centraliza a configuración de todos eles dentro da carpeta do grupo.
