# Motor acoplable

> Docker Engine, el core de docker, es el componente fundamental de la plataforma y consta de una serie de elementos:

![Docker](../../_media/02_docker/plataforma_docker.png)

Como podemos ver, hay tres componentes básicos:

- El [**docker-cli**](https://docs.docker.com/engine/reference/commandline/cli/): intérprete de comandos que permite interactuar con todo el ecosistema Docker.
- Una **api REST** que te permite responder a los clientes, tanto el docker-cli como cualquier otra librería o cliente de terceros. La API está bien [documentada](https://docs.docker.com/engine/api/v1.40/).
- El [**dockerd**](https://docs.docker.com/engine/reference/commandline/dockerd/): un demonio que se ejecuta en el host (puede ser nuestra propia máquina) y administra todos los contenedores, volúmenes e imágenes de el anfitrión.

Estos tres componentes (docker-cli, API-REST y dockerd) forman el motor del sistema: **Docker engine**.

Por lo tanto, vamos a instalar docker-engine en una máquina e interactuar con él desde el propio docker-cli de esa máquina. Pero nada nos impide, con la configuración adecuada, poder interactuar desde nuestro docker-cli con los daemons docker de otros hosts.

**El interior del demonio Docker**

> ⚠️ La estructura interna de dockerd ha sufrido varias transformaciones. El último y más profundo a mediados de 2016, donde se [dividió en varios componentes](https://www.docker.com/blog/docker-engine-1-11-runc/) para facilitar su adopción.

El proyecto Docker, en los últimos tres años, ha realizado cambios importantes para facilitar su adopción por parte de grandes empresas y organizaciones:

- La [donación a la fundación CNCF](https://www.docker.com/blog/docker-donates-containerd-to-cncf/) de su motor de bajo nivel (el containerd) encargado de gestionar los contenedores. Ahora constitúye el proyecto autónomo [containerd](https://containerd.io/), que está comenzando a usarse en proyectos distintos a Docker (por ejemplo, Kubernetes).
- Cambio en el modelo de gobierno, [transformando](https://www.docker.com/blog/introducing-the-moby-project/) el proyecto de código abierto [docker](https://github.com/moby/moby), en el proyecto [Moby](https://www.docker.com/blog/introducing-the-moby-project/), independiente de la organización Docker Inc., que permite tener un marco común para construir los diferentes "sabores" del motor docker, tanto para la organización de Docker Inc. como para terceros, socios, desarrolladores... (Por ejemplo, el servicio Azure Containers actualmente se basa en su propia compilación Moby). Desde entonces, la organización está lanzando 2 versiones de docker-engine: **docker Community Edition** y **docker Enterprise Edition**, que comparten el mismo código pero tienen un soporte y un modelo de costos diferentes.
- Estrecha colaboración con el organismo de reciente creación, [OCI](https://opencontainers.org/) (Open Container Initiative) para estandarizar contenedores e imágenes.
- El uso de la biblioteca [runc](https://github.com/opencontainers/runc) como punto final para comunicarse con el sistema operativo del host.

Esto implica que, actualmente, a bajo nivel, el demonio docker utiliza varios proyectos independientes, para poder realizar todas sus tareas.

Estos proyectos constituyentes están disponibles para la comunidad, como software libre, y muchos de ellos incluso ya no pertenecen directamente a la organización Docker Inc, sino que han sido donados a fundaciones y grupos alternativos (CNCF, OCI da Linux Fundation ...), por lo que que garantizan su independencia, y así las grandes empresas y los grandes actores de la nube hoy en día, como Microsoft o Google, les dan confianza para seguir apostando por estas herramientas para la construcción de sus propios servicios, y de esta forma dedicar sus propios recursos para mantener la comunidad.

![Docker](../../_media/02_docker/ejemplo_plataforma_docker.png)

*Imagen cortesía del blog [docker](https://i0.wp.com/blog.docker.com/wp-content/uploads/974cd631-b57e-470e-a944-78530aaa1a23-1.jpg?resize=906%2C470&ssl=1).*

**Enlaces de interés:**
- [Descripción general de Docker](https://docs.docker.com/get-started/overview/)
