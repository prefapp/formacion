# Solución completa (1): los espacios de nombres

Los contenedores de software consisten en una técnica de virtualización a nivel de sistema operativo, también conocida como virtualización a nivel de proceso.

La idea es simple, ya que el SO es, desde el punto de vista del proceso, un conjunto de recursos, podemos darle una vista "privada" o virtual de esos recursos.

![Contenedor](./../_media/01_que_e_un_contedor_de_software/container_7.png)

Virtualizar esos recursos globales de tal manera que, desde el punto de vista del proceso, le sean privados, **de eso se trata un contenedor**.

> "Al igual que en la virtualización a nivel de plataforma, el sistema operativo "cree" que se está ejecutando en una máquina real, en la creación de contenedores, el proceso "cree" que tiene un sistema operativo para sí mismo"

La técnica de usar contenedores es superior a la virtualización de plataformas en que:

- No implica el coste de recursos adicionales por tener que emular hardware y ejecutar un SO en él: puedes tener miles de contenedores en un servidor.
- El inicio/parada de un contenedor es prácticamente el mismo que el inicio/parada de un proceso (< 1'').

A expensas de:

- Compartir el kernel del sistema operativo

Además, no es una alternativa a la técnica de virtualización de plataformas: por el contrario, es **totalmente compatible**. Precisamente, así se está utilizando en muchos sitios:

![Contenedor](./../_media/01_que_e_un_contedor_de_software/container_8.png)

Kerrisk Michael, "Espacios de nombres en funcionamiento, parte 1: descripción general de los espacios de nombres" [en línea](https://lwn.net/Articles/531114/) [Acceso: 6 de enero de 2019]
* El primero de 9 artículos para consultar una exploración en profundidad de los espacios de nombres en Linux y su estado como elemento fundamental para los contenedores.