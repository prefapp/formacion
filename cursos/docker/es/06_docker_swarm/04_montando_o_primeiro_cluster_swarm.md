# Montaje del primer clúster Swarm

Existen diversas maneras de crear y configurar un clúster con nodos Docker.

Podríamos realizar esta tarea clonando la máquina actual **docker-platega**, o instalando de nuevo 2 vps con su sistema operativo Linux y añadiéndole el motor docker como vimos en el tema 2. En este caso usaremos Vagrant para automatizar la creación de las máquinas virtuales de VirtualBox.

## Vagrant

[Vagrant](https://developer.hashicorp.com/vagrant/intro) es una herramienta [opensource](https://github.com/hashicorp/vagrant) que se utiliza para crear y configurar entornos de desarrollo virtualizados. Su objetivo principal es simplificar la configuración y el manejo de máquinas virtuales con configuraciones predefinidas y provisionamiento automático de software, pudiendo utilizar varios proveedores de máquinas virtuales (VirtualBox, VMware, Docker ...).

### Creación del cluster

Para crear el clúster local primero debemos instalar Vagrant:

```
apt install -y vagrant
```

A continuación tenemos que crear el fichero Vagrantfile.

La primera línea define una variable llamada $install_docker que contiene un script Bash para instalar Docker y añadir el usuario vagrant al grupo docker:

```Vagrantfile
$install_docker = <<-SCRIPT
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker vagrant
SCRIPT
```

La siguiente línea inicializa un objeto de configuración de Vagrant:

```Vagrantfile
Vagrant.configure("2") do |config|
```

La línea `config.vm.box` especifica la box base a utilizar para la máquina virtual. En este caso, utiliza ubuntu/focal64, que se basa en Ubuntu 20.04:

```Vagrantfile
  config.vm.box = "ubuntu/focal64"
```

El bloque `config.vm.provider` define la configuración del proveedor de la máquina virtual. En este caso, establece la asignación de memoria y CPU para la máquina virtual creada por VirtualBox:

```Vagrantfile
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
  end
```

La línea `config.vm.synced_folder` establece una carpeta sincronizada entre la máquina anfitriona y la máquina virtual invitada. En este caso, el directorio actual en la máquina anfitriona se monta como `/vagrant` en la máquina virtual invitada. Esto nos permite pasar el token para unir el worker al cluster de docker swarm, además de poder enviar ficheros de forma más cómoda:

```Vagrantfile
  config.vm.synced_folder ".", "/vagrant"
```

El bloque `config.vm.define` crea dos máquinas virtuales con diferentes direcciones IP en una red privada. La primera máquina virtual se define como un gestor de Docker Swarm con la dirección IP 192.168.56.10, mientras que la segunda máquina virtual se define como un trabajador de Docker Swarm con la dirección IP 192.168.56.11:

```Vagrantfile
  # Manager node
  config.vm.define "manager" do |manager|
    manager.vm.network "private_network", ip: "192.168.56.10"

    manager.vm.provision "shell", inline: $install_docker

    manager.vm.provision "shell", inline: <<-SHELL
      # Set up Docker Swarm as a manager
      sudo docker swarm init --advertise-addr 192.168.56.10
      sudo docker swarm join-token worker | grep token > /vagrant/worker_token
    SHELL
  end

  # Worker node
  config.vm.define "worker" do |worker|
    worker.vm.network "private_network", ip: "192.168.56.11"

    worker.vm.provision "shell", inline: $install_docker

    worker.vm.provision "shell", inline: <<-SHELL
      # Join Docker Swarm as a worker
      cat /vagrant/worker_token | sh
    SHELL
  end
```

Finalmente tenemos el siguiente Vagrantfile.

```Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
  end

  config.vm.synced_folder ".", "/vagrant"

  # Manager node
  config.vm.define "manager" do |manager|
    manager.vm.network "private_network", ip: "192.168.56.10"

    manager.vm.provision "shell", inline: $install_docker

    manager.vm.provision "shell", inline: <<-SHELL
      # Set up Docker Swarm as a manager
      sudo docker swarm init --advertise-addr 192.168.56.10
      sudo docker swarm join-token worker | grep token > /vagrant/worker_token
    SHELL
  end

  # Worker node
  config.vm.define "worker" do |worker|
    worker.vm.network "private_network", ip: "192.168.56.11"

    worker.vm.provision "shell", inline: $install_docker

    worker.vm.provision "shell", inline: <<-SHELL
      # Join Docker Swarm as a worker
      cat /vagrant/worker_token | sh
    SHELL
  end
end
```

Para iniciar las máquinas virtuales usaremos `vagrant up`. Para poder acceder al nodo manager podemos hacerlo a través de ssh con el comando `vagrant ssh manager`.