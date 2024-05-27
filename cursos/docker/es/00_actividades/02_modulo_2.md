# Módulo 2: Docker, contenedores para todos

## Docker básico. Instale docker en nuestro entorno de prueba y opere con los primeros contenedores

> Antes de comenzar a trabajar con el ecosistema Docker, debemos instalar el motor Docker en nuestro entorno de trabajo.

### Tipos de instalación

Actualmente existen dos versiones de Docker, una gratuita para la comunidad (Community Edition) y otra de pago, con soporte extendido, para empresas (Enterprise Edition).

Dentro de la versión comunitaria, que sería la que usaremos en este curso, tenemos varias opciones:

- A: Instalando Docker en nuestro portátil.
- B: Crear una máquina virtual (servidor linux) e instalar Docker en su interior.

#### A - Instalación de Docker en nuestro portátil
La plataforma Docker permite su instalación en los principales sistemas operativos:

- [Windows](https://docs.docker.com/docker-for-windows/install/).
- [Mac](https://docs.docker.com/docker-for-mac/install/).
- Linux (consulte la sección B a continuación).

#### B - Instalación de Docker en un servidor Linux

Dependiendo de la distribución que elijamos, tenemos diferentes [posibilidades](https://docs.docker.com/engine/installation/#server). Si estás usando la imagen recomendada en el módulo 0, preparación del entorno (Ubuntu 18.04) tienes las instrucciones [aquí](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

**Pasos**:

1. **Instalar** docker en nuestro entorno de trabajo siguiendo una de las rutas anteriores (A o B).

2. Una vez que Docker esté instalado, construiremos nuestro primer contenedor. Para esto tenemos que crear un proceso que, usando el comando de shell [```echo```](http://www.linfo.org/echo.html), muestre un mensaje en la pantalla diciendo: Hello World !

Obviamente, queremos hacerlo dentro de un contenedor y montar **una distribución de CentOS**.

Como vimos en la práctica del módulo 1 (construyendo nuestro contenedor) podríamos seguir estos pasos para que funcione:

- Descarga un sistema de archivos CentOS.
- Montar un contenedor con unshare, limitando los [namespaces](../01_que_e_un_contedor_de_software/08_namespaces_en_profundidade), hacer un chroot a donde está el sistema de archivos descargado. . .
- ...

Pero ahora podemos usar Docker para hacerlo. Con Docker, básicamente tenemos que seguir la misma receta, pero afortunadamente, todo eso está automatizado dentro de sus [utilidades](https://docs.docker.com/engine/reference/commandline/run/).

1. A continuación, veamos cómo **alojar un servidor dentro de un contenedor**, y también **que tenga persistencia**, de modo que si borramos y volvemos a crear el contenedor, los datos almacenados en él no se perderán.

Para esto configure un contenedor que:

- 3.1: contiene un **servidor mysql**, utilizando la imagen oficial de [mysql](https://hub.docker.com/_/mysql), **en su versión 5.7**.
- 3.2: iniciar **en segundo plano** y seguir ejecutando el servicio una vez desconectado del terminal.
- 3.3: que tiene **persistencia de datos**, dentro de la ruta de almacenamiento mysql (```/var/lib/mysql```).
- 3.4: también **siguiendo las instrucciones indicadas** en el [repositorio de imágenes](https://hub.docker.com/_/mysql):
   - establezca la contraseña de root en una cadena de 10 caracteres.
   - crear una base de datos con el nombre "platega-docker".
   - crear un usuario para esa base de datos con el nombre del alumno y una contraseña de 10 caracteres.

4. Además de tener persistencia, también queremos que tenga conectividad con el exterior, para que puedas acceder a ese contenedor desde fuera de la máquina virtual. Para ello relanzamos el servidor mysql del apartado anterior pero exponiendo el **puerto 3306**, en la interfaz pública del entorno de trabajo (máquina virtual virtualbox si aplica).

- 4.1: Detenga el contenedor y cree uno nuevo que funcione con los mismos datos.
- 4.2: Muestra los pasos necesarios para dotar al contenedor de conectividad con el exterior.
- 4.3: Verifique que pueda iniciar sesión en el mysql del contenedor con root y con el usuario normal **desde el host**, por ejemplo usando el [Mysql Workbench](https://dev.mysql.com/downloads/ workbench/ ), o mysql cli.
- 4.4: Mostrar cómo se haría una copia de seguridad (herramienta mysqldump), **introduciendo el proceso** en el mismo contenedor que el servidor mysql, pero redirigiendo la salida a un archivo en el host.

---

**Evidencia de adquisición de desempeño**: Pasos 1 a 4 completados correctamente de acuerdo con estos...

**Indicadores de logros**:

- Envíe un documento con capturas de pantalla que muestren:
 - 1. Los pasos seguidos para llevar a cabo la instalación del docker elegido en el entorno de trabajo.
 - 2. El comando docker se ejecuta para obtener el resultado "¡Hola mundo!".
 - 3. Los comandos elegidos para crear un servidor mysql 5.7 dentro de un docker con una base de datos que cumpla con todos los requisitos indicados.
 - 4. Los comandos necesarios para crear un nuevo contenedor mysql, dar conectividad al exterior al servicio mysql, y hacer una copia de seguridad de la base de datos con ```mysqldump''. [En este enlace](https://support.hostway.com/hc/en-us/articles/360000220190-How-to-backup-and-restore-MySQL-databases-on-Linux) tenemos una guía sobre cómo para usar mysqldump

\**Nota: si lo prefiere, puede enviar un screencast de la consola con [asciinema.org](https://asciinema.org/).

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección**:

- Realizar la correcta instalación del motor docker en el ambiente de trabajo (**4 puntos**).
- Ejecute el primer contenedor de "Hello World!" (**4 puntos**).
- Lanzar el contenedor mysql con las características indicadas (**16 puntos**).
 - La proporción de **4 puntos** para cada apartado indicado correctamente.
- Agregar conectividad externa al servicio mysql y realizar las comprobaciones (**16 puntos**).
 - La proporción de **4 puntos** para cada apartado indicado correctamente.

## docker avanzado. Configure un servicio web utilizando varios contenedores de Docker.

> Para realizar este ejercicio es necesario disponer de un servidor mysql con las características indicadas en el ejercicio anterior (2.2).

1. Ahora vamos a conectar una **aplicación** [phpmyadmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) **al servidor de base de datos del ejercicio anterior**, para poder operar gráficamente la base de datos creada. **También debe estar expuesto en un puerto público (8000) para poder acceder desde fuera de la máquina virtual**.

2. Usando el nuevo contenedor **phpmyadmin**, **conectado al servidor mysql, cree algunas tablas dentro de la base de datos, con los siguientes campos**:

```sql
Estudiantes ( id INT PRIMARY KEY, nombre VARCHAR(20), apellido VARCHAR(60), centro VARCHAR(120) )
```

```sql
Cursos (id INT PRIMARY KEY, nombre VARCHAR(120), código VARCHAR(20), start_date DATE )
```

**También debe agregar varios registros a ambas tablas**.

3. Desarrollar **una aplicación php** que muestre en una tabla html los datos almacenados en tablas mysql de Estudiantes y Cursos (o un error si no hay conectividad), teniendo en cuenta que:

- La aplicación debe recibir los datos de conexión a la base de datos del entorno.
- Utilizará la imagen php:7.2-apache del repositorio php oficial de Dockerhub. Se recomienda consultar la [documentación oficial de imágenes de php](https://hub.docker.com/_/php), ya que tienen múltiples versiones con diferentes servicios. En el caso de apache, podemos obtener la versión oficial de la imagen con el siguiente nombre php:<version>-apache. En nuestro caso usaremos php:7.2-apache.
- Montará un volumen con el código de tu aplicación en ```/var/www/html```.
- Exportará el puerto 80 del contenedor al puerto 8080 de las interfaces de la máquina virtual.

**Nota**: puede usar como ejemplo este código de [StackOverflow](https://stackoverflow.com/questions/17902483/show-values-from-a-mysql-database-table-inside-a-html-table-on-a-webpage).

**Nota**: la imagen php (php:7.2-apache) desde la que se inicia el contenedor no tiene instaladas las bibliotecas mysql.
Y debe agregarlos antes de poder usar las funciones mysqli_* en su aplicación.

Para agregarlos, debe ejecutar el siguiente comando **desde dentro del contenedor** que ejecutará la aplicación y reiniciarla:

```bash
docker-php-ext-instalar mysqli && docker-php-ext-habilitar mysqli
```

Podríamos hacer todo esto junto con el siguiente comando:

```bash
docker exec <nome_container_php> bash -c 'docker-php-ext-install mysqli && docker-php-ext-enable mysqli' && \
docker restart <nome_container_php>
```

3.2: ¿Cómo podríamos comprobar el funcionamiento del código con la versión 5.6 de php? ¿Qué pasa con la última versión 7.3? ¿Podemos tener las 3 versiones de la aplicación ejecutándose a la vez, cada una en su propio puerto (8080,8081,8082)?
¿Cómo limitaríamos el consumo de recursos en el host (50 MB de memoria, 50 % de una CPU) para los 3 contenedores con diferentes versiones de la aplicación?

4. Ahora vamos a **probar la aplicación** de [portainer](../02_docker/10_portainer) y ver los contenedores corriendo en la máquina virtual, gráficamente desde un navegador.

4.1 Para ello, siga los pasos indicados en los [contenidos](../02_docker/10_portainer) del curso.

4.2 Cerrar todos los contenedores de [portainer](../02_docker/10_portainer). Antes de esto, descargue una copia sql de la base de datos, desde phpmyadmin.

**Evidencia de adquisición de desempeño**: Pasos 1 a 4 completados correctamente de acuerdo con estos...

**Indicadores de logros**:

- Entregar un sql con el contenido de la base de datos mysql solicitada.
- Entregar uno o más archivos php, con el código operativo de la aplicación solicitada.

Si te resulta más fácil, puedes enviarnos el repositorio de códigos github/bitbucket con el código de la aplicación y la base de datos sql.

- Entregar un documento con los comandos docker ejecutados para:
 - Inicie el contenedor phpmyadmin, vinculado al contenedor mysql.
 - Inicie la aplicación php desarrollada, conectada al contenedor mysql del ejercicio anterior.
 - Liberar nuevas versiones de la aplicación de desarrollo php, cas versión 5.6 y 7.3 de php.
   * Limitado a consumir 50 MB de RAM y 50 % de 1 CPU
 - Inicie el contenedor [portainer](../02_docker/10_portainer) y enumere todos los contenedores que se ejecutan en la máquina docker

Si te resulta más fácil, puedes enviarnos el [asciinema](https://asciinema.org/) json con estos comandos.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección**:

- Aplicación operativa que cumple los requisitos exigidos (**20 puntos**):
 - **5 puntos** si la base de datos está correctamente generada.
 - **10 puntos** si la aplicación php entregada recopila conectividad del entorno y se conecta a la base de datos y muestra los valores de la tabla.
 - **5 puntos**s si el comando docker de inicio de la aplicación php cumple con los requisitos.
- Los comandos docker para la ejecución de las diferentes tareas están correctamente especificados (**20 puntos**).
 - **5 puntos**, si el comando docker para iniciar phpmyadmin, vinculado al contenedor mysql, es correcto.
 - **5 puntos** si los comandos para iniciar la aplicación de desarrollo de php son correctos, con las versiones de php 5.6 y 7.3 ejecutándose simultáneamente y accesibles.
 - **5 puntos** si los comandos son correctos para limitar la memoria consumida y la cpu de cada contenedor en diferentes versiones de la aplicación.
 - **5 puntos** si el comando usado para lanzar portainer es correcto, con persistencia y acceso a la api de docker.