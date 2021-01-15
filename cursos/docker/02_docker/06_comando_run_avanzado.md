# Comando _**run**_ avanzado

Unha vez comprendido o ciclo básico de **crear-correr-deter-borrar** contedores, imos revisita-lo comando run para ver algunhas das súas opcións.

## Executar un comando instantáneo nun contedor

Imaxinemos que queremos sabe-la versión da nosa debian, para iso, teríamos que facer un cat do ficheiro **/etc/issue**.

Imos crear un contedor que faga este traballo, e despois que desapareza. 

```shell
docker run --rm prefapp/debian-formacion cat /etc/issue
```

Isto nos sacará por pantalla, a seguinte información:

```shell
Debian GNU/Linux 8 \n \l
```

O que acaba de pasar é o seguinte:

1. Docker crea e arrinca (_**run**_) un novo contedor.
2. O sistema vai a borrar o container ó final da súa execución (_**--rm**_).
3. Este contedor vai a estar baseado na imaxe _**prefapp/debian-formacion**_.
4. O comando a executar no contedor é _**cat /etc/issue**_.

Notése que o /etc/issue non é o da nosa máquina senón o da imaxe que monta o contedor! 

Neste exemplo pódese ver o lixeiros que son os contedores: os creamos e destruimos en cuestión de décimas de segundos e os empregamos para executar tareas triviais (como facer un cat).

## Executar un comando de xeito interactivo

Imaxinemos que queremos executar unha sesión dentro da nosa imaxe debian e poder executar comandos dentro dela. 

Para iso temos que crear un contedor (que arrinque un intérprete de comandos), e interactuar con él. 

```shell
docker run --rm -ti prefapp/debian-formacion /bin/bash
```

Se executamos este comando, a noso prompt cambiará a un cadea hexadecimal (o uuid do propio contedor). 

Agora poderíamos interactuar co contedor, e cando rematemos, basta escribir _**exit**_ ou **Ctrl + D** para sair da shell e, ó rematar o programa de lanzamento do contedor, o propio contedor morre e recupera o control a shell da nosa máquina. 

## Crear e correr un contedor demonizado

Cando queremos correr un contedor que da un servizo, o normal é executalo como un daemon. 

Imos crear un contedor que funcione como si de un servidor Debian se tratase. Este contedor vai correr demonizado (independiente da nosa sesión na máquina). Ademáis, ímoslle poñer un nome para poder xestionalo dun xeito máis sinxelo. 

```shell
docker run --name contedor-formacion -d prefapp/debian-formacion tail -f /dev/null
```

Neste caso, decímoslle a docker

- Crea e arrinca un contedor (_**run**_)
- Ponlle o nome contedor-formacion (_**--name**_)
- Queremos que corra en segundo plano, como daemon (_**-d**_)
- Baseámolo na imaxe _**prefapp/debian-formacion**_
- O comando a executar é _**tail -f /dev/null**_



> ⚠️ O emprego do _**tail -f /dev/null**_ empregase para que, ó ser o proceso iniciador do contedor, perviva indefinidamente, ata que se remate explícitamente mediante _**docker stop**_, rematando así o contedor enteiro.

Se executamos o comando, veremos que seguimos na shell da nosa máquina. Ó facer _**docker ps**_, veremos que o noso container está creado e co nome que establecemos.

```shell
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
21295036cca5        prefapp/debi...     "tail -f /dev/null"      2 seconds ago       Up 1 second                                  contedor-formacion
```

> Unha pregunta que nos podemos facer agora é: como entro nese contedor agora?

A solución é _**docker exec**_.

## Executando un comando dentro dun contedor: o _**docker-exec**_

Na sección anterior vimos que podiamos crear un contedor como un daemon que correse na nosa máquina. 

Preguntábamos cómo podíamos "acceder" a ese contedor. 

A solución que nos ofrece docker é o comando [exec](https://docs.docker.com/engine/reference/commandline/exec/): a idea é crear un proceso que se "inserte" dentro do contedor e se execute dentro do mesmo. 

Para poder acadar isto, Docker emprega a chamada ó sistema [nsenter](https://man7.org/linux/man-pages/man1/nsenter.1.html) que lle permite que o proceso "entre" nos namespaces doutro proceso, neste caso, os do contedor no que queremos introducirnos. 

Se lembramos o exemplo anterior, tiñamos un contedor correndo a nosa imaxe de debian co nome "contedor-formacion". 

Para poder correr un proceso noso dentro, cun intérprete de comandos, facemos:

```shell
docker exec -ti contedor-formacion /bin/bash
```

O que estamos a dicirlle a Docker é:

1. Queremos que corras un proceso dentro dun contedor (_**exec**_)
2. Ese proceso ten que correrse en formato interactivo (_**-ti**_)
3. O contedor se identifica co nome _**contedor-formacion**_
4. O proceso a executar é un _**/bin/bash**_
