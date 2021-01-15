# Comandos básicos

A interacción con Docker (co seu daemon)  pódese facer, fundamentalmente por dúas vias:

- A través dunha [api](https://docs.docker.com/engine/api/v1.30/).
- Mediante a súa liña de comandos

Neste curso, imos a empregar a liña de comandos. 

O intérprete de comandos de Docker é o comando [docker](https://docs.docker.com/engine/reference/commandline/cli/).

## Listaxe dos contedores do sistema

Para saber os contedores existentes nunha máquina, imos a empregar o comando [_**ps**_](https://docs.docker.com/engine/reference/commandline/ps/).

```shell
docker ps
```

O que obtemos é:

```shell
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
b3b0f3dff0cd        mongo               "docker-entrypoint..."   7 second ago        Up 6 seconds        27017/tcp                mongo
```

Como podemos comprobar:

- Docker asigna un uuid ós contedores. 
- Infórmanos sobre a imaxe que monta (máis sobre imaxes no seguinte tema).
- Fálanos do comando que lanzou este contedor.
- Os seus tempos de arranque (CREATED) e o tempo que leva aceso (STATUS)
- A conectividade do contedor.
- O nome asignado ó contedor en caso de que non llo poñamos nós.

## Creando e arrincando contedores

O comando básico de creación de contedores e [_**create**_](https://docs.docker.com/engine/reference/commandline/create/). (Orixinalmente [_**docker run**_](https://docs.docker.com/engine/reference/commandline/run/), que sigue estando dispoñible e conxuga varios obxetos cos que traballa docker: containers, volumes e networks)

Compre enviarlle un elemento obligatorio:

Imaxe de creación, (similar  ao disco de arranque do container), trátase dunha planiña a partir da que se montará o contedor.

Deste xeito, o seguinte comando:

```shell
docker create prefapp/debian-formacion
```

Voltaranos unha cadea en hexadecimal que será o identificador único do contedor creado. 

Nembargantes, se facemos _**docker ps**_ non o veremos na táboa de contedores. 

A razón é que o contedor creado estará parado. Para arrincalo, compre executar o comando [_**start**_](https://docs.docker.com/engine/reference/commandline/start/).

```shell
docker start <uuid do contedo>
```

Con isto, teremos o novo contedor funcionando, e se facemos un _**docker ps**_ poderémolo ver na táboa de contedores funcionando. 

O normal é facer estos dous pasos nun, mediante  o comando [_**run**_](https://docs.docker.com/engine/reference/commandline/run/). Este comando, crea e arrinca o contedor. 

## Detendo o contedor

Para deter un contedor que está a funcionar, abonda con empregar o comando [_**stop**_](https://docs.docker.com/engine/reference/commandline/stop/). 

```shell
docker stop
```

Unha vez executado, o contedor está detido, de tal xeito que non aparecerá xa na táboa de _**docker ps**_. Compre empregar _**docker ps -a**_ para que o listado inclúa os contedores detidos.

## Borrando o contedor

O comando docker [_**rm**_](https://docs.docker.com/engine/reference/commandline/rm/) elimina o contedor. 

```shell
docker rm <uuid do contedo>
```

**Ligazóns de interese**
- Docker cheat-sheet
