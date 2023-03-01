# Comandos básicos de gestión de imágenes

> Como mencionamos, las imágenes de Docker deben **instalarse localmente** para que puedan ser utilizadas por nuestros contenedores.

Lo que sigue es una lista de los comandos que necesitaremos para administrar las imágenes en nuestra máquina.

## I. Lista de imágenes

Docker almacena las imágenes que podemos usar localmente. Para obtener una lista de imágenes, solo haz lo siguiente:

```shell
docker images
```

De esta forma, obtendremos una lista de las imágenes que tenemos en nuestra máquina.

Como podemos ver, las imágenes tienen una serie de campos:

- **Repositorio**: uri de la imagen, por defecto el repositorio fetch y el Dockerhub.
- **Tamaño**: tamaño de la imagen en disco.
- **Etiqueta**: marcaje de la imagen.
- **ID de imagen**: Identificador de la imagen
- **Creado**: fecha de creación

### Actividad 📖
>- ✏️ Encuentra todas las opciones del comando _**docker images**_
>- ✏️ ¿Qué es un digest de imágenes?

## II. Obtención de imágenes

Para descargar imágenes usando Docker, hágalo desde un repositorio que sea compatible con su sistema.

El comando de descarga de imágenes en Docker es _**docker pull**_. Comencemos descargando una imagen mínima de Dockerhub que genera contenedores que imprimen el mensaje en la pantalla:

> Hello, World!

Para obtener la imagen hacemos:

```shell
docker pull library/hello-world
```

### Actividad 📖
>- ✏️ Prueba a descargar la imagen de **library/hello-word**.
>- ✏️ Verifique que esté realmente almacenado en su máquina.
>- ✏️ Inicie un contenedor con la imagen y verifique que realmente imprima el mensaje de saludo en pantalla.

## III. Eliminación de imágenes

Para eliminar una imagen, solo use docker rmi **\<nombre de imagen\>**.

Es **importante** tener en cuenta que, si hay contenedores que usan una imagen, no se puede eliminar hasta que se elimine el último contenedor dependiente.

Si quisiéramos borrar la imagen de hola mundo que descargamos anteriormente, bastaría con hacer:

```shell
docker rmi library/hello-world
```

Suponiendo que no haya contenedores dependientes, Docker eliminará la imagen de la máquina local.

### Actividad 📖
>- ✏️ Intente eliminar la imagen **library/hello-world** de su máquina.
>- ✏️ Explore las opciones de la docker _**rmi**_, ¿qué hace la opción _**-f**_?.