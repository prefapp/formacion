# O Dockerfile: construíndo a imaxe do "gatiño do día"

### B. Empregando a sintaxe de Dockerfile para construí-la imaxe de "gatiño do día"

Neste exemplo imos construir unha imaxe que teña Python e corra unha aplicación feita en [Flask](https://flask.palletsprojects.com/en/1.1.x/) que é un microframework de aplicacións e páxinas web feito en Python.

Precisamos:

1. Partir dunha ubuntu.
2. Instalar o software necesario de python.
3. Instalar o git para clonar un repositorio.
4. Clonar un repositorio de código: [https://github.com/prefapp/catweb.git](https://github.com/prefapp/catweb.git).
5. Establecer como punto de entrada por defecto dos contedores baseados nesta imaxe a execución do app.py.

Creamos un ficheiro baleiro co nome Dockerfile e imos paso a paso:

```dockerfile
FROM ubuntu
```

O primeiro que declaramos é que a nosa imaxe vaise basear nunha ubuntu. A sentencia [FROM](https://docs.docker.com/engine/reference/builder/#from) establece unha imaxe de base, por suposto poderíamos incluir imaxes dun registry privado.

Imos establecer unha ruta de traballo:

```dockerfile
WORKDIR /home
```

Nesta sentencia establecemos o directorio de traballo actual. O [WORKDIR](https://docs.docker.com/engine/reference/builder/#workdir) establece ónde está o pwd dunha serie de comandos do propio Dockerfile.

Agora instalamos o software que precisamos:

```dockerfile
RUN apt-get update -y && apt-get -y install python3-pip
```

A sentencia [RUN](https://docs.docker.com/engine/reference/builder/#run) corre un comando dentro dun contedor e almacena os resultados (a capa de contedor) na imaxe que se está a construir.

Agora clonamos o repositorio de código da nosa aplicación (en /home).

```dockerfile
RUN git clone https://github.com/prefapp/catweb.git
```

Poñemos os directorio de traballo no repo clonado:

```dockerfile
WORKDIR /home/catweb
```

Esta aplicación ten un ficheiro **requirements.txt** que nos indica qué dependencias de Python se precisan para que funcione. Imos executa-lo [pip](https://pypi.org/project/pip/) para instalar o necesario:

```dockerfile
RUN pip3 install -r requirements.txt
```

Por último imos establecer o comando de arranque:

```dockerfile
CMD ["python3", "app.py"]
```

A sentencia [CMD](https://docs.docker.com/engine/reference/builder/#cmd) permítenos establecer un **único comando de arranque por Dockerfile**.

Este comando de arranque implica que, se no docker-run ou no docker-create non expresamos outra cousa, o contedor baseado nesta imaxe vai lanzar o comando que establezcamos nesta sentencia. Digamos que é un init por defecto.

> ⚠️ Distinto do CMD é o ENTRYPOINT. Unha discusión das diferencias pódese ver [aquí](https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/).

Con isto, temos xa o noso Dockerfile:

```dockerfile
FROM ubuntu

WORKDIR /home

RUN apt-get update -y && apt-get -y install python3-pip git

RUN git clone https://github.com/prefapp/catweb.git

WORKDIR /home/catweb

RUN pip3 install -r requirements.txt

CMD ["python3", "app.py"]
```

Poñéndonos no directorio do Dockerfile, construímo-la imaxe:

```shell
docker build . -t web-gatinhos
```

E agora lanzamos a nosa web para o gato do día:

```shell
docker run -d -p 5000:5000 web-gatinhos
```

Se imos a un navegador e miramos no localhost:5000, veremos unha foto dun gatiño. Cada vez que recarguemo-la páxina teremos unha nova foto.
