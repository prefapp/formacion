# Módulo 5: Aplicaciones y servicios multicontenedor

## Diseñe e implemente una solución con docker-compose para docker-meiga

> Antes de realizar la tarea, lea atentamente las **instrucciones**, los **indicadores de logro** y los **criterios de corrección** que siguen.

Mejoremos nuestra aplicación docker-meiga (la del tema 3) agregando state.

La versión 2 de nuestra meiga tiene varias características nuevas en comparación con la v1:

- Conectarse a una bbdd para tener estado.
- La aplicación ahora cuenta el número de visitas.
- También controla el tamaño de la luna que puede encogerse o crecer.

### Nueva infraestructura

En la nueva infraestructura de nuestra aplicación tendremos que construir:

A) servicio bbdd

Usted tendrá:

- Imagen de [mysql oficial](https://hub.docker.com/_/mysql/) (la de dockerhub) versión 5.7.
- Esa imagen está controlada por variables de entorno:
  - MYSQL_ROOT_PASSWORD: determina la contraseña de root de Mysql.
  - MYSQL_DATABASE: crea esta bbdd si no existe al iniciar el contenedor.
- El servicio debe comenzar con una base de datos definida, llamada bruja.

B) Servicio de Solicitud

La aplicación docker-meiga es la versión [v2](https://github.com/prefapp/docker-meiga.git).

Sus caracteristicas:

- La imagen a utilizar será la de [v2](https://hub.docker.com/r/prefapp/docker-meiga/) (en dockerhub) prefapp/docker-meiga:v2
- Tiene todas las variables de entorno de v1 (ver tarea 3.4 del módulo anterior)
- También presenta nuevas variables:
  - MYSQL_HOST: el host donde se realiza la conexión.
  - MYSQL_USER: el usuario bbdd.
  - MYSQL_PASSWORD: la contraseña de acceso.
  - MYSQL_DATABASE: el nombre de la base de datos de trabajo.
- La aplicación, al iniciarse, creará las tablas que necesita, si no existen, de forma idempotente.

### El docker-compose

En docker-compose estos dos servicios tendrán que existir. Además, defina las variables de entorno que controlan bbdd y también configure esas credenciales de acceso en el servicio de la aplicación (el de php).

Existirán dos redes, una privada (**witch-network**) en la que se conectará el contenedor bbdd y la aplicación, y una pública (**publica-network**) donde solo se conectará el contenedor php .

Compre un volumen (**witch-data**) para dar persistencia a los datos mysql.

Pasos:

1. **Planifique y cree** un archivo docker-compose.yaml que cumpla con las especificaciones a las que se hace referencia.
   - En un pdf entregue el docker-compose.yaml creado o adjunte el archivo docker-compose.yaml a la tarea.
2. **Inicie** una instancia de docker-meiga v2.
   - En el pdf mostramos los comandos necesarios para iniciar la instancia o el asciinema de la misma.
   - En el pdf o adjuntar a la tarea una captura de pantalla del navegador con la web funcionando.
     - La luna debe estar llena (pista: clics sucesivos sobre la luna la hacen avanzar en su ciclo)
     - Se debe ver el nombre del profesor (es controlado por una variable de entorno)
3. **Mostrar** en una sección del pdf o en asciinema los comandos necesarios para:
   - Reiniciar todos los servicios sin pérdida de datos.
   - Poder ver los registros.
   - Reinicie solo el servicio de la aplicación y no el servicio bbdd.
   - Destruir completamente la aplicación, sus contenedores y volumen de datos.
4. **Revisar** la creación de imágenes, en una sección del pdf o en un archivo aparte, enviar el Dockerfile necesario para:
   - Crear la imagen de docker-meiga v2
     - de la imagen php.
     - instale git y clone el proyecto [docker-meiga](https://github.com/prefapp/docker-meiga.git) en la rama v2
     - compre la instalación del módulo mysqli (sugerencia: vea los [comandos auxiliares] (https://hub.docker.com/_/php/) provistos por la imagen para las extensiones).
5. **Modifique** el docker-compose original para permitir [compilar](https://docs.docker.com/compose/compose-file/#build) la imagen a partir de él. Adjuntar mejora en archivo o en una nueva sección del pdf.

**Evidencia de adquisición de desempeño**: pasos 1 a 5.

**Indicadores de logro**: Debe tener:

- PDF o zip con:
  - aplicación docker-compose docker-meiga v2 según las especificaciones proporcionadas.
  - capturas o asciinema de los comandos necesarios para:
    - lanzar una nueva instancia.
  - captura del navegador con la web funcionando:
    - la luna debe estar llena.
    - Debe verse el nombre del profesor.
 - capturas o asciinema de los comandos necesarios para:
   - reiniciar todos los servicios sin pérdida de datos.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección**:

1. Paso 1
- Redacción Docker correcta según especificaciones (máx. 10 puntos)
2. Paso 2
- Comandos para lanzar la instancia según especificaciones (máx. 5 puntos)
- Captura de la web funcionando (máx. 5 puntos)
3. Paso 3
- Comandos de control de instancias (2,5 puntos cada uno hasta un máximo de 10 puntos)
4. Paso 4
- Corrija la compilación Witch v2 Dockerfile (máx. 15 puntos)
5. Paso 5
- Construir dentro del dockerfile (máx. 5 puntos)

**Peso en calificación**:

Peso de esta tarea en tu tema.................................... 50%










## Use la herramienta docker-compose para la orquestación de contenedores

> Antes de realizar la tarea, lea atentamente las **instrucciones**, los **indicadores de logro** y los **criterios de corrección** que siguen.

### Sitio web del "gatito del día"

Para esta tarea necesito haber construido la imagen de "[gatinhos do día](https://prefapp.github.io/formacion/cursos/docker-images/#/./01_creacion_de_images/05_o_dockerfile_construindo_a_imaxe_do_gatinho_do_dia)". Tarea del módulo 3.

Pasos:

1. **Instala** docker-compose en tu máquina siguiendo estas [instrucciones](https://docs.docker.com/compose/install/#install-compose):
 - En un pdf muestra la captura del comando "docker-compose version".
2. **Experimenta** con docker-compose. En el pdf mostrar capturas de los comandos para que:
 - Iniciar web-gatos en primer plano y demonizado.
 - Los comandos para parar y reiniciar la web **sin borrar los contenedores**.
 - ¿Cómo eliminaría los contenedores creados una vez que se inicie compose?
3. **Investigue** las opciones de creación de imágenes de composición.
 - ¿Se podría solicitar la compilación de la imagen desde docker-compose? Si corresponde, adjunte un docker-compose en el que construir la imagen.
 - ¿Cómo eliminar imágenes creadas localmente desde componer?

**Evidencia de adquisición de desempeño**: Paso 1 a 3.

**Indicadores de logros**: debe tener.

- Docker-compose instalado.
- PDF adjunto con:
  - Captura de versión de docker-compose.
  - Sección con:
    - Comandos para iniciar la web en primer plano y demonizados.
    - Detener la web sin borrar los contenedores y reiniciarla.
    - Detener la web y eliminar los contenedores asociados.
  - Sección con comandos y composición para:
    - Hacer una construcción de la imagen.
    - Comando para eliminar imágenes locales.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección**:

- Paso 1
  - Haber instalado docker-compose correctamente (**máx. 10 puntos**).
- Paso 2
  - Sección en el pdf con las capturas de los comandos para (**máx. 15 puntos**).
    - Iniciar la composición en primer plano y demonizado (5 puntos).
    - Detener la redacción sin eliminar contenedores y reiniciarla (5 puntos).
    - Detener la redacción y eliminar los contenedores (5 puntos).
- Paso 3
  - Apartado en el pdf con las capturas de los comandos y la composición necesaria para (**max 15 puntos**).
    - Construir la imagen de "el gatito del día a partir de la composición" (10 puntos).
    - Eliminar las imágenes locales creadas por componer (5 puntos).

**Peso en calificación**:
- Peso de esta tarea en tu asignatura .............................40%

