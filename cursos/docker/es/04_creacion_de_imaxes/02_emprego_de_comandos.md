# Uso de comandos

En el tema anterior hablamos de cómo un contenedor parte siempre de una **imagen** y tiene asociada una capa de **contenedor**, de modo que, a través del mecanismo de **copia sobre escritura** (COW), el los cambios que hagas en el sistema de archivos se reflejan en esa capa y no en la imagen que, desde el punto de vista del contenedor, es algo **inmutable**.

Sin embargo, las imágenes pueden evolucionar. Para ello, la clave está precisamente en esa capa contenedora.

Comenzamos con un contenedor que realiza cambios en su sistema de archivos.

![Container](./../_media/01_creacion_de_imaxes/crear_container_de_imaxe.png)

Como sabemos, esos cambios se reflejan en la capa de su contenedor.

Si detenemos el contenedor ahora, para que no pueda hacer más cambios:

![Container](./../_media/01_creacion_de_imaxes/crear_container_de_imaxe_detido.png)

Tenga en cuenta que el contenedor está **detenido**, no **destruido**, por lo que el contenedor no se está ejecutando pero está presente en el motor de Docker y, por lo tanto, también en su capa de datos.

Si ahora tomamos esa capa de datos que pertenecen al contenedor y hacemos un **commit**, lo que estamos haciendo es producir una nueva imagen que incorpora los cambios de la capa del contenedor en su propia estructura interna.

![Container](./../_media/01_creacion_de_imaxes/crear_container_de_imaxe_detido_commit.png)

En resumen, **acabamos de evolucionar la imagen**. Y los nuevos contenedores basados ​​en esa nueva imagen verán los cambios que hicimos en el contenedor original.

Este es precisamente el ciclo de evolución de las imágenes en Docker.

![Container](./../_media/01_creacion_de_imaxes/evolucion_da_imaxe.png)