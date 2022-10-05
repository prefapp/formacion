# Actividades: familiarízate y trabaja con Dockerfiles


En esta tarea, vamos a pasar nuestro tiempo trabajando con el sistema Dockerfiles y creando nuestras imágenes de contenedor.

Para poder trabajar con nuestras imágenes, comencemos por construir nuestro propio registro de imágenes. En este sentido, utilizaremos el software [registry](https://hub.docker.com/_/registry/) de Docker. Puede encontrar información de implementación [aquí](https://docs.docker.com/registry/deploying/).

Después de haber creado nuestro propio registro, almacenaremos en él las imágenes que produciremos para el proyecto docker-meiga.

## El proyecto docker-meiga

Tenemos un proyecto llamado [docker-meiga](https://github.com/prefapp/docker-meiga), es un sitio web en html5 con motor PHP.

El proyecto se implementará en un contenedor y se debe compilar el Dockerfile de la imagen.

### Requisitos
- La imagen para la versión 1 (la que tenemos ahora) necesita PHP.
- Podemos usar la imagen oficial de [php](https://hub.docker.com/_/php/) que está en dockerhub (php:7.2).
- Como servidor web lo utilizaremos [PHP internal](http://php.net/manual/es/features.commandline.webserver.php).
- La aplicación necesita dos variables de entorno definidas (CURSO y PROFESOR).

### Procedimiento de construcción

A partir de la imagen de origen:
- Tienes que instalar el software necesario para clonarlo [repo](https://github.com/prefapp/docker-meiga).
- Configurarlo como ruta de trabajo.
- Definir el entorno según sea necesario (profesor con su nombre, nombre de este curso...).
- Inicie el servidor web.

### Pasos a seguir:

1. Consultar y analizar la documentación sobre [imágenes y contenedores](https://prefapp.github.io/formacion/cursos/docker-images/#/./01_creacion_de_images/01_revisando_as_images_o_overlayfs).
1. En un pdf, capturas de pantalla de todo lo que necesitas para:
  1. Cree una imagen del oficial de registro con el siguiente nombre: #registry-name, siendo #name el nombre del estudiante.
  1. Lanzar una instancia del registro con la imagen creada, esta instancia debe cumplir con los siguientes requisitos:
    - El nombre del contenedor será #registry-formation-name, siendo #name el nombre del alumno.
    - El registro debe ejecutarse en el puerto 5050.
    - Requerimos que tenga almacenamiento persistente, en un directorio en la máquina host.
  1. Cree una imagen para docker-meiga:
    - Dockerfile para construir la imagen de witch docker de acuerdo a los requerimientos establecidos.
    - El comando para construir la imagen (la imagen debe llamarse docker-meiga).
    - El comando de subida de imágenes al registro privado de imágenes del punto anterior.
  1. El comando para lanzar un contenedor basado en la imagen docker-meiga:
    - Tienes que correr como un demonio.
    - El puerto de conexión debe ser 8000.
    - El nombre del contenedor será meiga-v1.
    - Proporcione una captura de pantalla del navegador con la aplicación web en ejecución.
1. Mejorar el Dockerfile:
  - En el pdf, proporcione un dockerfile que reduzca el tamaño de la imagen final.
1. Permitir múltiples ramas en el Dockerfile:
  - Contribuya con un nuevo Dockerfile donde se puedan establecer diferentes ramas del repositorio para que coincidan con diferentes versiones de la aplicación. La versión a compilar se pasará como argumento al compilar la imagen. El nombre del argumento será la rama.

### Evaluación

**Evidencia de la adquisición de las prestaciones:** Pasos 2, 3 y 4 realizados correctamente de acuerdo a estos...

**Indicadores de logros:** Debes...
- Entregar un cos pdf
  1. Comandos para configurar el registro privado.
  1. El Dockerfile de creación de imágenes.
  1. Los comandos para ejecutar un contenedor con la imagen.
  1. La mejora Dockerfile.
  1. El Dockerfile con ramas.

**Criterios de corrección:**
- Registro privado (máximo 10 puntos):
  - 2 puntos por haber creado la imagen de registro
  - 4 puntos si el comando de arranque del registro privado es correcto
  - 4 puntos si la configuración de persistencia es correcta
- Imagen y contenedor de docker-meiga (máximo 20 puntos):
  - 6 puntos si el Dockerfile de construcción de la imagen de la bruja es correcto
  - 2 puntos si el comando de construcción de la imagen es correcto
  - 2 puntos si los comandos para subir la imagen al registro privado son correctos.
  - 8 puntos si el comando de arranque del contenedor es correcto.
  - 2 puntos si se adjunta una imagen del navegador con la aplicación funcionando
- Imagen mejorada:
  - 5 puntos si la imagen del Dockerfile reduce el tamaño de la imagen del punto anterior
- Imagen con ramas:
  - 5 puntos si el Dockerfile acepta branch.

**Autoevaluación:** Autoevalúate aplicando indicadores de logro e incluso criterios de corrección.

**Heteroevaluación:** La tutoría evaluará y calificará el trabajo.

**Peso en calificación:**
- Peso de esta tarea en la calificación final .......................................... 40 puntos
- Peso de esta tarea en su tema ........................................... .......... 40%