# Montaje del primer clúster Swarm - Docker Machine

Para la creación de un primer clúster de nodos con Docker Swarm utilizaremos 2 máquinas virtuales corriendo en el propio VirtualBox que tenemos instalado localmente.

Podríamos realizar esta tarea clonando la máquina actual **docker-platega**, o instalando de nuevo 2 vps con su sistema operativo Linux y añadiéndole el motor docker como vimos en el tema 2, pero Docker nos proporciona una herramienta más útil para este trabajo:

## Máquina acoplable

[Docker Machine](https://docs.docker.com/machine/overview/#why-should-i-use-it) es una herramienta [opensource](https://github.com/docker/machine) mantenida por la empresa Docker junto con la comunidad, que permite instalar y gestionar, desde nuestro equipo local, nodos Docker (servidores virtuales con el docker-engine instalado) tanto en máquinas virtuales locales (HyperV, VirtualBox, VMWare Player) como en proveedores remotos ( AWS, Azure, DigitalOcean...).

Para crear nuestro primer clúster Swarm, usaremos esta herramienta para crear 2 nuevas máquinas virtuales que se ejecutan en nuestro VirtualBox, que formarán nuestro clúster Swarm.

Para ello solo es necesario realizar los siguientes pasos:

### 0) Instalar docker-machine

```sh
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
chmod +x /tmp/docker-machine && \
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
```

Atención Si estamos en un sistema operativo diferente a linux (windows, mac), para tener docker-machine se recomienda instalar el paquete de

[Docker Toolbox](https://docs.docker.com/toolbox/overview/), ya que aunque actualmente está marcada como heredada, es la menos problemática con VirtualBox.

### 1) Crear la primera máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox01
```

> Con -d si especifica el controlador a usar, vbox01 será el nombre de la máquina virtual generada.

Este comando descarga una imagen de Virtualbox desde una distribución de Linux muy liviana (boot2docker) con el demonio Docker instalado y crea la máquina virtual con el demonio Docker iniciado.

### 2) Crear la segunda máquina virtual con docker-machine

```sh
docker-machine create -d virtualbox vbox02
```

### 3) Iniciar el swarm en uno de ellos (por ejemplo en vbox1)

```sh
docker-machine ssh vbox01 "docker swarm init --advertise-addr <MANAGER-IP>"
```

El MANAGER-IP es la ip que el nodo tiene configurada en la interfaz que se usará para conectarse a los otros nodos

### 4) Une otra máquina al enjambre

```sh
docker-machine ssh vbox02 "docker swarm join --token xxxxxxxxxxxxxx <MANAGER-IP>:2377"
```

El token para unir la máquina al swarm se indica en el punto 3 anterior, al hacer el *swarm init*.

Y listo, con estos 4 pasos ya tenemos un swarm cluster creado con 2 máquinas. Ahora podemos agregar más máquinas al clúster o iniciar una aplicación en él.