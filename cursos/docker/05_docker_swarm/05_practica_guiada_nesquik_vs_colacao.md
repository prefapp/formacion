# Práctica guiada: Nesquik vs Colacao distribuida

Por último e como remate do curso vamos a despregar no noso cluster swarm, creado no apartado anterior, a aplicación de votación que montamos no tema 5.

Vamos a adaptar o docker-compose.yaml da aplicación anterior, ao formato v3, preparado para o lanzamento nun swarm, cunha serie de melloras á hora de dar un servicio máis confiable.

Para esto imos ir servizo a servizo agregándolle configuración extra.

O primeiro que temos que facer e cambiar a versión da especificación de docker-compose, para usar polo menos a 3. (Actualmente están na 3.6)

![img](../_media/05_docker_swarm/swarm06.png)

Básicamente todas as configuracións relativas ao modo swarm están concentradas, dentro de cada servicio, no apartado de **deploy**, de tal maneira que o único comando que interpreta estas opcións é 
**docker stack deploy**, e tanto docker-compose up como docker-compose run simplemente evitan esta sección.

### Redis

No caso do servicio de redis, só queremos que teña unha única replica, e unha política de reinicio:

*  en caso de fallo do container, o cluster que se encarge de levantalo de novo, que o intente polo menos 3 veces, con 10s entre cada intento, nunha ventá de tempo de 120s

![img](../_media/05_docker_swarm/swarm07.png)

### Postgresql

No caso do servicio de base de datos, como é algo bastante crítico QUE NECESITA PERSISTENCIA, os datos da mesma se teñen que almacenar nun volumen DEPENDENTE DO ANFITRIÓN\* onde corre o contedor. Por eso, non podemos permitir que o scheduler do Swarm nos mova a base de datos a outro nodo diferente de onde se arrincaou a primeira vez.
Para esto vamos a agregar unha restricción de xeito que ese servicio só se execute no nodo **Manager**.

_\*Docker se caracteriza por traer baterías incluidas, pero intercambiables. Esto quere decir que hai partes do Docker Engine que, aínda que veñen cunha funcionalidade xa definida, se permiten intercambiar por outras de outro proveedor para mellorala. Principalmente hai 2 tipos de proveedores de plugins, os que proveen plugins de rede, e os que proveen plugins para a xestión de volumenes. Precisamente estos últimos están moi enfocados en tratar de atopar solucións para poder abstraer o volume de datos, do anfitrión, de xeito que se poida mover os contedores dos servicios entre nodos do cluster e continuen a ter os seus datos dispoñibles. Podedes ver algúns deles [aquí](https://store.docker.com/search?type=plugin)_.

![img](../_media/05_docker_swarm/swarm07.png)

Tamen e necesario engadir as variables para a configuración de usuario e contrasinal de postgres:

```yaml
environment:

 POSTGRES_USER: "postgres"

 POSTGRES_PASSWORD: "postgres"
```

### Votacions

Para o servicio de votacións, como é unha aplicación que non garda estado en si mesma, e está tendo moita demanda ;) vamos a escalalo a 2 replicas, de xeito que o cluster se encargue de balancear as peticións entre cada unha delas.

Ademáis cando faga falta actualizar o servicio, queremos que se execute a actualización das 2 replicas á vez, e por suposto, se se cae que automáticamente se volva a arrincar soa.

![img](../_media/05_docker_swarm/swarm08.png)

Para o nodo worker vamos a agregar 1 única réplica xa que a aplicación que nel correo non soporta máis, e unha política de restart on-failure.

Para o nodo de resultados agregemos outras 2 réplicas, de maneira similar ao de votacions.

Unha vez completado esto, so queda preparar o noso cliente de docker para que fale contra o nodo Manager.

Input
```sh
env vbox01
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.100.2376"
export DOCKER_CERT_PATH="/home/alambike/.docker/machine/machines/vbox01"
export DOCKER_MACHINE_NAME="vbox01"
#Run this command to configure your shell:
#eval $(docker-machine env vbox01)
```
Output
```sh
eval $(docker-machine env vbox01) #sendo vbox01 o noso nodo Manager
```

E finalmente quedaría facer o deploy desta stack

Input
```sh
docker stack deploy --compose-file docker-stack-tema6.yaml nesquik-colacao
```

Para comprobar como o cluster vai lanzando os servicios e tasks correspondentes, podemos executar:

Input
```sh
docker stack ps nesquick-colacao
```

## Actividad

Completar a stack e desplegala no swarm previamente creado.

Comprobar o funcionamento da aplicación, revisando o porto 8000 e 8001 en ambos  nodos.

Conectar o portainer ao nodo Manager e revisar a arquitectura da aplicación de xeito visual.

## Conectar un novo endpoint ao portainer

Para configurar o portainer contra o nodo Manager do cluster Swarm, tedes que acceder ao apartado de Endpoints e rexistrar un novo, especificando os datos de conexión ao mesmo.

Os certificados TLS para a conexión co Manager están dentro da carpeta **.docker** do voso $HOME, na subcarpeta **machines**.

![img](../_media/05_docker_swarm/swarm14.png)
