# Imagen y contenedor

> En esta sección afirmamos que la imagen es algo **estático** e **inmutable**, por lo que las imágenes no se pueden cambiar, excepto a través de los métodos establecidos para el desarrollo y mantenimiento de imágenes por parte de la suite Docker.

- ¿Significa esto que un contenedor no puede escribir en el disco?
- Dentro del contenedor, ¿podemos crear, eliminar o modificar archivos?
- Si la imagen es algo inmutable, ¿cómo se puede hacer todo esto?
Por supuesto, Docker permite que los contenedores modifiquen su sistema de archivos, pudiendo eliminar todas las carpetas y su contenido si se desea.

Para poder hacer esto, Docker utiliza un mecanismo conocido como **copy-on-write** (COW).

## El mecanismo COPY-ON-WRITE

El "truco" es conceptualmente sencillo: Docker no ejecuta nuestro contenedor directamente sobre la imagen, sino que, encima de la última capa de la misma, crea una nueva: **la capa contenedora**.

Partimos de un contenedor en ejecución y en base a una imagen:

![Container imaxe](../../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_1.png)

En realidad, la imagen se compone de capas propias de la imagen y una capa contenedora. Solo la capa contenedora es **ESCRITURA/LECTURA**.

![Container imaxe](../../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_2.png)

De esta forma, los programas que se ejecutan en el contenedor pueden escribir en el sistema de archivos de forma natural sin darse cuenta de que en realidad están escribiendo en una capa asociada con el contenedor y no en la imagen inmutable.

![Container imaxe](../../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_3.png)

Esto hace posible que cada contenedor realice cambios en el sistema de archivos sin afectar a otros contenedores que se basan en la misma imagen, ya que **cada contenedor tiene una capa de contenedor específica asociada**.

![Container imaxe](../../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_4.png)

Como podemos ver, este mecanismo es muy útil. Sin embargo, esto produce un problema: la **volatilidad de los datos**.

El tratamiento de este problema y sus soluciones será objeto de la siguiente sección.
