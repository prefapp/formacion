# Módulo 3: Gestión de Imágenes y Contenedores

## Explore y comprenda los fundamentos de las imágenes de contenedores

> Una imagen es un modelo para crear contenedores. Contiene todo el software base, las bibliotecas y las utilidades que los procesos alojados en el contenedor requieren para funcionar.

\**Nota - Antes de realizar la tarea, lea atentamente las **instrucciones**, los **indicadores de logro** y los **criterios de corrección** que se detallan a continuación.

1. **Consulta** y **analiza** la documentación sobre [imágenes y contenedores](../03_xestion_de_images_e_contedores/01_objectivos).
2. **Cree** una cuenta en [Dockerhub](https://hub.docker.com/). Aunque no es necesario estar registrado en Dockerhub para poder descargar imágenes, sí que necesitaremos tener una cuenta para poder subir nuestras imágenes.

Crea una cuenta en dockerhub. Es gratis y lo vamos a utilizar para subir nuestro trabajo y distribuirlo.

  1. Una vez creada la cuenta, ingresa a la página de dockerhub.
  2. Ve a la pestaña de perfil y haz una captura de pantalla.
Envía la captura a los coordinadores a través de un mensaje privado.

**Evidencia de la adquisición de las prestaciones**: Paso 2 y 3 realizados correctamente de acuerdo a estos...

**Indicadores de logros**: Debes...

1. Haber completado el cuestionario del paso 2.
2. Haber creado una cuenta en dockerhub y enviado la captura a los coordinadores.
Criterios de corrección:

- **4 puntos** si ha contestado el cuestionario.
- **6 puntos** si has creado el perfil en Dockerhub y enviado la captura a los coordinadores.

**Autoevaluación**: Autoevalúate aplicando indicadores de logro e incluso criterios de corrección.

**Heteroevaluación**: El tutorial evaluará y calificará la tarea.

**Peso en calificación**:

- Peso de esta tarea en la calificación final .......................... 4 puntos
- Peso de esta tarea en su tema .......................................... 16%

## Trabajar con comandos de gestión de imágenes.

> Como indicamos, las imágenes de Docker deben instalarse **localmente** para poder usarse en contenedores que se ejecutan en la máquina.

Docker proporciona un conjunto de comandos que nos permiten gestionar las imágenes, tanto localmente como a nivel de su relación con los repositorios de imágenes.

Para llevar a cabo esta tarea, crea un documento donde registraremos los comandos y capturas que se deben enviar. A continuación, se exportará un pdf para adjuntarlo.

Pasos:

1. **Consulta** y **analiza** la documentación sobre [imágenes y contenedores](../03_xestion_de_images_e_contedores/01_objectivos).
2. **Investigue** y **compile** las opciones del comando de docker
   1. El comando muestra ayuda (docker images --help) o se puede consultar en la [documentación oficial](https://docs.docker.com/engine/reference/commandline/images/).
   2. En el pdf, crea una sección "1" donde se expondrán las opciones del comando docker images y un resumen sobre su funcionamiento.
3. **Investiga** sobre digest de imagen.
   1. En el pdf crea una sección "2" donde responderás las siguientes preguntas:
      1. ¿Qué es un compendio de imágenes?
      2. ¿Cuál es tu relación con las etiquetas de imagen?
      3. ¿Por qué son importantes para los despliegues en entornos de "producción"?
   2. La información se puede encontrar en este [artículo](https://engineering.remind.com/docker-image-digests/), en la documentación [oficial de docker](https://docs.docker.com/engine/reference/commandline/images/#list-the-full-length-image-ids) y en este [blog](https://windsock.io/explaining-docker-image-ids/).
4. **Trabaje** con comandos acoplables para imágenes:
   1. En el pdf, crear una sección "3" donde se realizarán capturas de los comandos necesarios para:
      1. Descargue la imagen biblioteca/hola mundo de DockerHub.
      2. Comprobar que realmente está almacenado en la máquina.
      3. Inicie un contenedor que monte esta imagen y compruebe que realmente imprime el mensaje de bienvenida en la pantalla.
      4. Elimine la imagen de biblioteca/hola mundo de la máquina local.

Cuando termines la tarea:

1. Haga clic en el botón "Agregar entrega" a continuación y adjunte el pdf.
2. Una vez revisado por el tutor, puede ver los comentarios al volver a ingresar la tarea o el libro de calificaciones.

---

**Evidencia de la adquisición de las prestaciones**: Paso 2, 3 y 4 realizados correctamente de acuerdo con estos...

**Indicadores de logro**: Su pdf debe haber completado...

1. Sección "1" donde se puede ver:
   - Resumen de las opciones de imágenes de la ventana acoplable.
2. Sección "2" donde se puede ver:
   - Su respuesta a las preguntas formuladas sobre los resúmenes de imágenes.
3. Apartado “3” que deberá incluir:
   - Con los comandos correctamente configurados para realizar las acciones descritas en el punto 4.

**Criterios de corrección**:

- **8 puntos** si ha resumido las opciones del comando de docker en la sección "1" del pdf.
- **4 puntos** por cada pregunta correctamente contestada, hasta un máximo de **12 puntos**, en el apartado "2" del pdf.
- **5 puntos** por cada respuesta correcta, hasta un máximo de **20 puntos**, en el apartado "3" del pdf.

**Autoevaluación**: Autoevalúate aplicando indicadores de logro e incluso criterios de corrección.

**Heteroevaluación**: El tutorial evaluará y calificará la tarea.

**Peso en calificación**:

- Peso de esta tarea en la calificación final ......................... 4 puntos
- Peso de esta tarea en su tema .......................................... 16 %