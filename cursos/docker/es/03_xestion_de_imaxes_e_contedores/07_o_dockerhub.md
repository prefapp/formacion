# Dockerhub

## ¿Que es?

> Dockerhub es un repositorio público gratuito de imágenes de Docker.

Tanto los desarrolladores de software oficiales como las empresas y los aficionados ofrecen su **software** configurado con **todas las dependencias necesarias** empaquetado en imágenes que cualquiera puede usar de forma totalmente gratuita. Basta con elegir una imagen y descargarla para poder utilizar el software de nuestra elección sin necesidad de instalar nada, sin configuraciones y, sobre todo, sin preocuparnos por las dependencias.

## ¿Cómo buscamos imágenes?

> Simplemente vaya al portal dockerhub e ingrese el nombre del software de nuestra elección en el cuadro de búsqueda:

![DockerHub search](../../_media/03_xestion_de_imaxes_e_contedores/dockerhub_search.png)

Si intentamos ingresar la palabra "**nginx**", veremos una serie de resultados:

![DockerHub find](../../_media/03_xestion_de_imaxes_e_contedores/dockerhub_find.png)

Como vemos, Dockerhub categoriza las imágenes exponiendo una serie de datos sobre ellas:

- Nombre
- Autor
- Puntuación
- Número de descargas de imágenes
- Categoría de la imagen

Dockerhub clasifica las imágenes de la siguiente manera:

- **Oficial**: imágenes creadas por los desarrolladores del software de imágenes específico.
- **Público**: imágenes para ser utilizadas de forma gratuita por cualquier persona.
- **Compilación Automatizada**: imágenes conectadas a repositorios de código (BitBucket, Github) que presentan una generación automática de acuerdo a ciertas condiciones (ej. un commit o merge en la rama maestra del proyecto).
