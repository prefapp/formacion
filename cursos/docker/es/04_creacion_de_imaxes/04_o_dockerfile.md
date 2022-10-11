# Dockerfile

Como vimos en la sección saudo-gl, hacer una imagen puede ser un proceso tedioso y complejo que implica lanzar muchos comandos y que puede ser muy difícil de replicar.

Por suerte, Docker proporciona una herramienta que nos permite trabajar mucho más fácil: el Dockerfile.

## 1. Dockerfile

El Dockerfile es un fichero de texto que contiene la receta de cómo crear una imagen.

El conjunto de instrucciones del Dockerfile constituye un [DSL](https://es.wikipedia.org/wiki/Lenguaje_espec%C3%ADfico_de_dominio) que nos permitirá expresar de una manera razonablemente sencilla los pasos que se deben seguir para producir la imagen.

Una vez que se haya escrito el Dockerfile, simplemente use el comando docker build para producir una imagen con él. Docker creará (y destruirá) los contenedores de trabajo que necesita para construir nuestra imagen mientras conserva solo el resultado final: la imagen que queremos.

### A. La sintaxis de un Dockerfile

El Dockerfile agrupa un conjunto de declaraciones en un archivo de texto. Docker interpreta y ejecuta cada una de las declaraciones en orden y produce una imagen de salida.

Cada sentencia implica una nueva capa en la imagen.

Ejemplo:

```dockerfile
# Imaxe da que se parte
FROM ubuntu

# Mantedor do Dockerfile
LABEL maintainer=fmaseda@4eixos.com

# Actualizamos as sources
RUN apt-get update

# Instalamos o nginx
RUN apt-get install -y nginx

# Declaramos que o punto de entrada ó container e un nginx en foreground
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off"]

# O porto para conectar o container co mundo exterior e o 80
EXPOSE 80
```

Si ponemos ese contenido en un archivo llamado Dockerfile y escribimos:

```shell
docker build -t imaxe_propia .
```

Docker producirá una imagen llamada **own_image** que ejecutará nginx en el puerto 80 y se basará en la imagen de Ubuntu.

El Dockerfile DSL es simple pero muy completo. [Aquí](https://docs.docker.com/engine/reference/builder/) puede ver una lista de los comandos.