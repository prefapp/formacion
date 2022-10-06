# Creación de un entorno en clúster para el despliegue de aplicaciones en contenedores

## construir nuestro clúster de enjambre de Docker cumpliendo con los requisitos.

Para la creación de un primer clúster de nodos con Docker Swarm utilizaremos 3 máquinas virtuales corriendo en el propio VirtualBox que tenemos instalado localmente.

Podríamos realizar esta tarea clonando la máquina **docker-platega** actual, o instalando de nuevo 3 servidores virtuales con su sistema operativo Linux y añadiéndole el motor docker como vimos en el tema 2, pero Docker nos proporciona una muy herramienta adecuada para este trabajo:

### Máquina acoplable

[Docker Machine](https://docs.docker.com/machine/) es una herramienta [de código abierto](https://github.com/docker/machine) mantenida por Docker Inc y la comunidad docker, que permite instalar y gestionar, desde nuestro equipo local, nodos Docker (servidores físicos o virtuales con docker-engine instalado) tanto en máquinas virtuales locales (HyperV, VirtualBox, VMWare Player) como en proveedores remotos (AWS, Azure, DigitalOcean…). Puede ver [aquí la lista de controladores disponibles actualmente](https://docs.docker.com/machine/drivers/) para implementar y administrar un nodo docker.

Para crear nuestro primer clúster Swarm, usaremos esta herramienta, que creará 2 nuevas máquinas virtuales que se ejecutan en nuestro VirtualBox. Los muelles formarán nuestro grupo Swarm.

Para ello es necesario realizar los siguientes pasos:

#### 0) Instalar docker-machine

```sh
curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
chmod +x /tmp/docker-machine && \
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
```

Si estamos en un sistema operativo diferente a **linux** (windows, mac), para tener docker-machine se recomienda instalar el paquete [Docker Toolbox](https://docs.docker.com/toolbox/overview/), ya que aunque actualmente está marcado como legacy, es el que menos problemas genera con VirtualBox.
Actualmente, el método más adecuado para Windows 10 y Mac es instalar docker-machine directamente, sin la caja de herramientas.

```sh
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  mkdir -p "$HOME/bin" &&
  curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
  chmod +x "$HOME/bin/docker-machine.exe"
```

\*\*En el caso de Windows, es necesario tener instalado [git-bash](https://gitforwindows.org/) previamente.

De todos modos, tiene [en la página de documentación de docker-machine](https://docs.docker.com/machine/install-machine/), más detalles de los diferentes métodos de instalación disponibles.

#### 1) Crear la primera máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox01
```

Con **-d** especifica el controlador a usar, **vbox01** será el nombre de la máquina virtual generada.

Este comando descarga una imagen de Virtualbox desde una distribución de Linux muy liviana (boot2docker) con el demonio Docker instalado y crea la máquina virtual con el demonio Docker iniciado.

#### 2) Crear la segunda máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox02
```

#### 3) Iniciar el enjambre en uno de ellos (por ejemplo en vbox1)

```sh
docker-machine ssh vbox01 "docker swarm init --advertise-addr <MANAGER-IP>"
```

El MANAGER-IP es la ip que el nodo tiene configurada en la interfaz que se usará para conectarse a los otros nodos

#### 4) Unir otra máquina al enjambre

```sh
docker-machine ssh vbox02 "docker swarm join --token xxxxxxxxxxxxxx <MANAGER-IP>:2377"
```

El token para unir la máquina al swarm se indica en el punto 3 anterior, al hacer el swarm init.

Y listo, con estos 4 pasos ya tenemos un swarm cluster creado, compuesto por 2 docker hosts. Ahora podemos agregar más máquinas al clúster o iniciar una aplicación en él.

Con base en esta máquina herramienta docker, construimos un clúster de enjambre de 3 nodos, con uno de ellos actuando como un nodo de administrador y al mismo tiempo como un trabajador, e implementamos varias pilas de conocidas aplicaciones web de código abierto en este grupo:

una pila [Ghost](https://hub.docker.com/_/ghost) **con persistencia en mysql**
una pila con [Wordpress](https://hub.docker.com/_/wordpress/), también con persistencia en un contenedor mysql, usando la herramienta de [portainer](https://formacion.4eixos.com/tema_2_web_addenda_portainer/).

---

**Evidencia de adquisición de desempeño**: Pasos 1 a 4 completados correctamente de acuerdo con estos...

**Indicadores de logros**:

* Envíe un documento* con capturas de pantalla que muestren:
  - Los pasos seguidos para llevar a cabo la creación de 3 nodos Docker y la configuración de un docker swarm cluster entre ellos.
    * Debe haber 1 nodo con los roles de administrador y trabajador, y 2 nodos solo trabajadores.
    * ¿Qué comando debemos usar para configurar nuestro cliente docker y conectarnos al nodo del administrador de clústeres?
- El archivo de redacción y los comandos utilizados para iniciar una pila de Ghost en este clúster con persistencia en mysql.
- Conecte el portainer contra este clúster e implemente otra pila, esta vez como una aplicación de Wordpress.

**\*Si lo prefiere, puede enviar un screencast de la consola, con asciinema.org**

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección**:

* Realizar la configuración correcta, de 3 nodos locales en un docker swarm cluster con docker-machine (**20 puntos**)
  * Si los 3 nodos se crean correctamente (**5 puntos**)
  * Si el enjambre de racimo se forma entre ellos y cumple con las especificaciones (**10 puntos**)
  * El comando para conectar el cli docker local con el nodo maestro del clúster se ha simplificado (**5 puntos**)
* Ejecutar la primera pila en el clúster como aplicación fantasma, con persistencia en mysql (**10 puntos**)
* Conectar el portainer al clúster siguiendo los pasos indicados en la documentación y desplegar el stack de wordpress (**10 puntos**)

**Peso en calificación**:

* Peso de esta tarea en tu asignatura........................................... ...... .... 40%

## Nesquik vs Colacao distribuidos en un clúster de enjambre como el construido en el ejercicio anterior

Partiendo del enjambre de clústeres construido en el apartado anterior, desplegamos sobre él la aplicación de [nesquik vs colacao visto en el módulo 4](https://formacion.4eixos.com/tema_4_web/prctica_guiada_nesquik_vs_colacao.html).

 ### Para empezar adaptaremos el [docker-compose.yaml de la aplicación anterior](https://s3-eu-west-1.amazonaws.com/formacion.4eixos.com/solucions/nesquik_vs_colacao_docker-compose.yml ) al formato v3, listo para su lanzamiento en enjambre, con una serie de mejoras a la hora de brindar un servicio más confiable.

Puede descargar una copia de ejemplo de la aplicación docker-compose de nesquik vs colacao aquí.

Para ello iremos de servicio en servicio añadiendo configuración extra.

Lo primero que debemos hacer es cambiar la versión de la especificación docker-compose, para usar al menos 3. (La última revisión de formato es 3.7)

Básicamente todas las configuraciones relacionadas con el modo swarm se concentran, dentro de cada servicio, en la sección **deploy**, por lo que el único comando que interpreta estas opciones es
**docker stack deployment**, y tanto docker-compose up como docker-compose run simplemente pasan por alto esta sección.

1. redis

En el caso del servicio redis, solo queremos que tenga una sola réplica y una política de reinicio:

* En caso de falla del contenedor, el clúster Swarm debe encargarse de recuperarlo y debe intentarlo al menos 3 veces, con 10 s entre cada intento, en una ventana de tiempo de 120 s.

```
2. PostgreSQL
```

En el caso del servicio de base de datos, al ser algo bastante crítico que NECESITA PERSISTENCIA, sus datos deben almacenarse en un volumen DEPENDIENTE DEL HOST* donde se ejecuta el contenedor.

Por lo tanto, no podemos permitir que el programador Swarm mueva la base de datos a otro nodo diferente de donde se inició la primera vez y donde estarán los datos.

Para esto vamos a agregar una restricción para que este servicio solo se ejecute en el nodo **Manager**.

_ \*Docker se caracteriza por traer "baterías incluidas", pero intercambiables. Esto quiere decir que hay partes del Docker Engine que, aunque vienen con una funcionalidad ya definida, se pueden cambiar por otras de otro proveedor para mejorarlo. Existen principalmente 2 tipos de proveedores de complementos, los que brindan **complementos de red** y los que brindan **complementos de administración de volumen**. Precisamente estos últimos están muy centrados en intentar buscar soluciones para poder abstraer el volumen de datos, del host, de forma que los contenedores de servicios puedan moverse entre nodos del clúster y seguir teniendo sus datos disponibles. Puede ver algunos de ellos [aquí] (https://store.docker.com/search?type=plugin). _

3. Votación

Para el servicio de votaciones, como es una aplicación que no guarda estado en sí misma, y ​​está teniendo mucha demanda ;) la vamos a escalar a 2 réplicas, para que el cluster se encargue de balancear las solicitudes entre cada una de a ellos.

Además, cuando sea necesario actualizar el servicio, queremos que la actualización de las 2 réplicas se ejecute al mismo tiempo y, por supuesto, si falla, se reiniciará automáticamente por sí solo.

4. trabajador

Para el nodo de trabajo vamos a agregar 1 sola réplica ya que la aplicación que se ejecuta en él ya no lo admite, y también agregaremos una política de reinicio en caso de falla.

5. Resultados:

Para el nodo de resultados agregamos otras 2 réplicas, de manera similar a la votación.

### Una vez que esto se completa, todo lo que queda es implementar esta pila

1. Para ello, lo primero sería preparar el cliente docker para hablar con el nodo Manager.

2. Y finalmente quedaría desplegar este stack

3. ¿Cómo podemos verificar cómo el clúster está lanzando los servicios y tareas correspondientes?

### Finalmente, y como tarea extra, vamos a colocar un proxy inverso que nos permitirá servir múltiples aplicaciones desde nuestro enjambre de clúster, en un puerto estándar 80, 443, y además ser dinámico para poder saber a en cualquier momento cuales son los contenedores asociados a los servicios web.

Para conseguirlo podemos conectar un proxy inverso delante de nuestra aplicación. Usaremos uno de los sistemas de proxy inverso más reconocidos en la actualidad para su uso en entornos de contenedores: [traefik](https://traefik.io/)

El objetivo de esta última tarea es hacer que 2 aplicaciones (Wordpress o Ghost del ejemplo anterior) coexistan como Nesquik vs Colacao, en el mismo clúster, sirviendo solicitudes en el puerto http estándar (80)

Ten en cuenta que, para apuntar un dominio local al clúster y poder validarlo desde el navegador, tendrás que utilizar el [fichero hosts](https://es.wikipedia.org/wiki/Archivo_hosts) que Hay que comprobar previamente las aplicaciones informáticas (como el navegador) antes de ir a consultar el servidor DNS.


```sh
# Liña de exemplo do /etc/hosts:

92.168.99.100     vota.local resultados.local
```

[Pasos para modificar /etc/hosts en windows 10](https://planetared.com/2016/08/editar-archivo-hosts-en-windows-10/).

Los pasos que vamos a seguir se basan en el siguiente [ejemplo](https://braybaut.dev/posts/utilizando-traefik-como-dynamic-reverse-proxy-en-docker-swarm-sobre-aws/), que puede consultar para más información.

Requisitos: deberá haber implementado un clúster de enjambre con un administrador y dos trabajadores.

**1) Primero debemos crear una red tipo overlay, que será la que use Traefik para comunicarse con los servicios**

```sh
docker network create --driver=overlay [NOME_REDE]

```

**2) Implementamos Traefik configurando lo siguiente**

- Se publica el puerto 80 para recibir solicitudes y el 8080 para acceder al tablero.
- Especificar el nombre de la red a utilizar, que es la que creamos en el paso anterior.
- El servicio se ve obligado a ejecutarse en el nodo administrador.
- Configurado para trabajar con swarm.

Para lo cual usamos el siguiente orden:

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

Después de lo cual podemos comprobar que el servicio se está ejecutando:

```sh
docker service ls

```

**3) Desplegamos nuestras aplicaciones**

Para ello, debemos cambiar las redes públicas por las que accedemos a las aplicaciones con la red superpuesta que acabamos de crear.

Además, en los despliegues de los servicios que utilizan dichas redes, debemos añadir, como mínimo, las siguientes etiquetas:

    * traefik.port=[PORT] → establecemos que puerto usar
    * traefik.docker.network=[NETWORK_NAME] → indicamos el nombre de la red overlay
    * traefik.frontend.rule=Host:[HOST_NAME] → decirle a traefik con qué nombre recibirá las solicitudes de este servicio (por ejemplo: wordpress.traefik.local)


---

**Evidencia de adquisición de desempeño**: Pasos 1 a 4 completados correctamente de acuerdo con estos...

**Indicadores de logros**:

* Presentar un documento\* con:
  * El archivo de composición donde se han aplicado las diferentes modificaciones indicadas.
  * Los comandos necesarios para configurar el cliente de Docker para hablar con el nodo del administrador de clústeres, implementar la pila y cómo visualizar que la implementación se está ejecutando correctamente.
  * Configuración requerida de Traefik para servir la aplicación desde el puerto 80 (http)

**\*Si lo prefiere, puede enviar un screencast de la consola, con asciinema.org**
 

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección**:

* Adaptaciones indicadas en 1.1 a 1.5 correctamente cumplimentadas (25 puntos)
  * redis
  * PostgreSQL
  * Votación
  * Trabajador
  * Resultados
* Comandos necesarios para el apartado 2 correctamente indicados (10 puntos)
* Configuración adecuada de traefik para servir la aplicación en puertos estándar (15 puntos)

**Peso en calificación**:

* Peso de esta tarea en tu asignatura..................................................... 50%
