# Conceptos e Características do Enxame

## Conceptos:

Dentro dun cluster Swarm de anfitrións Docker debemos ter claros unha serie de conceptos:

### - Nodos

Cada un dos "anfitrións" docker que están participando no Docker Swarm.
Un nodo pode ser calquer tipo de servidor co demonio de docker instalado e vinculado a un cluster Swarm: dende unha máquina física, un vps ..., ata un contedor docker! (véxase [Play-with-docker](https://labs.play-with-docker.com)

Un nodo no cluster Swarm pode ser de tipo **Manager**, **Worker** ou **ambos a vez**
O caso máis común en pequenos clusteres e ter un nodo Manager que actua tamén como Worker, e os demais exclusivamente funcionando como Worker.

En caso de quere redundar o nodo master o axeitado e usar un número impar de masters,  para que poidan acadar un consenso (quorum) en caso de que disparidade. Para máis detalles sobre os nodos master , así como o algoritmo de consenso que empregan , podedes [ver esta páxina da documentación](https://docs.docker.com/engine/swarm/admin_guide/#operate-manager-nodes-in-a-swarm).

*Para xestionar o cluster e preciso conectar contra un dos nodos Manager, ao que lle enviaremos comandos ben directamente co cliente de Docker, ou ben mediante a api.*

Os Manager se encargan de xestionar os recursos do cluster, as novas alta e baixas de nodos, e monitorizar o estado dos **servicios swarm** que se executan dentro del, e, os Workers de aloxar os contedores de estos **servicios**.  De todas formas o Manager, en clústeres pequenos, se pode empregar perfectamente como Worker.

### - Servizos e Tarefas

Un servizo dentro do cluster swarm enténdese como a declaración dun estado desexado dos elementos que compoñen a nosa aplicación (o servicio web, o servicio de base de datos ...).

Unha tarefa (task) é a unidade atómica de planificación, un espacio (**slot**) onde o planificador vai a acabar poñendo un container.

A idea do swarm é ser un orquestador e planificador de propósito xeral, polo que, tanto as tasks como os servicios (services) son as abstraccións cas que traballa.

A partir de ahí, os services definen o estado desexado dos diferentes elementos que compoñen a nosa aplicación, e as tasks acaban encarnándose en contedores que levan a cabo a tarefa de conformar este estado desexado. Para entender esto con máis detalle podedes ver [esta páxina do manual](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/).

![image](../_media/05_docker_swarm/swarm02.png)

Un servizo se describe utilizando o linguaxe que coñecemos de docker-compose, pero con algunhas características extra. Véxase [docker-compose v3](https://docs.docker.com/compose/compose-file/compose-versioning/#version-3).

A principal é a sección de [**deploy**](https://docs.docker.com/compose/compose-file/#deploy) onde se especifican as características de despregue que se quere aplicar a ese servicio (replicas, política de actualización ...)

	*Realmente o concepto de **servicio** en docker-compose e docker swarm non son exactamente o mesmo, principalmente porque a ferramenta de docker-compose está pensada para orquestar contedores nun único nodo Docker, e Docker Swarm xestionaos sobre un cluster de máquinas, e manexa conceptos máis avanzados como as réplicas ou as políticas de update.
	Pero docker trata de manter unha especificación compatible entre ambos ca idea de facer sinxelo o paso a entornos con múltiples nodos en cluster ( que se supón necesario para cumplir os requisitos dun entorno de producción)*

### - Stacks

Unha stack é unha colección de servicios que representan unha aplicación nun determinado entorno. Un ficheiro de stack é un ficheiro YAML co formato do docker-compose v3.

Realmente é o equivalente ao docker-compose.yaml nun cluster Swarm; unha maneira conveniente de desplegar servicios que están relacionados entre si para conformar unha aplicación.

## Características

Ademais de estos conceptos temos unha serie de características do Docker Swarm que debemos coñecer:
 
* **Modelo declarativo de servicios**: Docker Engine deixanos definir de maneira declarativa (non imperativa) o estado desexado dun conxunto de servizos que compoñen a nosa aplicación (stack). Por exemplo a nosa aplicación pode estar composta por un servicio de base de datos, de frontal web e cunha cola de mensaxes.
 
* **Escalado**: Para cada servicio, podemos definir o número de réplicas (tasks) que queremos correr. Cando incrementamos ou decrementamos este número e volvemos a publicar os cambios no swarm, os managers automáticamente reaccionan ao cambio agregando ou quitando réplicas para conformar o estado desexado.
 
* **Reconciliación co estado desexado**: Os managers constantemente monitorizan o estado desexado das stacks despregadas, de forma que si un nodo cae con N replicas dun container, o cluster se encarga de volver a arrincalas nos nodos que queden dispoñibles.
 
* **Rede Multi-host**: Cando se une un nodo a un cluster swarm se crean unhas redes virtuais por encima (overlay) das redes do propio host (underlay), o que permiten que os containers que se lancen no cluster se poidan ver entre si, a pesar de estar correndo en nodos diferentes, e incluso nos permitan definir redes entre diferentes containers, aisladas unhas de outras. Por exemplo: "quero que o container A esté na red R1, onde tamén ten que estar o container B, pero o C debe estar noutra rede R2 que non teña acceso á rede R1".
 
* **Ingress Routing Mesh**: En relacion ao anterior, cando algún servicio publica un porto ao exterior (declarando o atributo port), o cluster de swarm publica ese porto en todos os nodos de xeito que se pode chegar ao servicio conectándose á IP pública de calquera deles (co porto correspondente). Ademais automáticamente balancea as peticións entre todas as réplicas dispoñibles. Para máis info ver esta páxina do manual.

![img](../_media/05_docker_swarm/swarm03.png)

* **Service discovery**: Os nodos manager de Swarm asignan a cada servicio no swarm un unico nome DNS, e á vez tamén balancean as peticións recividas a ese nome DNS, entre todas as réplicas que teña dispoñible ese servicio. Calquer outro servicio pode alcanzar ao servicio inicial simplemente usando o nome do mesmo (por exemplo: bbdd, app ),  gracias ao DNS interno que ten embebido o cluster

* **Rolling updates**: Á hora de actualizar as replicas dun servicio, se pode especificar un tempo de desprege (rollout), de xeito que a actualización non se execute de golpe, senon que se faga de maneira incremental. E ademais se algo falla podese facer un roll-back do despregue, de xeito que volvamos a ter correndo unha versión previa do servicio.
