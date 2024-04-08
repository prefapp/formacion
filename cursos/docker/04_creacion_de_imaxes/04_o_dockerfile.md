# O Dockerfile

Tal e como vimos na sección do saudo-gl, a confección dunha imaxe pode resultar un proceso tedioso e complexo que implica o lanzamento de moitos comandos e que pode resultar moi difícil de replicar.

Por sorte, Docker aporta unha ferramenta que nos permite traballar de xeito moito máis sinxelo: o Dockerfile.

## 1. O Dockerfile

O Dockerfile é un ficheiro de texto que contén a receita de cómo construir unha imaxe.

O conxunto de instruccións do Dockerfile constitúen un DSL que nos vai permitir expresar dun xeito razoablemente doado os pasos que hai que dar para producir-la imaxe.

Unha vez redactado o Dockerfile, basta con empregar o comando docker build para producir unha imaxe con él. Docker creará (e destruirá) os containers de traballo que precise para construir a nosa imaxe mantendo únicamente o resultado final: a imaxe que queremos.

### A. A sintaxe dun Dockerfile

O Dockerfile agrupa un conxunto de sentencias nun ficheiro de texto. Cada unha das sentencias son interpretadas e executadas por orde polo Docker producindo unha imaxe de saída.

Cada sentencia implica unha nova capa na imaxe. 

Nun exemplo:

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
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]

# O porto para conectar o container co mundo exterior e o 80
EXPOSE 80
```

Se poñemos ese contido nun ficheiro que se chame Dockerfile e tecleamos:

```shell
docker build -t imaxe_propia .
```

O Docker vainos a producir unha imaxe de nome **imaxe_propia** que terá un nginx correndo no porto 80 e baseada na imaxe de Ubuntu.

O DSL do Dockerfile é sinxelo pero moi completo. [Aquí](https://docs.docker.com/engine/reference/builder/) pode ver unha relación dos comandos.
