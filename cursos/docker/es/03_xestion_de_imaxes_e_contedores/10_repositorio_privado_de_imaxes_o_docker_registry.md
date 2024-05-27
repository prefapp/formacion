# Repositorio privado de imágenes: Docker Registry

Una de las necesidades importantes al trabajar con imágenes es tener un repositorio confiable donde pueda:

- Probar y gestionar imágenes en desarrollo.
- Asegura la privacidad de las imágenes.

> Docker nos proporciona un software especial para que podamos tener un repositorio privado de imágenes: el [Docker Registry](https://docs.docker.com/registry/).

## Principales características

El registro de Docker es un software de administración de imágenes de Docker que:

- Permite el almacenamiento de imágenes compatible con Docker, Kubernetes y Rocket.
- Tiene la capacidad de servir esas imágenes a los clientes en las principales plataformas de contenedores (Docker, Kubernetes, Rocket)
- Se puede conectar un volumen en NTFS o nuestra propia máquina contra un almacén de objetos (AZURE, AWS).
- Además, se distribuye como contenedor!!!

## Montaje del Docker Registry en nuestra máquina

Dado que Docker Registry puede ejecutarse en un contenedor, no hay nada que nos impida montarlo en nuestra propia máquina. De esta forma, basta con hacer:

```shell
docker run -d --name meu-rexistro -p 5000:5000 registry:2
```

Para que tengamos un registro montado en un contenedor llamado my-registry y que escuche en el puerto 5000 del localhost.

Ahora, podríamos interactuar con él para subir imágenes y descargarlas.

## Subir imágenes al registro privado - Etiquetas de imagen

Para poder subir una imagen a nuestro registro privado, primero debemos indicarle a Docker que la imagen tiene un registro diferente al predeterminado (que será el Dockerhub).

Para ello, utilizaremos [docker-tag](https://docs.docker.com/engine/reference/commandline/tag/). Es una herramienta que nos permite producir una nueva imagen creando una referencia a la otra que se convierte en su origen.

![dockertag](../../_media/03_xestion_de_imaxes_e_contedores/docker_tag.png)

Desde el momento de la creación de la nueva imagen, mediante una etiqueta, ya se puede referenciar sin afectar la imagen original.

Dado que el nombre de la imagen consta de segmentos alfanuméricos separados por "**/**" y que el registro se puede ingresar opcionalmente como el primer segmento, podemos almacenar nuestra imagen prefapp/debian-formation en el registro privado de la manera más simple:

```shell
docker tag prefapp/debian-formacion localhost:5000/prefapp/debian-formacion
```

En este comando estamos diciendo:

- Crear una nueva imagen (_**docker tag**_).
- Tomar como fuente la imagen **prefapp/debian-formacion**.
- La nueva imagen se llamará **localhost:5000/prefapp/debian-formacion**.

El nombre de la imagen creada tiene como punto de partida un **nombre de host**, de esta forma, docker entiende que el registro de esta imagen no es el predeterminado (el Dockerhub) sino uno nuevo, que corresponde al nombre de host de nuestro registro privado.

Ahora podemos "**empujar**" esa imagen a nuestro registro.

```shell
docker push localhost:5000/prefapp/debian-formacion
```

En unos instantes tendremos nuestra imagen subida al registro privado. Ahora, podemos eliminarlo de nuestro docker local sin miedo, ya que ya está almacenado en el registro privado.

```shell
docker rmi localhost:5000/prefapp/debian-formacion
```

## Uso de imágenes de registro privadas

Para usar las imágenes de nuestro registro privado, simplemente use [docker-pull](https://docs.docker.com/engine/reference/commandline/pull/):

```shell
docker pull localhost:5000/prefapp/debian-formacion
```

Ya tendríamos nuestra imagen local, descargada del registro privado.

> 👀 Las posibilidades que esto representa para el desarrollo no se nos escapan.

> 👀 Basta con poner una máquina con registro que esté conectada únicamente a la red local, para que en una empresa se puedan controlar y asegurar todos los desarrollos y la disponibilidad total de los miembros del equipo.
