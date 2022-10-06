# Acciones básicas

## Comandos básicos

En esta sección veremos un conjunto de comandos básicos para la gestión de swarms

* Inicializar un swarm

```sh
docker swarm init --advertise-addr <MANAGER-IP>
```

* Únete a un swarm

```sh
docker swarm join --token xxxxxxx <MANAGER-IP>:2377
```


*Un nodo se une al clúster como trabajador o administrador según el token utilizado al unirse.*

* deploy una pila, desde docker-compose.yaml

```sh
docker stack deploy -c <path do docker-compose.yaml> <nome da stack>
```

* Ver el estado de las tareas de la pila

```sh
docker stack ps <nome da stack>
```

* Eliminar una pila

```sh
docker stack rm <nome da stack>
```
## La sección "deploy"

Para que un docker-compose.yaml se pueda deploy en un swarm, primero debe tener el campo **version** >= **3**. Actualmente están en la versión 3.6.

La principal diferencia de un docker-compose habilitado para ejecutarse en swarm (v3), con respecto a lo que vimos en el tema anterior (v2), es la sección [deploy](https://docs.docker.com/compose/compose-file/#deploy).

Veamos las principales opciones que se pueden declarar dentro de este apartado:

### mode
Puede ser **replicated** o **global**. Por defecto, el modo de implementación es *replicated*, esto significa que queremos que el contenedor asociado a un servicio se replique con un número determinado de réplicas, repartidas por todo el clúster de swarm. Esta es la forma de equilibrar la carga.
Si especificamos *global*, el swarm se encargará de la existencia, EN CADA NODO DEL CLUSTER, de un contenedor con nuestro servicio.

![img](../_media/05_docker_swarm/swarm04.png)

para obtener más información, consulte [docker](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#replicated-and-global-services)

### réplicas

Si el servicio es de tipo **replicated**, esta es la cantidad de contenedores que queremos que estén activos simultáneamente en todo el clúster.

### update_config

Cómo queremos que se lleve a cabo la estrategia de actualización de nuestro servicio. Cuando hay que desplegar una nueva versión de nuestro servicio, como queremos que lo haga swarm, todas las réplicas a la vez, de N a N, para no perder el servicio...

### restart_policy

En caso de que una de las réplicas de nuestro servicio termine, cómo queremos que reaccione el clúster.
En el apartado **condición** especificaremos una de las 3 opciones que nos da swarm:

* **none**: si un contenedor de nuestro servicio falla, no intente iniciarlo de nuevo.
* **on-failure**: si el contenedor terminó en un estado fallido (exit code != 0) reinícielo e intente comenzar de nuevo
* **any**: cada vez que finaliza un contenedor de nuestro servicio, reinícielo para intentar que vuelva a funcionar.

Aparte de eso, hay una serie de parámetros adicionales en los que puede ajustar el comportamiento de reinicio (cuántos intentos debe hacer el clúster para reiniciar el contenedor, cuánto tiempo debe pasar entre intentos...)

### labels

labels puestas A NIVEL DE SERVICIO. También se pueden especificar a nivel de contenedor especificándolos fuera del campo de implementación. Además, también se pueden añadir a muchos otros objetos docker (imágenes, redes, volúmenes...)
Las labels son un campo muy interesante, que nos permitirá clasificar y organizar, según nuestros propios términos, cualquier objeto docker. En ellos podemos establecer descripciones de nuestros servicios, relaciones entre contenedores, información de cara al usuario...

### colocación

Este apartado nos permite indicar restricciones sobre en qué nodo deben correr los contenedores de nuestro servicio, por ejemplo porque queremos que los que tienen estado empiecen siempre en el mismo nodo, ya que es ahí donde está el volumen de datos asociado.

### recursos

Finalmente, en esta sección nos permiten especificar los recursos del nodo, que queremos reservar, o limitar, para los contenedores de nuestro servicio. Se divide en 2 claves correspondientes (**reservas** y **límites**), y normalmente configuraremos límites o reservas, de cpu y memoria.

Además del campo de implementación, también debe tener en cuenta que hay una serie de opciones válidas en docker-compose, que no son compatibles con el modo swarm:a

* [build](https://docs.docker.com/compose/compose-file/#build)
* [cgroup_parent](https://docs.docker.com/compose/compose-file/#cgroup_parent)
* [container_name](https://docs.docker.com/compose/compose-file/#container_name)
* [devices](https://docs.docker.com/compose/compose-file/#devices)
* [tmpfs](https://docs.docker.com/compose/compose-file/#tmpfs)
* [external_links](https://docs.docker.com/compose/compose-file/#external_links)
* [links](https://docs.docker.com/compose/compose-file/#links)
* [network_mode](https://docs.docker.com/compose/compose-file/#network_mode)
* [restart](https://docs.docker.com/compose/compose-file/#restart)
* [security_opt](https://docs.docker.com/compose/compose-file/#security_opt)
* [stop_signal](https://docs.docker.com/compose/compose-file/#stop_signal)
* [sysctls](https://docs.docker.com/compose/compose-file/#sysctls)
* [userns_mode](https://docs.docker.com/compose/compose-file/#userns_mode)
