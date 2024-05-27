# namespaces en profundidad

## 1 - Tipos de namespaces

Como discutimos en otra sección, los namespaces son un mecanismo para aislar ciertos recursos que permite crear vistas "privadas" del sistema operativo para un proceso o conjunto de procesos.

Cada uno de los namespaces aísla un tipo específico de recurso o familia de recursos:

- _Pids_: identificadores de procesos, grupos de procesos y sesiones. Más información en [1](https://lwn.net/Articles/531114/), [2](https://lwn.net/Articles/531419/) y [3](https://lwn.net/Articles/532748/).
- _Red_: redes, pilas de red, reglas de firewall. Más información [aquí](https://lwn.net/Articles/580893/).
- _Usuarios_: gestión de usuarios y grupos de usuarios. Más información en este [artículo](https://lwn.net/Articles/532593/).
- _UTS_: (Unix Time-sharing System) para nombre de host y nombre de dominio. Se analizan en este [hilo](https://lwn.net/Articles/179345/) y este [artículo](https://lwn.net/Articles/531114/).
- _IPC_: sockets, memoria compartida, semáforos. Este [artículo](https://lwn.net/Articles/531114/) tiene más información.
- _Montar_: montar sistemas de archivos por proceso o grupo de procesos. Hay una discusión en profundidad en este [artículo](https://lwn.net/Articles/689856/).

## 2 - Comandos de gestión del namespace

Existen una serie de comandos que nos permiten interactuar con los namespaces, son:

- **unshare**: acepta un comando para iniciar como parámetro y crea nuevos namespaces para él de acuerdo con las flags que se le pasan.
  - Con esta utilidad, se pueden lanzar procesos en contenedores, es decir, aislados en sus propios namespaces para ellos y sus procesos secundarios.
  - Permite un control fino de los namespaces (UTS, pids, red, usuarios, ipc...)
  - Se puede encontrar más información sobre los comandos en la página del [manual de Linux](https://man7.org/linux/man-pages/man1/unshare.1.html).
- **nsenter**: este es el comando inverso al anterior. Si unshare nos permite aislar un proceso, el comando nsenter nos permite "entrar" o unirnos a un namespace existente.
  - Puede encontrar más información sobre el comando en la página [manual de Linux](http://man7.org/linux/man-pages/man1/nsenter.1.html).

### A - Uso del comando unshare

El comando **unshare** permite modificar el entorno de ejecución de un proceso creando sus propios namespaces para él.

En un ejemplo sencillo:

```bash
unshare -fp /bin/bash
```

Lo que estamos haciendo es:

- Iniciar el comando ```/bin/bash```.
- El indicador ```-fp``` indica que unshare debe crear un nuevo namespace (de pids) para el proceso ``/bin/bash'' y que se debe ejecutar en una nueva bifurcación.
Si ejecutamos esa declaración en nuestra terminal, no notaremos ningún cambio. De hecho, si intentamos hacer un top o un ps no hay diferencia: seguimos viendo los procesos de nuestra máquina.

Sin embargo, el bash que ejecutamos **ya no está en el namespace global de pids**.

![Contenedor](../../_media/01_que_e_un_contedor_de_software/namespaces_1.png)

Para probar esto, salgamos del bash creado:

```bash
exit
```

Y ejecutemos el comando anterior nuevamente, pero pidiéndole al sistema que monte un nuevo proceso de acuerdo con nuestro namespace pids.

```bash
unshare -fp --mount-proc /bin/bash
```

Si ahora hacemos un ```top``` o un ```ps``` veremos sólo dos procesos. Es decir, **el proceso que lanzamos "vive" en su propio namespace pids**. El proceso lanzado ```/bin/bash``` tendrá pid 1. Si abrimos otra terminal y buscamos ```/bin/bash``` en nuestro árbol de procesos, veremos que tiene un pid diferente que no es el pid 1.

Una pregunta muy interesante en este punto es la razón por la que el proceso /bin/bash tiene pid 1. Se puede encontrar una discusión sobre este tema [aquí](https://hackernoon.com/the-curious-case-of-pid-namespaces-1ce86b6bc900).

### B - Inserción de procesos en otros namespaces: el comando nsenter

Como dijimos, el comando **nsenter** permite insertar un proceso en uno o más namespaces existentes.

#### i) Lista de namespaces
Para buscar namespaces, como regla general, simplemente vaya a ```/proc/<process pid>/ns```. Allí veremos los namespaces de un proceso específico.

Se puede hacer referencia a estos namespaces usando su ruta.

#### ii) Uso de nsenter
Como decíamos, basta con especificar el pid del proceso que creó los namespaces para poder acceder a ellos con un nuevo proceso.

Vamos a usar el comando de la sección anterior para iniciar un shell que se ejecuta en su propio namespace pids y con su propio ```/proc```.

```bash
unshare -fp --mount-proc /bin/bash
```

Abrimos otra terminal y buscamos el pid del proceso /bin/bash lanzado por (aparecerá colgado de un proceso unshare)

Ahora ejecutamos el siguiente comando:

```bash
nsenter --target <pid> -p -m
```

Esto implica:

- Lanzar un comando (si no lo especificamos será el intérprete por defecto contenido en ```$SHELL```).
- Buscando los namespaces del proceso con el pid expresado en ```--target```.
- Inserte en su espacio pid (```-p```).
- Participa en tus montas (```-m```).

Si ahora creamos un ```top``` o un `ps` desde el nuevo `shell`, veremos los procesos ejecutándose en el namespace pids creado por unshare.

En un diagrama:

![Contenedor](../../_media/01_que_e_un_contedor_de_software/namespaces_2.png)

**Σ Webografía**
- Abrams, Vish. "El curioso caso de los pid namespaces" [en línea](https://hackernoon.com/the-curious-case-of-pid-namespaces-1ce86b6bc900) [Consultado: 06-ene-2018].