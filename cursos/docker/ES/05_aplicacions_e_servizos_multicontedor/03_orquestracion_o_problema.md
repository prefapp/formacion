# Orquestación: el problema

## El paradigma de la contenerización

A estas alturas del curso ya estamos entendiendo por qué los contenedores son un cambio de paradigma en el mundo de los sistemas, comparable al de la virtualización de máquinas.

- Gracias a los contenedores podemos aislar un proceso y sus dependencias en una unidad que se puede iniciar/detener en cuestión de segundos.
- El costo de contenerización en términos de CPU/Memoria es totalmente insignificante.
- Podemos expresar cómo construir una imagen en código (Dockerfile), lo que presenta [ventajas](https://en.wikipedia.org/wiki/Infrastructure_as_code) muy importantes .
- La posibilidad de crear infraestructuras basadas en microservicios está abierta a todos.

Como lo vemos, la idea es dividir nuestro sistema en unidades funcionales pequeñas y manejables que se comunican entre sí para hacer un trabajo más grande.

Un símil que se usa a menudo es el de la programación orientada a objetos:

- Así como en [POO](https://es.wikipedia.org/wiki/Programaci%C3%B3n_orientada_a_objetos) tenemos clases e instancias, en contenedorización tenemos imágenes y objetos.
- La idea clave es encapsular la funcionalidad en unidades independientes que se comunican entre sí a través del paso de mensajes.
- La evolución del sistema se realiza mediante la ampliación/creación de nuevas clases y objetos, no mediante la modificación de los existentes.

Por lo tanto, la contentización introduce un nuevo paradigma de diseño de aplicaciones e infraestructuras en el que:

- El sistema está fragmentado en unidades muy pequeñas, siendo el bloque de construcción mínimo **el contenedor**.
- Cada unidad tiene una funcionalidad específica y bien definida ([Separación de intereses](https://es.wikipedia.org/wiki/Separaci%C3%B3n_de_intereses)).
- Logrando esta modularidad, las distintas partes pueden ser vistas como **microservicios** que exponen una interfaz clara para comunicarse y que trabajan en conjunto para asegurar el cumplimiento de los objetivos del sistema como entidad.
- Además, nuestras aplicaciones finalmente son **escalables horizontalmente**, agregando nuevas instancias (contenedores) podemos aumentar la potencia de nuestra aplicación sin tener que recurrir a la jaula del **escalado vertical**.

## El problema del paradigma de la orquestación

Bien, ahora tenemos claro que tenemos que dividir todo en pequeñas unidades que se comuniquen entre sí. Pero cómo hacemos eso?

Comencemos con una aplicación Php simple dentro de un contenedor:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/container_standalonoe.png)

Nuestra aplicación quiere tener **estado**. La solución obvia es agregar una base de datos dentro del contenedor:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/mega_container.png)

Esto, a pesar de lo que sería una solución obvia, es un horror y una ruptura con el paradigma de la contenerización:

- El contenedor no tiene una sola preocupación, tiene dos (administración de bbdd y aplicación Php).
- El cambio en la bbdd o en la aplicación implica cambiar el resto de equipos.
- Introducimos las dependencias del software Mysql con respecto a la Separación de intereses a Php y viceversa.

El problema sería peor si quisiéramos, por ejemplo, agregar soporte para SSL, un servidor web, soporte para métricas y registros... Nuestro contenedor crecería y crecería, por lo que no arreglaríamos ninguno de los problemas que queremos. de resolver o encima perderíamos las ventajas de la contenedorización.

La solución correcta sería esta:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/container_bbdd.png)

Ahora tenemos dos unidades independientes en dos contenedores. Podemos modificar uno sin afectar al otro. Las preocupaciones están debidamente separadas.

En este punto, nuestros contenedores también pueden **escalarse**, solo agregue nuevos contenedores de aplicaciones si es necesario:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/escalado_container.png)

Y, por supuesto, podemos añadir los servicios auxiliares que creemos de forma convenientes, sin necesidad de modificar los contenedores que ya tenemos (**encapsulación**).

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/escalado_funcional.png)

Como vemos, nuestra aplicación **crece añadiendo nuevas unidades funcionales**, **no modificando las existentes**. Esto trae las ventajas de las que ya te hemos hablado en el apartado anterior.

Pero, surgen preguntas:

- ¿Cómo sabe nuestro contenedor Php la dirección y el puerto en el que escucha Mysql?
- ¿Cómo paramos/arrancamos todos los contenedores a la vez?
- Si se cae un contenedor y al recogerlo ha cambiado la IP, ¿cómo lo sabe el resto?
- ¿Cómo inyectamos configuraciones comunes a todos los contenedores?

> Intenta responder a estas y muchas otras preguntas de **orquestación de contenedores**.