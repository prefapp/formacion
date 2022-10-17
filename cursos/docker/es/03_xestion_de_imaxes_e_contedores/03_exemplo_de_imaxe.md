# Ejemplo de imagen

> Las imágenes en Docker se componen de **capas** lo que permite su modularidad y reutilización.

Para este ejemplo, vamos a montar una imagen con el servidor web Apache2.

## 1ra Capa: El sistema base

Ya sabemos que un contenedor está completamente aislado, a excepción del Kernel, del Sistema Operativo host. Esto implica que, para que el contenedor funcione, se necesita tener una primera capa en la imagen con las utilidades y programas fundamentales para garantizar el funcionamiento del software que queremos ejecutar dentro del contenedor. En otras palabras, necesitamos un Sistema Operativo como base de la imagen del contenedor.

Para este ejemplo, elijamos un [Debian Jessie](https://www.debian.org/releases/jessie/). Por supuesto, podríamos haber elegido cualquier otra distribución de Linux que sea compatible con el kernel que se ejecuta en la máquina host (Ubuntu, Centos, Alpine...)

Nuestra imagen tendría esta estructura:

![Capa](./../_media/03_xestion_de_imaxes_e_contedores/capa_1.png)

## 2da Capa: Las dependencias de Apache2

En este ejemplo, la versión de Apache que se montará es [2.2](https://httpd.apache.org/download.cgi#apache22) que, por supuesto, tiene una serie de [dependencias](https://httpd.apache.org/docs/2.2/install.html#requirements) específicas del software.

Estas dependencias constituirían una segunda capa en nuestra imagen:

![Capa](./../_media/03_xestion_de_imaxes_e_contedores/capa_2.png)

## 3ra Capa: El servidor Apache

Finalmente, agreguemos la capa con nuestro servidor web.

La imagen, finalmente, quedaría así:

![Capa](./../_media/03_xestion_de_imaxes_e_contedores/capa_3.png)

¡Y hecho! Ahora podemos usar la imagen para lanzar contenedores con **versiones específicas** de software y una base de **Debian** sin preocuparnos por el resto del software que pueda estar ejecutándose en el host.

![Capas](./../_media/02_docker/../03_xestion_de_imaxes_e_contedores/capa_total.png)