# Comandos de xestión básica das imaxes

> Tal e como falaramos, as imaxes de Docker teñen que estar **instaladas localmente** para poder ser empregadas polos nosos containers. 

O que segue é unha relación dos comandos que imos precisar para xestionar as imaxes na nosa máquina. 

## I. Listado de imaxes

Docker almacena as imaxes que podemos empregar localmente. Para obter un listado das imaxes, basta con facer:

```shell
docker images
```

Deste xeito, obteremos un listado das imaxes que temos na nosa máquina. 

Como vemos, as imaxes teñen unha serie de campos:

- **Repository**: uri da imaxe, por defecto o repositorio de obtención e o Dockerhub. 
- **Size**: tamaño da imaxe en disco.
- **Tag**: marcado da imaxe. 
- **Image ID**: Identificador da imaxe
- **Created**: Data de creación

### Actividade 📖
>- ✏️ Atope todas as opcións do comando _**docker images**_
>- ✏️ Que é un digest de imaxe?

## II. Obtención de imaxes

Para descargar de imaxes mediante Docker, compre facelo dende un repositorio que sexa compatible co sistema. 

O comando de descarga de imaxes en Docker é _**docker pull**_. Imos comezar por descargar unha imaxe mínima do Dockerhub que xera containers que imprimen por pantalla a mensaxe:

> Hello, World!

Para obter a imaxe facemos:

```shell
docker pull library/hello-world
```

### Actividade 📖
>- ✏️ Probe a descargar a imaxe **library/hello-word**.
>- ✏️ Comprobe que está realmente almacenada na súa máquina.
>- ✏️ Lance un container coa imaxe e comprobe que realmente imprime a mensaxe de saúdo por pantalla.

## III. Borrado de imaxes

Para borrar unha imaxe, basta con empregar docker rmi **\<nome de imaxe\>**.

É **importante** notar que, si hay containers que están a empregar unha imaxe, non se pode borrar ata que non se borre o derradeiro container dependente.

Se quixeramos borrar a imaxe de hello-world que baixamos antes, bastaría con facer:

```shell
docker rmi library/hello-world
```

Supoñendo que non haxa containers dependentes, o Docker borraríanos a imaxe da máquina local. 

### Actividade 📖
>- ✏️ Probe a borrar a imaxe de **library/hello-world** da súa máquina.
>- ✏️ Explore as opcións de docker _**rmi**_, qué fai a opción _**-f**_?.
