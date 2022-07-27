# Construindo un entorno clusterizado para o despregue de aplicacións conterizadas

##construir o noso cluster de Docker swarm cumprindo os requisitos.

Para a creación dun primeiro cluster de nodos con Docker Swarm, vamos a usar 3 máquinas virtuais correndo no propio VirtualBox que temos instalado localmente.

Poderíamos realizar esta tarefa clonando a máquina actual **docker-platega**, ou instalando de novo 3 servidores virtuais co seu SO Linux e agregándolle o docker engine como vimos no tema 2, pero Docker nos provee dunha ferramenta moi axeitada para esta labor:

### Docker machine

[Docker Machine](https://docs.docker.com/machine/) é unha ferramenta [opensource](https://github.com/docker/machine) mantida pola empresa Docker Inc e pola comunidade de docker, que permite instalar e xestionar, dende o noso equipo local, nodos Docker (servidores físicos ou virtuais co docker-engine instalado) tanto en máquinas virtuais locais (HyperV, VirtualBox, VMWare Player) como en proveedores remotos (AWS, Azure, DigitalOcean ...). Podedes ver [aquí a lista de drivers que actualmente ten dispoñible](https://docs.docker.com/machine/drivers/) para despregar e xestionar un nodo docker.

Para crear o noso primeiro cluster Swarm, vamos a empregar esta ferramenta, ca que crearemos 2 novas máquinas virtuais correndo no noso VirtualBox. As cais van a formar o noso cluster Swarm. 

Para isto  é necesario realizar os seguintes pasos:

#### 0) Instalar docker-machine

```sh
curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
chmod +x /tmp/docker-machine && \
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
```

Se estamos nun sistema operativo diferente de **linux** (windows, mac), para poder dispoñer de docker-machine é recomendable instalar o paquete de [Docker Toolbox](https://docs.docker.com/toolbox/overview/), xa que aínda que está actualmente marcado como legacy, é o que menos problemática xenera co VirtualBox.
Actualmente o método máis axeitado para Windows 10 e Mac, é instalar docker-machine directamente, sen o toolbox.

```sh
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  mkdir -p "$HOME/bin" &&
  curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
  chmod +x "$HOME/bin/docker-machine.exe"
```

\*\*No caso de windows precisa ter instalado [git-bash](https://gitforwindows.org/) previamente.

De tódolos xeitos tedes [ná páxina da documentación de docker-machine](https://docs.docker.com/machine/install-machine/), máis detalles dos diferentes métodos de instalación dispoñibles.

#### 1) Crear a primeira máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox01
```

Con **-d** se especifica o driver a empregar,  **vbox01** será o nome da vm xenerada.

Este comando descarga unha imaxen de Virtualbox dunha distribución moi lixeira de Linux (boot2docker) co demonio de Docker instalado, e crea a máquina virtual co demonio de Docker arrancado.

#### 2) Crear a segunda máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox02
```

#### 3) Iniciar o swarm nunha delas (por exemplo na vbox1)

```sh
docker-machine ssh vbox01 "docker swarm init --advertise-addr <MANAGER-IP>"
```

A MANAGER-IP  é a ip que ten configurada o nodo na interfaz que se vai  a usar para conectarse  cos demais nodos

#### 4) Unir a outra máquina ao swarm

```sh
docker-machine ssh vbox02 "docker swarm join --token xxxxxxxxxxxxxx <MANAGER-IP>:2377"
```

O token para unir a máquina ao swarm nolo indican no anterior punto 3, ao facer o swarm init.

E listo, con estos 4 pasos xa temos un cluster swarm creado, composto por 2 máquinas host de docker. Agora podemos agregar máis máquinas ao cluster, ou lanzar sobre él unha aplicación.

Con base a esta ferramenta docker machine,  construamos un cluster swarm de 3 nodos, con un deles actuando de nodo Manager e á vez de Worker, e despreguemos sobre este cluster varias stacks de coñecidas aplicacións web open-source :

unha stack de [Ghost](https://hub.docker.com/_/ghost) **con persistencia sobre mysql**
unha stack con [Wordpress](https://hub.docker.com/_/wordpress/), tamén con persistencia nun contedor de mysql, empregando a ferramenta de [portainer](https://formacion.4eixos.com/tema_2_web_addenda_portainer/).

---

**Evidencias de adquición de desempeños**: Pasos 1 ao 4 correctamente realizados segundo estes...

**Indicadores de logro**:

* Entregar un documento* cas capturas de pantalla que mostren:
	- Os pasos seguidos para levar a cabo a creación de 3 nodos Docker e a configuración dun cluster docker swarm entre eles.
		* Debe haber 1 nodo cos roles de manager e worker, e 2 nodos solo workers.
		* ¿Que comando debemos podemos empregar para configurar o noso cliente de docker e que conecte co nodo manager do cluster?
	- O ficheiro de compose e os comandos empregados para lanzar sobre este cluster unha stack de Ghost con persistencia sobre mysql.
	- Conectar o portainer contra este cluster e despregar outra stack, esta vez ca aplicación de Wordpress.

**\*Se o preferides, podedes entregar un screencast da consola, con asciinema.org**

**Autoavaliación**: Revisa e autoavalia o teu traballo aplicando os indicadores de logro.

**Criterios de corrección**:

* Realizar a correcta configuración, de 3 nodos locais nun cluster de docker swarm con docker-machine (**20 puntos**)
	* Se crean correctamente os 3 nodos (**5 puntos**)
	* Se forma o cluster swarm entre eles e cumple cas especificacións (**10 puntos**)
	* Se facilita o comando para conectar o docker cli local contra o nodo master do cluster (**5 puntos**)
* Executar o primeiro stack sobre o cluster ca aplicación de ghost, con persistencia sobre mysql (**10 puntos**)
* Conectar o portainer ao cluster seguindo os pasos indicados na documentación e despregar a stack de wordpress (**10 puntos**)

**Peso na cualificación**:

* Peso desta tarefa no seu tema............................................... 40%

## Nesquik vs Colacao distribuida sobre un cluster swarm como o construido no exercicio anterior

Basándonos no cluster swarm construido no apartado anterior despreguemos sobre él a aplicación de [nesquik vs colacao vista no módulo 4](https://formacion.4eixos.com/tema_4_web/prctica_guiada_nesquik_vs_colacao.html).

 ### Para comezar vamos a adaptar o [docker-compose.yaml da aplicación anterior](https://s3-eu-west-1.amazonaws.com/formacion.4eixos.com/solucions/nesquik_vs_colacao_docker-compose.yml) ao formato v3, preparado para o lanzamento nun swarm, cunha serie de melloras á hora de dar un servicio máis confiable.

Podedes descargar unha copia de exemplo do docker-compose da aplicación de nesquik vs colacao aqui.

Para esto imos ir servizo a servizo agregándolle configuración extra.

O primeiro que temos que facer e cambiar a versión da especificación de docker-compose, para usar polo menos a 3. (A última revisión do formato é a 3.7)

Básicamente todas as configuracións relativas ao modo swarm están concentradas, dentro de cada servicio, no apartado de **deploy**, de tal maneira que o único comando que interpreta estas opcións é  
**docker stack deploy**, e tanto docker-compose up como docker-compose run simplemente evitan esta sección.

	1. Redis

No caso do servicio de redis, só queremos que teña unha única replica, e unha política de reinicio:

* En caso de fallo do container, o cluster de Swarm debe encargarse de levantalo de novo, e que o intente polo menos 3 veces, con 10s entre cada intento, nunha ventá de tempo de 120s

```
2. Postgresql
```

No caso do servicio de base de datos, como é algo bastante crítico QUE NECESITA PERSISTENCIA, os datos da mesma se teñen que almacenar nun volumen DEPENDENTE DO ANFITRIÓN* onde corre o contedor.

Por eso, non podemos permitir que o scheduler do Swarm nos mova a base de datos a outro nodo diferente de onde se arrincaou a primeira vez, e onde van a estar os datos da mesma.

Para esto vamos a agregar unha restricción de xeito que ese servicio só se execute no nodo **Manager**.

_ \*Docker se caracteriza por traer baterías incluidas, pero intercambiables. Esto quere decir que hai partes do Docker Engine que, aínda que veñen cunha funcionalidade xa definida, se permiten intercambiar por outras de outro proveedor para mellorala. Principalmente hai 2 tipos de proveedores de plugins, os que proveen **plugins de rede**, e os que proveen **plugins para a xestión de volumenes**. Precisamente estos últimos están moi enfocados en tratar de atopar solucións para poder abstraer o volume de datos, do anfitrión, de xeito que se poida mover os contedores dos servicios entre nodos do cluster e continuen a ter os seus datos dispoñibles. Podedes ver algúns deles [aquí](https://store.docker.com/search?type=plugin). _

	3. Votacions

Para o servicio de votacións, como é unha aplicación que non garda estado en si mesma, e está tendo moita demanda ;) vamos a escalalo a 2 replicas, de xeito que o cluster se encargue de balancear as peticións entre cada unha delas.

Ademáis cando faga falta actualizar o servicio, queremos que se execute a actualización das 2 replicas á vez, e por suposto, se se cae que automáticamente se volva a arrincar soa.

	4. Worker

Para o nodo worker vamos a agregar 1 única réplica xa que a aplicación que nel corre non soporta máis, e admeáis agregarmoes unha política de restart on-failure.

	5. Resultados:

Para o nodo de resultados agregemos outras 2 réplicas, de maneira similar ao de votacions.

### Unha vez completado esto só queda facer o deploy de esta stack 

	1. Para esto o primeiro sería preparar ó cliente de docker para que fale contra o nodo Manager.

	2. E finalmente quedaría facer o deploy desta stack

	3. ¿Como podemos  comprobar como o cluster vai lanzando os servicios e tasks correspondentes?

### Para rematar, e como tarefa extra, vamos a colocar un  proxy inverso que nos permita servir multiples aplicacións dende o noso cluster swarm, nun porto estandard 80, 443, e ademáis sexa dinámico para ser capaz de saber en cada momento cales son os contedores asociados aos servicios web.

Para lograr esto podemos conectar un proxy inverso diante da nosa aplicación. Empregaremos un dos sistemas de proxy inverso máis recoñecidos na actualidade para o uso nos entornos de contedores: [traefik](https://traefik.io/)

O obxectivo desta última tarefa e poñer a convivir 2 aplicacións (a de Wordpress ou Ghost do exemplo anterior) ca de Nesquik vs Colacao, no mesmo cluster, atendendo as peticións no porto estandard http (80) 

Tede en conta que, para apuntar un dominio local ao cluster e poder validalo dende o navegador, vades a ter que facer uso do [ficheiro hosts](https://es.wikipedia.org/wiki/Archivo_hosts) ao que van chequear previamente as aplicacións do equipo (como o navegador) antes de ir a consultar ó servidor dns.

```sh
# Liña de exemplo do /etc/hosts:

92.168.99.100     vota.local resultados.local
```

[Pasos para modificar o /etc/hosts en windows 10](https://planetared.com/2016/08/editar-archivo-hosts-en-windows-10/).

Os pasos que imos seguir están basados no seguinte [exemplo](https://braybaut.dev/posts/utilizando-traefik-como-dynamic-reverse-proxy-en-docker-swarm-sobre-aws/), que podedes consultar para máis información.

Requisitos: será preciso ter despregado un clúster de swarm cun manager e dous workers.

**1) Primeiro debemos crear unha rede de tipo overlay, que será a que utilice Traefik para comunicarse cos servizos**

```sh
docker network create --driver=overlay [NOME_REDE]

```

**2) Facemos o despregue de Traefik establecendo o seguinte**

    - Publícase o porto 80 para recibir os requests e o 8080 para acceder ó dashboard.
    - Especifícase o nome da rede a usar, que é a que creamos no paso anterior.
    - Fórzase que o servizo corra no nodo manager.
    - Establécese a configuración para que funcione con swarm.

Para o cal usamos a seguinte orde:

```sh
docker service create \
 --name traefik \
 --constraint=node.role==manager \
 --publish 80:80 --publish 8080:8080 \
 --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
 --network [NOME_REDE] \
 traefik:v1.6 \
 --docker \
 --docker.swarmMode \
 --docker.domain=traefik \
 --docker.watch \
 --web
```

Tralo cal xa podemos comprobar que o servizo esté funcionando correndo:

```sh
docker service ls

```

**3) Despregamos as nosas aplicacións**

Para isto, debemos cambiar as redes públicas polas que accedemos ás aplicacións pola rede overlay que vimos de crear.

Ademáis, nos deploys dos servizos que usen ditas redes, debemos engadir, como mínimo, as seguintes labels:

    * traefik.port=[PORTO] → establecemos que porto usar
    * traefik.docker.network=[NOME_REDE] → indicamos o nome da rede de overlay
    * traefik.frontend.rule=Host:[NOME_HOST] → indicamos a traefik con que nome recibirá as peticións para este servizo (ej: wordpress.traefik.local)


---

**Evidencias de adquición de desempeños**: Pasos 1 ao 4 correctamente realizados segundo estes...

**Indicadores de logro**:

* Entregar un documento\* con:
	* O ficheiro compose onde se foron aplicando as diferentes modificacións indicadas.
	* Os comandos necesarios para configurar o cliente de docker para que fale co nodo manager do cluster, leve a cabo o deploy da stack, e como visualizar que ese depregue se está executando correctamente.
	* A configuración necesaria de traefik para servir a aplicación dende o porto 80 (http)

**\*Se o preferides, podedes entregar un screencast da consola, con asciinema.org**
 

**Autoavaliación**: Revisa e autoavalia o teu traballo aplicando os indicadores de logro.

**Criterios de corrección**:

* Adaptacións indicadas no 1.1 ao 1.5 completadas correctamente (25 puntos)
	* Redis
	* Postgresql
	* Votacions
	* Worker
	* Resultados
* Comandos necesarios para o apartado 2 correctamente indicados (10 puntos)
* Configuración axeitada de traefik para servir a aplicación nos portos estandard (15 puntos)

**Peso na cualificación**:

* Peso desta tarefa no seu tema............................................... 50%
