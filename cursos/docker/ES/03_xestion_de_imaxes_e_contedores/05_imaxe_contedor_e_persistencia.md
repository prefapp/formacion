# Imagen, contenedor y persistencia

## El problema de la persistencia.

Sabemos que un contenedor es un elemento volátil que puede iniciarse y detenerse en cuestión de segundos. También sabemos que es probable que se ejecute en una máquina junto a cientos o incluso miles de otros contenedores.

En la sección anterior vimos que el contenedor realiza sus operaciones de escritura, **modifica su estado**, en una capa distinta a la imagen que está asociada a ese contenedor en particular.

Surge el problema de que, si el contenedor es volátil, la capa asociada a ese contenedor también es volátil.

> Entonces **NO PODEMOS ALMACENAR DATOS CRÍTICOS EN LA CAPA DEL CONTENEDOR**.

Imaginemos que nuestro contenedor escribe datos clave en un archivo ubicado en el sistema de archivos:

![Container](./../_media/03_xestion_de_imaxes_e_contedores/container_escribe_datos.png)

Ahora sabemos que todos esos cambios realmente se están haciendo en la capa donde el contenedor puede escribir, es decir, **en la capa contenedora**.

Si por alguna razón, el contenedor se cae o desaparece, también lo hace la capa de datos asociada a él.

![Container](./../_media/03_xestion_de_imaxes_e_contedores/container_escribe_datos_desaparece.png)

Esto significa que, si relanzamos un contenedor, tendrá una nueva capa de datos (asociada al contenedor) y, por lo tanto, **no tiene ese archivo de datos, ni sus cambios**.

![Container](./../_media/03_xestion_de_imaxes_e_contedores/container_escritura_datos_error.png)

## Soluciones al problema de la persistencia

El problema de la persistencia se resuelve de dos maneras diferentes:

- **Almacenar en imagen**: hay formas de almacenar datos importantes en la imagen. No se recomienda en el 99% de los casos!!!! La imagen es algo estático que tiene dependencias básicas del sistema, su evolución se basa en la creación de una nueva imagen y expresa configuraciones estructurales del sistema o nuevas versiones de software, el estado de una aplicación no debe almacenarse en la imagen contenedora.

- **Volúmenes de datos**: esta es la forma correcta de garantizar la persistencia. De esta forma, los datos están en una carpeta en la máquina host y el contenedor realiza cambios en el sistema de archivos no volátil, por lo que incluso si el contenedor desaparece, los datos se almacenan en un lugar estable y persistente.
