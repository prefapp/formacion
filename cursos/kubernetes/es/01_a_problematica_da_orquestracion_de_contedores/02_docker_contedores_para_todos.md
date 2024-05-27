# Docker: contenedores para todos

> Docker, a pesar de su corta vida como proyecto de software abierto, está revolucionando el sector de las tecnologías de la información.

**De forma similar a la revolución que supone la adopción de contenedores de mercancías, al estandarizar las características de las cajas en las que se transportan y mueven todo tipo de materiales en todo el mundo, lo que permite adaptar y optimizar las infraestructuras en las que se almacenan y mover, Docker estandariza el proceso de transporte de software.**

Desde el punto de vista de un administrador de sistemas, nos permite cambiar la forma en que "transportamos" y desplegamos aplicaciones. En lugar de tener que recoger las especificaciones y dependencias que necesita una aplicación, y realizar la instalación de la misma en cada máquina y sistema operativo en el que vaya a estar alojada, Docker nos permite definir un "contrato", una interfaz estándar, que separa lo que va dentro de ese contenedor (la aplicación y sus dependencias) de lo que va fuera, el entorno donde estará alojado (el pc de otro desarrollador, el servidor físico de la organización, los clústeres de servidores virtuales en la nube…).

Desde el punto de vista del desarrollador de aplicaciones, Docker le brinda el poder de controlar fácilmente el software que su aplicación necesita para ejecutarse. Solo debe preocuparse de brindar un artefacto, una caja negra que opere con total autonomía dentro de un sistema operativo definido, para que el administrador tome esa caja y la pruebe, monitoree y aloje dentro de su infraestructura.

# El origen de Docker

Docker nació bajo el paraguas de una empresa, ya extinta (dotCloud Inc.), que tenía como objetivo facilitar el despliegue de aplicaciones a los desarrolladores, liberándolos de tener que preocuparse por la infraestructura. Fundado en 2010, por el autor original de Docker (Salomon Hykes), actualmente ya no está operativo, pero es el germen de construir una herramienta que estandarizaría y agilizaría el despliegue de aplicaciones y servicios web, permitiendo **separar claramente las responsabilidades* * del equipo de desarrollo, responsabilidad del equipo de operaciones, encargado de hospedar y mantener la disponibilidad de la aplicación.

