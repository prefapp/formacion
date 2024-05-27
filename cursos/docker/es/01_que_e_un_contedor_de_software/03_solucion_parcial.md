# Solución parcial: virtualización de plataformas

Una de las soluciones que se utilizan para evitar el problema de la falta de aislamiento del SO de los recursos globales, es la virtualización a nivel de plataforma.

Existen varias técnicas (paravirtualización, virtualización completa) pero la idea es la misma: virtualizar el hardware, es decir, simular una computadora usando software.

![Contenedor](../../_media/01_que_e_un_contedor_de_software/container_5.png)

De esta forma, y ​​dado que disponemos de varias máquinas virtuales, cada una con su propio sistema operativo, podemos aislar los citados recursos globales.

![Contenedor](../../_media/01_que_e_un_contedor_de_software/container_6.png)

Sin embargo,

- El costo de CPU/RAM de la emulación de hardware es alto
- El tiempo de inicio/parada de una máquina virtual es considerable (> 1')

Por supuesto, la virtualización de plataformas aún tiene importantes virtudes:

- Mejor uso del hardware.
- Automatización de despliegues
- Portabilidad de máquinas virtuales

> Sin embargo, su uso con fines de aislamiento de procesos es **excesivamente costoso en términos de tiempo y recursos**.