# Solución parcial: virtualización da plataforma

Unha das solucións que se empregan para evitar o problema da falta de illamento do SO dos recursos globais, é a virtualización a nivel de plataforma.

Existen diversas técnicas (paravirtualización, full virtualization) pero a idea á a mesma: virtualizar o hardware, esto é, simular un ordenador mediante software.

![Container](./../_media/01_que_e_un_contedor_de_software/container_5.png)

De esta forma, e dado que temos varias máquinas virtuais, cada unha co seu sistema operativo, podemos illar os recursos globaies antes mencionados.

![Container](./../_media/01_que_e_un_contedor_de_software/container_6.png)

Non obstante,

- O coste en CPU/RAM da emulación do hardware é elevado
- O tempo de arranque/parada dunha máquina virtual é considerable (> 1')

Por soposto a virtualización de plataforma sigue tendo virtudes importantes:

- Mellor aproveitamento do hardware 
- Automatización dos desplegues
- Portabilidade de VMs

> Con todo, o su emprego con fins de illamento de procesos é **excesivamente caro en térmos de tempo e recursos**. 