Inspirándonos en la evolución provocada en la industria del transporte por la adopción de contenedores de mercancías, podemos ver [en el siguiente vídeo](https://www.youtube.com/watch?v=Q5POuMHxW-0&feature=youtu.be) uno de las presentaciones más famosas que hizo el autor original, cuando la tecnología aún no tenía la tracción que tiene hoy.

El máximo exponente de este modelo de plataforma como servicio ([PaaS](https://azure.microsoft.com/es-es/overview/what-is-paas/)) fue en su momento [Heroku](https://www.heroku.com/), del que surgieron una serie de ideas y buenas prácticas, condensadas en un manifiesto de 12 reglas, destinadas a los desarrolladores de aplicaciones, que facilitarían la adopción de este tipo de proveedores.

Docker se basa en gran medida en este manifiesto, siendo una herramienta muy útil para adoptar este conjunto de buenas prácticas en nuestros proyectos de software.

**[La app de los doce factores](https://12factor.net/es/)**

I. [Codebase](https://12factor.net/es/codebase): Utilice un solo código base desde el cual tomar el control de versiones y múltiples implementaciones de este código.

II. [Dependencias](https://12factor.net/es/dependencies): Declarar y aislar dependencias de forma explícita.

III. [Configuración](https://12factor.net/es/config): Guardar configuración en entorno, no en código.

IV. [Backing services](https://12factor.net/es/backing-services): Tratar los servicios que dan soporte a la aplicación ("backing services") como recursos enchufables.

V. [Construir, distribuir, ejecutar](https://12factor.net/es/build-release-run): Separa completamente la fase de construcción de la fase de ejecución.

VI. [Procesos](https://12factor.net/es/processes): Ejecuta aplicaciones como uno o más procesos **sin estado**.

VII. [Asignación de puertos](https://12factor.net/es/port-binding): Exportación de servicios mediante puertos de red.

VIII. [Concurrencia](https://12factor.net/es/concurrency): Escala usando el modelo de proceso, mejor en horizontal que en vertical.

IX. [Desechabilidad](https://12factor.net/es/disposability): Maximice la robustez con inicios rápidos y cierres limpios de su servicio.

X. [Paridad entre desarrollo y producción](https://12factor.net/es/dev-prod-parity): Mantener los entornos (desarrollo, preproducción, producción...) lo más parecido posible.

XI. [Logs](https://12factor.net/es/logs): Trata los logs como un flujo de eventos.

XII. [Administración de procesos](https://12factor.net/es/admin-processes): Ejecuta las tareas de gestión/administración como nuevos procesos de tu servicio, con una única ejecución.

# Características de Docker

A pesar de la competencia que existía entre los diferentes proveedores de PaaS (Heroku, Cloudfoundry, Redhat Openshift, ...), y las herramientas que utilizaban para construir su servicio, algunas de código abierto y otras propietarias, Docker se ha consolidado como el principal motor de contenedores debido al hecho de que:

- Facilita enormemente la gestión de los contenedores.
- Proporciona un sistema simple para crear, mantener y distribuir imágenes de contenedores.
- Proporciona sus propias herramientas de orquestación (Docker Swarm), y se integra con herramientas de terceros como Kubernetes.
- Se esfuerza por mantener una serie de [estándares](https://opencontainers.org/) para contenerización, que acomodan nuevos proyectos.

- Enlaces de interés:
   - [Azure Docs: What is PaaS](https://azure.microsoft.com/es-es/overview/what-is-paas/)
   - [Heroku PaaS](https://www.heroku.com/)
   - [The Twelve factor app](https://12factor.net/es/)

# Docker engine

> Docker Engine, el core de docker, es el componente fundamental de la plataforma y consta de una serie de elementos:

![Docker](../../_media/01/engine.png)

Como podemos ver, hay tres componentes básicos:

- El [docker-cli](https://docs.docker.com/engine/reference/commandline/cli/): intérprete de comandos que permite interactuar con todo el ecosistema Docker.
Una api REST: que te permite responder a los clientes: tanto el docker-cli como cualquier otra librería o cliente de terceros. 
- La API está bien [documentada](https://docs.docker.com/engine/api/v1.40/).
- El [dockerd](https://docs.docker.com/engine/reference/commandline/dockerd/): un demonio que se ejecuta en el host (puede ser nuestra propia máquina) y administra todos los contenedores, volúmenes e imágenes de el anfitrión.

Estos tres componentes (docker-cli, API-REST y dockerd) forman el motor del sistema: docker engine.

Por lo tanto, vamos a instalar docker-engine en una máquina e interactuar con él desde el propio docker-cli de esa máquina. Pero nada nos impide, con la configuración adecuada, poder interactuar desde nuestro docker-cli con los docker daemons de otros hosts.

**El interior del demonio Docker**

> ⚠️ La estructura interna de dockerd ha sufrido varias transformaciones. El último y más profundo a mediados de 2016, donde se [dividió en varios componentes](https://www.docker.com/blog/docker-engine-1-11-runc/) para facilitar su adopción.

El proyecto Docker, en los últimos tres años, ha realizado cambios importantes para facilitar su adopción por parte de grandes empresas y organizaciones:

- La [donación a la fundación CNCF](https://www.docker.com/blog/docker-donates-containerd-to-cncf/) de su motor de bajo nivel ([el containerd](https://en.wikipedia.org/wiki/Cloud_Native_Computing_Foundation#Containerd)) encargado de gestionar los contenedores. [Containerd](https://containerd.io/) ahora constituye un proyexto proyecto autónomo, que se está comenzando a usar en proyectos distintos a Docker (por ejemplo, Kubernetes).
- Cambio en el modelo de gobierno, [transformando](https://www.docker.com/blog/introducing-the-moby-project/) el proyecto de código abierto [docker](https://github.com/moby/moby), en el proyecto [Moby](https://www.docker.com/blog/introducing-the-moby-project/), independiente de la organización Docker Inc., que permite tener un marco común para construir los diferentes " sabores" del motor docker, tanto para la organización de Docker Inc. en cuanto a terceros, socios, desarrolladores... (Por ejemplo, el servicio Azure Containers actualmente se basa en su propia compilación Moby). Desde entonces, la organización ha lanzado 2 versiones de docker-engine, docker Community Edition y docker Enterprise Edition, que comparten el mismo código pero tienen un soporte y un modelo de costos diferentes.
- Estrecha colaboración con el organismo de reciente creación, [OCI](https://opencontainers.org/) (Open Container Initiative) para estandarizar contenedores e imágenes.
- El uso de la biblioteca [runc](https://github.com/opencontainers/runc) como punto final para comunicarse con el sistema operativo del host.

Esto implica que, actualmente, a bajo nivel, el demonio docker utiliza varios proyectos independientes, para poder realizar todas sus tareas.

Estos proyectos constituyentes están disponibles para la comunidad, como software libre, y muchos de ellos incluso ya no pertenecen directamente a la organización Docker Inc, sino que han sido donados a fundaciones y grupos alternativos (CNCF, OCI da Linux Fundation ...), por lo que que garantizan su independencia, y así las grandes empresas, y los grandes actores de la nube hoy en día, como Microsoft o Google, les dan confianza para seguir apostando por estas herramientas para la construcción de sus propios servicios, y de esta forma dedicar sus propios recursos para mantener la comunidad.

![Docker](../../_media/01/engine1.png)

*Imagen cortesía del blog [docker](https://i0.wp.com/blog.docker.com/wp-content/uploads/974cd631-b57e-470e-a944-78530aaa1a23-1.jpg?resize=906%2C470&ssl=1).*

**Enlaces de interés:**
- [Docker overview](https://docs.docker.com/get-started/overview/)

# La imagen

> La imagen es uno de los conceptos fundamentales en el mundo de la contenerización.

Como hemos visto, la contenerización es una técnica de virtualización que permite aislar un proceso dentro de un SO de tal manera que este último "piensa" que tiene toda la máquina para sí mismo, pudiendo ejecutar versiones específicas de software, establecer su stack de red o crear una serie de usuarios sin afectar al resto de procesos del sistema.

Una imagen cubre el conjunto específico de software que utilizará el contenedor una vez que se inicie. Intuitivamente podemos entender que es algo **estático** e **inmutable**, como ocurre por ejemplo con una ISO, que tenemos que tener almacenada en la máquina anfitriona para poder lanzar contenedores basados ​​en esa imagen.

La gestión de imágenes es uno de los puntos fuertes de Docker.

Las imágenes en Docker se componen de **capas**, lo que permite la modularidad y la reutilización.

Para este ejemplo, montaremos una imagen con el servidor web [Apache2](https://httpd.apache.org/).

## 1ª Capa: El sistema base

Ya sabemos que un contenedor está completamente aislado, a excepción del Kernel, del Sistema Operativo anfitrión. Esto implica que, para que el contenedor funcione, se necesita tener una primera capa en la imagen con las utilidades y programas fundamentales para garantizar el funcionamiento del software que queremos ejecutar dentro del contenedor. En otras palabras, necesitamos un Sistema Operativo como base de la imagen del contenedor.

Para este ejemplo, elijamos un [Debian Jessie](https://www.debian.org/releases/jessie/). Por supuesto, podríamos haber elegido cualquier otra distribución de Linux que sea compatible con el kernel que se ejecuta en la máquina host (Ubuntu, Centos, Alpine...)

Nuestra imagen tendría esta estructura:

![Capa](../../_media/01/capa_1.png)

## 2ª Capa: Las dependencias de Apache2

En este ejemplo, la versión de Apache que se montará es [2.2](https://httpd.apache.org/download.cgi#apache22) que, por supuesto, tiene varias [dependencias](https://httpd.apache.org/docs/2.2/install.html#requirements) específicas del software.

Estas dependencias constituirían una segunda capa en nuestra imagen:

![Capa](../../_media/01/capa_2.png)

## 3ª Capa: El servidor Apache

Finalmente, agreguemos la capa con nuestro servidor web.

La imagen, finalmente, quedaría así:

![Capa](../../_media/01/capa_3.png)

¡Y hecho! Ahora podemos usar la imagen para lanzar contenedores con **versiones específicas** de software y una base de **Debian** sin preocuparnos por el resto del software que pueda estar ejecutándose en el host.

![Capas](../../_media/01/capa_total.png)

# Imagen y contenedor

> En esta sección afirmamos que la imagen es algo **estático** e **inmutable**, por lo que las imágenes no se pueden cambiar, excepto a través de los métodos establecidos para el desarrollo y mantenimiento de imágenes por parte de la suite Docker (ver el [Dockefile]( https://docs.docker.com/engine/reference/builder/)).

- ¿Significa esto que un contenedor no puede escribir en el disco?
- Dentro del contenedor, ¿podemos crear, eliminar o modificar archivos?
- Si la imagen es algo inmutable, ¿cómo se puede hacer todo esto?
Por supuesto, Docker permite que los contenedores modifiquen su sistema de archivos, pudiendo eliminar todas las carpetas y su contenido si se desea.

Para poder hacer esto, Docker utiliza un mecanismo conocido como **copy-on-write** (COW).

## El mecanismo COPY-ON-WRITE

El "truco" es conceptualmente sencillo: Docker no ejecuta nuestro contenedor directamente sobre la imagen, sino que, encima de la última capa de la misma, crea una nueva: **la capa contenedora**.

Partimos de un contenedor en ejecución y en base a una imagen:

![Imagen contenedor](../../_media/01/imaxe_e_contedor_1.png)

En realidad, la imagen se compone de capas propias de la imagen y una capa del container. Solo la capa del container es de **ESCRITURA/LECTURA**.

![Imagen contenedor](../../_media/01/imaxe_e_contedor_2.png)

De esta forma, los programas que se ejecutan en el contenedor pueden escribir en el sistema de archivos de forma natural sin darse cuenta de que en realidad están escribiendo en una capa asociada con el contenedor y no en la imagen inmutable.

![Imagen contenedor](../../_media/01/imaxe_e_contedor_3.png)

Esto hace posible que cada contenedor realice cambios en el sistema de archivos sin afectar a otros contenedores que se basan en la misma imagen, ya que **cada contenedor tiene una capa de contenedor específica asociada**.

![Imagen contenedor](../../_media/01/imaxe_e_contedor_4.png)

Como podemos ver, este mecanismo es muy útil. Sin embargo, esto produce un problema: la **volatilidad de los datos**.

El tratamiento de este problema y sus soluciones será objeto de la siguiente sección.

# Uso de comandos

En el tema anterior hablamos de cómo un contenedor parte siempre de una **imagen** y tiene asociada una capa de **contenedor**, de modo que, a través del mecanismo de **copy-on-write** (COW), los cambios que hagas en el sistema de archivos se reflejan en esa capa y no en la imagen que, desde el punto de vista del contenedor, es algo **inmutable**.

Sin embargo, las imágenes pueden evolucionar. Para ello, la clave está precisamente en esa capa contenedora.

Comenzamos con un contenedor que realiza cambios en su sistema de archivos.

![Container](../../_media/01/crear_container_de_imaxe.png)

Como sabemos, esos cambios se reflejan en la capa de su contenedor.

Si detenemos el contenedor ahora, para que no pueda hacer más cambios:

![Container](../../_media/01/crear_container_de_imaxe_detido.png)

Tenga en cuenta que el contenedor está **detenido**, no **destruido**, por lo que el contenedor no se está ejecutando pero está presente en el motor de Docker y, por lo tanto, también en su capa de datos.

Si ahora tomamos esa capa de datos que pertenecen al contenedor y hacemos un **commit**, lo que estamos haciendo es producir una nueva imagen que incorpora los cambios de la capa del contenedor en su propia estructura interna.

![Container](../../_media/01/crear_container_de_imaxe_detido_commit.png)

En resumen, **acabamos de evolucionar la imagen**. Y los nuevos contenedores basados ​​en esa nueva imagen verán los cambios que hicimos en el contenedor original.

Este es precisamente el ciclo de evolución de las imágenes en Docker.

![Container](../../_media/01/evolucion_da_imaxe.png)
