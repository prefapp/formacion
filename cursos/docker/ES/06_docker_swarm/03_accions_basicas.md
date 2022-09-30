# Accións básicas

## Comandos básicos

Neste apartado vamos a ver un conxunto de comandos básicos para a xestión do swarm

* Inicializar un swarm

```sh
docker swarm init --advertise-addr <MANAGER-IP>
```

* Unirse a un swarm

```sh
docker swarm join --token xxxxxxx <MANAGER-IP>:2377
```

*Un nodo se une ao cluster como worker ou como manager según o token que se use ao facer o join.*

* Desplegar unha stack, a partir dun docker-compose.yaml

```sh
docker stack deploy -c <path do docker-compose.yaml> <nome da stack>
```

* Ver o estado das tasks da stack

```sh
docker stack ps <nome da stack>
```

* Borrar unha stack

```sh
docker stack rm <nome da stack>
```

## A sección "deploy"

Para que un docker-compose.yaml se poida despregar nun Swarm o primeiro que ten que ter o campo **version** >= **3**. Actualmente están na versión 3.6.

A principal diferencia dun docker-compose habilitado para correr en Swarm (v3), con respecto ao que vimos no tema anterior (v2), é a sección [deploy](https://docs.docker.com/compose/compose-file/#deploy).

Vamos a ver as principáis opcións que se poden declarar dentro de esta sección:

### mode
Pode ser **replicated** ou **global**. Por defecto o modo de deploy e *replicated*, esto quere decir, que queremos que o container asociado a un servicio esté replicado cun número determinado de replicas, esparcidas por todo o cluster de Swarm. Este e a maneira de facer balanceo de carga.
Se especificamos *global*, o Swarm se vai a encargar de que exista, EN CADA NODO DO CLUSTER, un container co noso servicio.

![img](../_media/05_docker_swarm/swarm04.png)

para máis detalles ver [docker](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#replicated-and-global-services)

### replicas

Si o servicio é de tipo **replicated**, este é o número de contedores que queremos que estén activos simultaneamente en todo o cluster.

### update_config

Como queremos que se realice a estratexia de actualización do noso servicio. Cando haxa que despregar unha nova versión do noso servicio, como queremos que Swarm a leve a cabo, todas a replicas de golpe, de N en N, para evitar perder servicio...

### restart_policy

En caso de que unha das replicas do noso servicio finalice, como queremos que reaccione o cluster.
No apartado **condition**, especificaremos unhas das 3 opcións que nos da Swarm:

* **none**: se se cae un contedor do noso servicio non o trates de arrinar de novo.
* **on-failure**: se o contedor finalizou nun estado fallido (exit code != 0)  reiniciao, e trata de que arrinque  de novo
* **any**: sempre que finalice un contedor do noso servicio, reiniciao para tratar de que volva a estar operativo

Aparte hai unha serie de parámetros extra onde axustar finamente o comportamento de reinicio (canto intentos debe facer o cluster para arrincar de novo o contedor, canto tempo debe pasar entre intentos ...)

### labels

Etiquetas establecidas A NIVEL DO SERVICIO. Tamén se poden especificar a nivel do contedor indicándoas fora do campo deploy. Ademáis tamén se poden agregar en moitos outros obxetos de docker (imaxes, redes, volumes ...)
As etiquetas son un campo moi interesante, que nos van a permitir clasificar e organizar, según os nosos propios términos, calquer obxeto de docker. Nelas podemos establecer descripcións dos nosos servicios,  relacións entre contedores, información de cara ao usuario...

### placement

Este apartado nos permite indicar restriccións de en que nodo deben correr os contedores do noso servicio, por exemplo porque queremos que os que teñan estado, que sempre arranquen no mesmo nodo, xa que é onde está o volumen de datos asociado.

### resources

Por último, neste apartado nos permiten especificar os recursos do nodo , que queremos reservar, ou limitar, para os contedores do noso servicio. Se divide en 2 claves correspondentes (**reservations** e **limits**), e típicamente configuraremos limites ou reservas, de cpu e memoria.

Ademáis do campo deploy, tamén tedes que ter en conta, que hai unha serie de opcións válidas no docker-compose, que non están soportadas no modo de swarm:a

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
