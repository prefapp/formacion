# Ejemplo: crear una imagen usando comandos

> Nuestro "Hello World"

Vamos a ilustrar el proceso de creación de una imagen a través de un ¡Hello World!, pero en gallego.

Animamos al alumno a que intente hacer este ejemplo en su máquina porque será relevante para luego convertirlo en una práctica al final de la sección.

Vamos a construir una imagen que contenga una sencilla aplicación basada en **apache2** que exporte una página web con "**Hello World**" en gallego.

El plan de trabajo es el siguiente:

1. Partiremos de una **Debian:Jessie**.
2. Instalaremos un **apache**.
3. Introduciremos una configuración.
4. Copiaremos nuestro **Hello World!!**
5. Probaremos nuestra imagen lanzando un contenedor.

## I. Poner las cosas en orden

Lo primero que necesitamos es la imagen de Debian que vamos a utilizar. Vamos a descargarlo desde Dockerhub:

```shell
docker pull debian:jessie
```

Ahora tenemos la imagen de Debian en nuestra máquina local. ¡Podemos empezar a trabajar!

Para seguir nuestro ciclo de evolución, vamos a utilizar el contenedor **saudo-container**, y la imagen a producir se llamará **saudo-galego**.

## II. Instalación de Apache2

Compre que instalamos apache2 en nuestro contenedor y luego hacemos una confirmación de los cambios en nuestra imagen. En un esquema:

![Pasos](../../_media/01_creacion_de_imaxes/imaxe_paso_1.png)

Iniciamos un contenedor para hacer el trabajo de instalar **apache2**:

- El contenedor tendrá el nombre **hello-container**.
- Tiene que estar en modo *interactivo* para poder usarlo y que, una vez que salimos del contenedor, este se *detenga*.
- Además, queremos que el **punto de entrada** al contenedor sea bash.

```shell
docker run --name saudo-container -ti debian:jessie bash
```

Una vez ejecutado, ya estaremos dentro del contenedor, y haremos nuestro trabajo:

- Actualizamos fuentes de software

```shell
apt-get update
```

- Instalamos apache

```shell
apt-get install apache2
```

Limpiamos las fuentes:

```shell
rm -r /var/lib/apt/lists/*
```

Ahora tenemos nuestro contenedor con el estado que queremos. Salga usando **exit** o **CTRL+D**.

Ya en la máquina host, nos **commit** con la nueva imagen.

```shell
docker commit saudo-container saudo-galego
```

Tenemos una nueva imagen con nuestro software instalado.

Podemos prescindir del contenedor saudo-container ya que los cambios ya están en la nueva imagen. Bórralo:

```shell
docker rm -v saudo-container
```

## III. Clonación del repositorio Saudo Galego

Con la base que tenemos del paso anterior, comencemos de nuevo un contenedor (ya basado en nuestra imagen) y hagamos las siguientes tareas:

1. Instale git como VCS.
2. Clone el repositorio de la página de bienvenida.
3. Haz que se comprometa con la imagen.

En un esquema seria:

![Pasos](../../_media/01_creacion_de_imaxes/imaxe_paso_2.png)

Para empezar, arrancamos un nuevo contenedor basado en la imagen de saludos gallegos que ya elaboramos en el paso anterior:

- El contenedor también se llamará **saudo-container**.
- Necesitamos que sea interactivo para poder trabajar dentro del contenedor.
- El comando para iniciar es bash.

En nuestra máquina, escribimos:

```shell
docker run -ti --name saudo-container saudo-galego bash
```

Vamos a usar el software [Git](https://git-scm.com/) así que instalamos el paquete:

```shell
apt-get install -y git
```

Ahora clonamos el repositorio del proyecto saud-gl en una ruta de nuestro contenedor:

```shell
cd /opt  && git clone https://github.com/prefapp/saudo-gl.git
```

Ya estamos dentro de un contenedor basado en la imagen del paso anterior. Por lo tanto, ya tiene un Apache2 instalado. Apache2, de forma predeterminada, ofrece contenido de _**/var/www/html**_.

Pasemos a esa ruta:

```shell
cd /var/www/html
```

Y copiamos el contenido del proyecto saud-gl a la ruta donde Apache2 sirve los archivos:

```shell
cp -r /opt/saudo-gl/* . 
```

Et voilà! Salimos del contenedor con **exit** o **CTRL+D** y confirmamos los nuevos cambios en nuestra imagen:

```shell
docker commit saudo-container saudo-galego
```

Como siempre, eliminamos el contenedor de trabajo porque ya no lo necesitamos. ¡Está listo!

El proceso completo sería el siguiente:

![Pasos](../../_media/01_creacion_de_imaxes/imaxe_pasos.png)

## IV. Usando la imagen de saud-galego

Para lanzar un contenedor con nuestra aplicación, solo recuerda dos cosas:

- Comprar establece el **punto de entrada** declarando que debe iniciar **Apache2**.
- Es recomendable asociar un puerto diferente al 80 para evitar colisiones con otros servicios que el profesor pueda tener configurados en su máquina.

Introduciendo esto en nuestra máquina:

```shell
docker run --rm -p 8000:80 -d saudo-galego apachectl -DFOREGROUND
```

Tendríamos un contenedor corriendo con nuestra imagen preparada y escuchando en el puerto 8000. Si vamos a nuestro navegador e ingresamos [http://localhost:8000](http://localhost:8000) la aplicación nos saludará.
