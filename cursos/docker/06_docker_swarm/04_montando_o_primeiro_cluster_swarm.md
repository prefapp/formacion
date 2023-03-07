# Montando o primeiro cluster Swarm - Docker Machine

Para a creación dun primeiro cluster de nodos con Docker Swarm, vamos a usar 2 máquinas virtuais correndo no propio VirtualBox que temos instalado localmente.

Poderíamos realizar esta tarefa clonando a máquina actual **docker-platega**, ou instalando de novo 2 vps co seu SO Linux e agregándolle o docker engine como vimos no tema 2, pero Docker nos provee dunha ferramenta máis útil para esta labor:

Hai varias formas de crear e configurar un clúster con nodos Docker.

Poderiamos realizar esta tarefa clonando a máquina actual **docker-platega**, ou instalando de novo 2 vps co seu sistema operativo Linux e engadindo o docker engine como vimos no tema 2. Neste caso usaremos Vagrant para automatizar a creación das máquinas virtuais de VirtualBox.

## Vagrant

[Vagrant](https://developer.hashicorp.com/vagrant/intro) é unha ferramenta [opensource](https://github.com/hashicorp/vagrant) utilizada para crear e configurar entornos de desenvolvemento virtualizados. O seu principal obxectivo é simplificar a configuración e xestión de máquinas virtuais con configuracións predefinidas e aprovisionamento automático de software, podendo utilizar diversos provedores de máquinas virtuais (VirtualBox, VMware, Docker...).


### Creación del cluster

Para crear o clúster primeiro debemos instalar Vagrant:

```
apt install -y vagrant
```

A continuación, necesitamos crear o Vagrantfile.

A primeira liña define unha variable chamada $install_docker que contén un script Bash para instalar Docker e engadir o usuario vagabundo ao grupo docker:

```Vagrantfile
$install_docker = <<-SCRIPT
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker vagrant
SCRIPT
```

A seguinte liña inicializa un obxecto de configuración Vagrant:

```Vagrantfile
Vagrant.configure("2") do |config|
```

A liña `config.vm.box` especifica a caixa base para usar para a máquina virtual. Neste caso, usa ubuntu/focal64, que está baseado en Ubuntu 20.04:

```Vagrantfile
  config.vm.box = "ubuntu/focal64"
```

O bloque `config.vm.provider` define a configuración do provedor da máquina virtual. Neste caso, configure a asignación de memoria e CPU para a máquina virtual creada por VirtualBox:

```Vagrantfile
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
  end
```

A liña `config.vm.synced_folder` establece unha carpeta sincronizada entre a máquina host e a máquina virtual. Neste caso, o directorio actual da máquina host está montado como `/vagrant` na máquina virtual convidada. Isto permítenos pasar o token para unir o worker ao clúster docker swarm, ademais de poder enviar arquivos con máis comodidade:

```Vagrantfile
  config.vm.synced_folder ".", "/vagrant"
```

O bloque `config.vm.define` crea dúas máquinas virtuais con diferentes enderezos IP nunha rede privada. A primeira máquina virtual defínese como un xestor de Docker Swarm co enderezo IP 192.168.56.10, mentres que a segunda máquina virtual defínese como un traballador de Docker Swarm co enderezo IP 192.168.56.11:

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

Finalmente temos o seguinte Vagrantfile.

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

Para iniciar as máquinas virtuais usaremos `vagrant up`. Para acceder ao nodo xestor podemos facelo a través de ssh co comando `vagrant ssh manager`.