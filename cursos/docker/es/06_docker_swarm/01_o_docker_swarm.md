# Introducción

Hasta ahora hemos visto cómo lanzar contenedores en un solo host Docker.

En este tema vamos a ir un paso más allá, y veremos una opción existente, integrada dentro del propio motor Docker, para lanzar contenedores y orquestarlos en un clúster de hosts Docker (en un conjunto de máquinas que actúan como si fueran una sola). ).

Ni que decir tiene que esta no es la única opción disponible\*, ya que se trata de un tema candente que busca acomodarse a las características demandadas en los entornos de producción (escalabilidad, alta disponibilidad, resiliencia, elasticidad...). Pero eso sí, es uno de los más utilizados por su completa integración dentro de Docker y su ecosistema, permitiendo manejar la complejidad de un clúster, así como las abstracciones que ya conocemos, lo que facilita su uso.

*Sin embargo, [Kubernetes](https://kubernetes.io), la alternativa de código abierto de Google, ha surgido en los últimos meses como el estándar para orquestar contenedores en un grupo de máquinas*.

# El Docker Swarm

Se puede conectar un conjunto de 2 o más máquinas (físicas, virtuales) donde se ejecuta el demonio Docker (docker engine) para formar un clúster, de manera que actúen como un solo sistema, agrupando recursos y permitiendo el despliegue de una mayor cantidad de servicios. , escalarlos horizontalmente de 1 a N contenedores, hacerlos altamente disponibles...

Hasta la versión 1.12 de Docker, era necesario utilizar un nuevo componente aparte de Docker Engine, para que esta funcionalidad funcionara, pero a partir de esa versión ya viene integrado de serie, lo que simplificó mucho la tarea de crear un clúster de nodos Docker.

![img](../../_media/05_docker_swarm/swarm01.png)

En la imagen puedes ver como se pasó de un complejo proceso de 7 pasos a uno nuevo, donde con 2 simples comandos puedes activar el modo Swarm entre 2 nodos!

Ni que decir tiene que, a pesar de las ventajas, siempre hay ciertos contras, ya que esta evolución rompió con muchos supuestos definidos inicialmente.

El nuevo swarm, a pesar de ser compatible con el anterior, modificó los conceptos básicos de trabajo (para igualarlos a otras plataformas como Kubernetes), y esto generó una gran controversia en la comunidad y el ecosistema, y ​​también dificultó su adopción, ya que los usuarios vio docker como una plataforma inestable para postular como una opción para instalar en entornos de producción.
