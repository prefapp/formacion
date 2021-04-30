# Mellorando o Dockerfile da web "gatiño do día"

## 1. Alixeirando a imaxe
Se construímo-la imaxe do gatinho web da [actividade anterior](https://prefapp.github.io/formacion/cursos/docker-images/#/./01_creacion_de_imaxes/05_o_dockerfile_construindo_a_imaxe_do_gatinho_do_dia), podemos sabe-lo tamaño da mesma.

Basta con facer:

```dockerfile
docker images web-gatinhos
```

Para obter o tamaño da imaxe. Veremos que a imaxe pesa 491MB. Este peso é excesivo segundo os estándares actuais. Pensemos que estas imaxes:

- Son susceptibles de instalarse en moitos nodos.
- A velocidade de disposición delas depende, en grande medida, do seu tamaño posto que compre descargalas ó host para poder empregalas.
- Hoxe en día a tendencia é a de construir as imaxes máis pequenas posibles.

Afortunadamente, o Docker e a comunidade van poñer á nosa disposición unha serie de mecanismos para facer as nosas imaxes máis pequenas.

### A. A estratexia do multi-stage

Repasemos o proceso de construcción da imaxe do "gatiño do día":

1. Partimos dunha Ubuntu.
2. Instalamos git e as dependencias básicas de python. 
3. Clonamos o repo de gatiño do día.
4. Facemos a instalación das librarías de python do proxecto.
5. Definimos arranque do sistema.

Se o pensamos, o git emprégamolo para clonar o repo, pero unha vez feito este paso, qué utilidade ten?

A idea do [multi-stage](https://docs.docker.com/develop/develop-images/multistage-build/) consiste en ir creando contedores que fan un traballo e o deixan en directorios que poden ser empregados por outros contedores. O contedor que fixo un traballo, pode ser desbotado e con él tódalas súas dependencias. Co cal quedamos co resultado do traballo e non con todo o software auxiliar que compre empregar para obtelo. 

No noso caso, podemos crear un contedor, instala-lo git, clonar o repo e despois desbotar o git e tódalas súas dependencias. O que nos interesa é ter o noso repo nalgures para o seguinte contedor que faga o seguinte traballo.

Para facer unha imaxe da web "gatiño do día" imos dividi-lo traballo en dúas fases (stages):

1. **Constructor**: imos instalar todo o software necesario para clona-lo repo e instalar as librarías de proxecto. Todo o software resultante e estrictamente necesario vaise poñer nun directorio: o **/venv**. O resto do software do contedor vaise desbotar.
2. **Final**: imos montar o directorio resultante da fase anterior (o /venv) nun novo contedor que terá o mínimo necesario para move-lo python (o [pipenv](https://docs.python-guide.org/dev/virtualenvs/)).

![multistaging](./../_media/01_creacion_de_imaxes/multi-staging.png)

Se o vemos nun Dockerfile:

```dockerfile
# Constructor: stage de produción do /venv con todo o necesario para o noso proxecto
FROM ubuntu:16.04 as builder

# Instalamos o software necesario
RUN apt-get update && \
    apt-get install -y libssl-dev libffi-dev \
    git python-dev build-essential \
    python-pip python-virtualenv

# Montamos o pipenv e clonamos o repo dos gatiños
RUN bash -c "virtualenv /venv && \
    source /venv/bin/activate && \
    git clone https://github.com/prefapp/catweb.git /venv/catweb &&
    pip install -r /venv/catweb/requirements.txt"

# Final: stage final (todo o stage anterior desaparece, salvo odirectorio /venv)
FROM ubuntu:16.04

COPY --from=builder /venv /venv

RUN apt-get update && \
    apt-get install -y python-virtualenv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="/venv/bin:${PATH}" \
    VIRTUAL_ENV="/venv"

EXPOSE 5000

# COmando de arranque do contedor
CMD ["python", "/venv/catweb/app.py"]
```

Como podemos ver:

- Hai dúas fases que comenzan en dous from distintos (liñas 6 e 23).
- O traballo do constructor vólcase no /venv (liña 15).
- O contedor final "importa" o /venv do contedor constructor (liña 23).

> ⚠️ Para evitar ter moitos RUN fanse cadeas de comandos con && e se corta a liña para facelo máis lexíbel.

Se executamos este Dockerfile e creamos outra imaxe, veremos que a imaxe nova ten un tamaño de 205MB, producimos un aforro de 286MB!!!

> ⚠️ Mostramos neste exemplo dous stages, pero poderían ser moitos máis segundo as nosas necesidades. 

> 👀 Onde se tira tamén moito partido desta técnica é nas aplicacións compilables con linguaxes como C, C++ ou Go.

> 👀 Para unha discusión relativa ás construcción multi-stage ou builds de tipo mono-stage pódese consultar este artigo.

### B. Todavía máis.... Xogando con alpine

As distros de linux como [Alpine](https://www.alpinelinux.org/about/), están deseñadas para ser moi lixeiras e seguras, pero mantendo unha orientación hacia o propósito xeral.

Alpine destaca especialmente polo seu reducido tamaño (5MB) e por ser unha das distros estrela no Dockerhub.

Empregando micro-distros, podemos reducir ainda máis o tamaño das nosas imaxes.

```dockerfile
FROM alpine:latest

RUN apk add --update py-pip

RUN pip install --upgrade pip

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/

EXPOSE 5000

CMD ["python", "/usr/src/app/app.py"]
```

Con este Dockerfile e clonando o [repo](https://github.com/prefapp/catweb) en local, podemos ter unha imaxe de "gatiño do día" de 60MB!!!!

# 🕮 Actividade

>- ✏️ Probemos a construí-la imaxe do "gatiño do día" co multi-stage e vexamos cal é o seu tamaño.

## 2. Construindo distintas versións da web

No caso de ter distintas versións da web, sempre que o proceso de construcción é o mesmo, parece útil poder empregar o mesmo Dockerfile para ambas construccións. 

Imaxinemos que temos un repo de git (como o dos [gatiños](https://github.com/prefapp/catweb)) con dúas ramas:

- **master**: ten a versión 1 da web.
- **v2**: ten a versión 2 da web.

Interesaría ter un Dockerfile que, segundo lle pasemos un argumento ou outro poida construir versións diferentes. 

Para acadar isto temos os [ARGS](https://docs.docker.com/engine/reference/builder/#arg) do Dockerfile. Os args son valores que podemos pasarlle ó **docker-build** no momento da construcción da imaxe.

Estos ARGS pódense interpolar nas diversas instruccións do Dockerfile.

Imaxinemos que temos dúas ramas no noso repo da web "gatiños do día" (master, v2), podemos modificar o noso Dockerfile orixinal para que solo baixe unha das ramas no clone.

É dicir, no canto de empregar isto:

```dockerfile
RUN git clone https://github.com/prefapp/catweb.git
```

Imos utiliza-la seguinte sentencia:

```dockerfile
RUN git clone https://github.com/prefapp/catweb.git --single-branch -b $branch
```

Deste xeito o git sólo baixara unha das ramas do proxecto (master, v2, v3...).

O problema. obviamente, é como establecer o valor da variable _**$branch**_.

Para iso, imos a empregar un ARG.

```dockerfile
ARG branch=master

RUN git clone https://github.com/prefapp/catweb.git --single-branch -b $branch
```

Agora, o noso Dockerfile agarda un argumento branch cando se invoque. No caso de non recibir tal argumento, o arg inicialízase a un valor por defecto "master".

Se agora facemos:

```shell
docker build --build-arg branch=master . -t web-gatinhos:v1
```

Estamos a dicirlle ó Docker:

- Constrúe unha imaxe (docker build).
- Pásalle un arg "branch" con valor "master" (--build-arg branch=master).
- O dockerfile está nesta ruta (.).
- A imaxe resultante ten que ser web-gatinhos:v1

Se agora facemos o mesmo pero para v2:
```shell
docker build --build-arg branch=v2 . -t web-gatinhos:v2
```

Teremos unha imaxe web-gatinhos:v2 cos novos cambios. 

> ⚠️ Pasar mediante ARGS contrasinais ou outra información confidencial é perigoso, pois queda na imaxe producida.
