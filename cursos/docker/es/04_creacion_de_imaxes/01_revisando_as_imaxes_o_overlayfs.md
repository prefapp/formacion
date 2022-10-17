# Revisitando las imágenes: overlaysfs

En la sección anterior vimos el concepto de imágenes y cómo se utilizan para lograr los objetivos de la contenedorización.

Sin embargo, en este apartado vamos a profundizar en el concepto de imagen echando un vistazo a las tecnologías que las hacen posibles: nos referimos a los **soportes de unión**.

## 1. La union mounts
Un union mount es un sistema que le permite combinar diferentes directorios en uno que parece una mezcla de ellos: de ahí su nombre.

![Union](./../_media/01_creacion_de_imaxes/union_1.png)

### A. Jugando con union mounts

> ⚠️ Para hacer esta práctica guiada, compra un sistema linux con un kernel >= 3.18. ¡No se puede realizar dentro de un contenedor!

La tecnología que utiliza actualmente Docker es [OverlayFS](https://en.wikipedia.org/wiki/OverlayFS), incluida en el propio kernel desde la 3.18.

Vamos a crear dos directorios:

```shell
mkdir a b
```

Dentro del directorio _**~/a**_ vamos a crear dos archivos vacíos:

```shell
touch a b
```

Dentro del directorio _**~/b**_ vamos a crear dos archivos vacíos (**c** **d**) y un nuevo directorio **e**.

```shell
touch c d
mkdir e
```

Ahora creamos un directorio c al mismo nivel que _**~/a**_ _** y ~/b**_.

```shell
mkdir c
``` 

Emitiendo el siguiente comando:

```shell
mount -t overlay overlay -o lowerdir=./a,upperdir=./b,workdir=./c ./c
```

Si listamos el contenido de _**~/c**_ veremos que tenemos una estructura como la del diagrama.

¿Qué hicimos con este comando?

- Montamos una unidad en un directorio _**~/c**_.
- De tipo _**overlay**_.
- Especificamos como destino: un directorio de solo lectura (_**~/a**_) un directorio de escritura-lectura (_**~/b**_) y un directorio de transferencia especial (_**~/ c **_).

### B. El mecanismo COW y copy-up

Naturalmente, surgen preguntas:

- ¿Qué pasa si modifico un archivo?
- ¿Qué sucede si elimino un directorio o un archivo?
- ¿Puedo configurar elementos de solo lectura?

Cuando hablamos de lowerdir y upperdir nos referimos a dos niveles de montaje en los overlayfs.

#### i. Lowerdir

Las capas montadas en este nivel no se pueden modificar ni eliminar.

Si modifica un archivo perteneciente a esta capa, lo que se hará es copiarlo (COW - copy on write) a una capa superior, la upperdir.

![Union](./../_media/01_creacion_de_imaxes/union_3.png)

copy-up recibe su nombre de esa operación de copiar el archivo de una capa de lowerdir a una de upperdir antes de modificarlo. Esto permite dos cosas:

- Solo se copian los archivos que están realmente modificados (Copy On Write -> COW)
- Se pueden mantener capas de solo lectura mezcladas con capas de escritura.
- Todas estas operaciones son transparentes para el proceso que se ejecuta en el volumen overlayfs.

#### ii. upperdir

Estos son los directorios de escritura/lectura. copy-up se realizan en estas capas.

## 2. Imágenes y OverlayFS

Como mencionamos, el contenedor se crea a partir de una imagen que es un sistema de archivos de solo lectura.

Sin embargo, dentro del contenedor podemos instalar, borrar y modificar todo lo que queramos.

Ahora, entendemos que todos los cambios se guardan en la capa del contenedor, que es un directorio superior montado precisamente sobre la imagen, que es una capa de directorio inferior.

¿Y los volúmenes? Los volúmenes, dependiendo de si los montamos de solo lectura o no, estarán en lowerdir o upperdir.
