# Montando o primeiro cluster Swarm - Docker Machine

Para a creación dun primeiro cluster de nodos con Docker Swarm, vamos a usar 2 máquinas virtuais correndo no propio VirtualBox que temos instalado localmente.

Poderíamos realizar esta tarefa clonando a máquina actual **docker-platega**, ou instalando de novo 2 vps co seu SO Linux e agregándolle o docker engine como vimos no tema 2, pero Docker nos provee dunha ferramenta máis útil para esta labor:

## Docker machine

[Docker Machine](https://docs.docker.com/machine/overview/#why-should-i-use-it) é unha ferramenta [opensource](https://github.com/docker/machine) mantida pola empresa Docker xunta coa comunidade, que permite instalar e xestionar, dende o noso equipo local, nodos Docker (servidores virtuais co docker-engine instalado) tanto en máquinas virtuais locais (HyperV, VirtualBox, VMWare Player) como en proveedores remotos (AWS, Azure, DigitalOcean ...).

Para crear o noso primeiro cluster Swarm, vamos a empregar esta ferramenta, para crear 2 novas máquinas virtuais correndo no noso VirtualBox, que van a formar o noso cluster Swarm.

Para isto so é necesario realizar os seguintes pasos:

### 0) Instalar docker-machine

```sh
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
chmod +x /tmp/docker-machine && \
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
```

	Atencion Se estamos nun sistema operativo diferente de linux (windows, mac), para poder dispoñer de docker-machine é recomendable instalar o paquete de

	[Docker Toolbox](https://docs.docker.com/toolbox/overview/), xa que aínda que está actualmente marcado como legacy, é o que menos problemática xenera co VirtualBox.

### 1) Crear a primeira máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox01
```

> Con -d se especifica o driver a empregar,  vbox01 será o nome da vm xenerada.

Este comando descarga unha imaxen de Virtualbox dunha distribución moi lixeira de Linux (boot2docker) co demonio de Docker instalado, e crea a máquina vitual co demonio de Docker arrancado.

### 2) Crear a segunda máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox02
```

### 3) Iniciar o swarm nunha delas (por exemplo na vbox1)

```sh
docker-machine ssh vbox01 "docker swarm init --advertise-addr <MANAGER-IP>"
```

A MANAGER-IP  é a ip que ten configurada o nodo na interfaz que se vai  a usar para conectarse  cos demais nodos

### 4) Unir a outra máquina ao swarm

```sh
docker-machine ssh vbox02 "docker swarm join --token xxxxxxxxxxxxxx <MANAGER-IP>:2377"
```

O token para unir a máquina ao swarm nolo indican no anterior punto 3, ao facer o *swarm init*.

E listo, con estos 4 pasos xa temos un cluster swarm creado con 2 máquinas. Agora podemos agregar máis máquinas ao cluster, ou lanzar sobre él unha aplicación.

