# El Dockerfile: construyendo la imagen del "gatiño do día"

### B. Uso de la sintaxis de Dockerfile para crear la imagen del "gatiño do día"

En este ejemplo vamos a construir una imagen que tiene Python y ejecutar una aplicación hecha en [Flask](https://flask.palletsprojects.com/en/1.1.x/) que es un microframework de aplicaciones y páginas web hechas en Python.

Nosotros necesitamos:

1. A partir de un ubuntu.
2. Instale el software de Python necesario.
3. Instala git para clonar un repositorio.
4. Clone un repositorio de código: [https://github.com/prefapp/catweb.git](https://github.com/prefapp/catweb.git).
5. Configure la ejecución de app.py como el punto de entrada predeterminado para los contenedores basados ​​en esta imagen.

Creamos un archivo vacío con el nombre Dockerfile y vamos paso a paso:

```dockerfile
FROM ubuntu
```

Lo primero que declaramos es que nuestra imagen estará basada en un ubuntu. La declaración [FROM](https://docs.docker.com/engine/reference/builder/#from) establece una imagen base, por supuesto, podríamos incluir imágenes de un registro privado.

Configuremos una ruta de trabajo:

```dockerfile
WORKDIR /home
```

En esta declaración establecemos el directorio de trabajo actual. El [WORKDIR](https://docs.docker.com/engine/reference/builder/#workdir) establece dónde está el pwd para una serie de comandos en el propio Dockerfile.

Ahora instalamos el software que necesitamos:

```dockerfile
RUN apt-get update -y && apt-get -y install python3-pip git
```

La instrucción [RUN](https://docs.docker.com/engine/reference/builder/#run) ejecuta un comando dentro de un contenedor y almacena los resultados (la capa del contenedor) en la imagen que se está creando.

Ahora hemos clonado el repositorio de código de nuestra aplicación (en /home).

```dockerfile
RUN git clone https://github.com/prefapp/catweb.git
```

Ponemos los directorios de trabajo en el repositorio clonado:

```dockerfile
WORKDIR /home/catweb
```

Esta aplicación tiene un archivo **requirements.txt** que nos dice qué dependencias de Python se requieren para que funcione. Ejecutemos [pip](https://pypi.org/project/pip/) para instalar lo necesario:

```dockerfile
RUN pip3 install -r requirements.txt
```

Finalmente configuremos el comando de arranque:

```dockerfile
CMD ["python3", "app.py"]
```

La instrucción [CMD](https://docs.docker.com/engine/reference/builder/#cmd) nos permite establecer un **comando de arranque único por Dockerfile**.

Este comando de inicio implica que, si no expresamos nada más en docker-run o docker-create, el contenedor basado en esta imagen lanzará el comando que configuramos en esta instrucción. Digamos que es un inicio predeterminado.

> ⚠️ A diferencia del CMD es el PUNTO DE ENTRADA. Se puede ver una discusión de las diferencias [aquí](https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/).

Con esto, tenemos nuestro Dockerfile:

```dockerfile
FROM ubuntu

WORKDIR /home

RUN apt-get update -y && apt-get -y install python3-pip git

RUN git clone https://github.com/prefapp/catweb.git

WORKDIR /home/catweb

RUN pip3 install -r requirements.txt

CMD ["python3", "app.py"]
```

Poniéndonos en el directorio Dockerfile, construimos la imagen:

```shell
docker build . -t web-gatinhos
```

Y ahora estrenamos nuestra web para el gato del día:

```shell
docker run -d -p 5000:5000 web-gatinhos
```

Si vamos a un navegador y miramos localhost:5000, veremos una imagen de un gatito. Cada vez que recarguemos la página tendremos una nueva foto.
