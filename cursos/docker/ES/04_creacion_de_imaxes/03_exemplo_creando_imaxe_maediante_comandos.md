# Exemplo: creando imaxe mediante comandos

> O noso "Hello World"

Imos ilustrar o proceso de creación dunha imaxe a través dun Hello World!, pero á galega.

Animamos ó docente a que probe a facer este exemplo na súa máquina porque será relevante para despoís face-la práctica de final da sección.

Imos construir unha imaxe que conteña unha sinxela aplicación baseada en **apache2** que exporta unha páxina web cun "**Hello Wolrd**" á galega.

O plan de traballo é o seguinte:

1.Partiremos dunha **Debian:Jessie**.
2.Instalaremos un **apache**.
3.Introduciremos unha configuración.
4.Copiaremos o noso **Hello World!!**
5.Probaremo-la nosa imaxe lanzando un container.

## I. Poñendo as cousas en orde

O primeiro que precisamos é a imaxe de Debian que imos a empregar. Ímola descargar dende o Dockerhub:

```shell
docker pull debian:jessie
```

Agora xa temos a imaxe de Debian na nosa máquina local. Podemos empezar a traballar!

Para segui-lo noso ciclo de evolución, imos a empregar o container **saudo-container**, e a imaxe a producir vaise chamar **saudo-galego**.

## II. Instalando Apache2

Compre que instalemos o apache2 no noso container e que despois fagamos un commit dos cambios á nosa imaxe. Nun esquema:

![Pasos](./../_media/01_creacion_de_imaxes/imaxe_paso_1.png)

Arrincamos un container para face-lo traballo de instalar o **apache2**:

- O container vai ter o nome **saudo-container**.
- Ten que estar en modo *interactivo* para poder empregalo e que, unha vez que saigamos do container, este último quede *detido*. 
- Ademáis, queremos que o **punto de entrada** ó container sexa o bash.

```shell
docker run --name saudo-container -ti debian:jessie bash
```

Unha vez executado, estaremos dentro do container, e facemo-lo noso traballo:

- Actualizamos fontes de software

```shell
apt-get update
```

- Instalamos o apache

```shell
apt-get install apache2
```

Limpiamos as fontes:

```shell
rm -r /var/lib/apt/lists/*
```

Agora temo-lo noso container co estado que queremos. Salimos mediante **exit** ou **CTRL+D**.

Xa na máquina anfitrión, facemo-lo **commit** á nova imaxe.

```shell
docker commit saudo-container saudo-galego
```

Temos unha nova imaxe co noso software instalado.

Podemos prescindir do container saudo-container posto que os cambios xa están na nova imaxe. Borrámolo:

```shell
docker rm -v saudo-container
```

## III. Clonando o repo do Saudo Galego

Coa base que temos do paso anterior, imos arrincar de novo un container (xa baseado a nosa imaxe) e face-las seguintes tarefas:

1. Instalar o git como VCS.
2. Clonar o repo da páxina de saúdo.
3. Face-lo commit á imaxe.

Nun esquema, quedaría:

![Pasos](./../_media/01_creacion_de_imaxes/imaxe_paso_2.png)

Para comezar, arrincamos un novo container baseado na imaxe de saudo-galego que xa producimos no paso anterior:

- O container se chamará tamén **saudo-container**.
- Necesitamos que sexa interactivo para poder traballar dentro do container.
- O comando a lanzar é o bash.

Na nosa máquina, tecleamos:

```shell
docker run -ti --name saudo-container saudo-galego bash
```

Imos empregar o software de [Git](https://git-scm.com/) polo que instalamos o paquete:

```shell
apt-get install -y git
```

Agora clonamos o repo do proxecto saudo-gl nunha ruta do noso container:

```shell
cd /opt  && git clone https://github.com/prefapp/saudo-gl.git
```

Xa estamos dentro dun container baseado na imaxe do paso anterior. Polo tanto ten xa instalado un Apache2. O Apache2, por defecto, sirve os contidos dende _**/var/www/html**_.

Movémonos a esa ruta:

```shell
cd /var/www/html
```

E copiamos os contidos do proxecto saudo-gl na ruta onde o Apache2 serve ficheiros:

```shell
cp -r /opt/saudo-gl/* . 
```

Et voilà! Saimos do container con **exit** ou **CTRL+D** e facemos un commit dos novos cambios á nosa imaxe:

```shell
docker commit saudo-container saudo-galego
```

Coma sempre, borramos o container de traballo porque non o precisamos máis. É listo!

O proceso completo quedaría como segue:

![Pasos](./../_media/01_creacion_de_imaxes/imaxe_pasos.png)

## IV. Empregando a imaxe de saudo-galego

Para lanzar un container coa nosa aplicación, basta lembrar dúas cousas:

- Compre establecer o **entrypoint** declarando que debe ser arrinca-lo **Apache2**.
- É convinte asociarlle un porto diferente do 80 para evitar colisións con outros servicios que o docente poida ter levantados na súa máquina.

Introducindo isto na nosa máquina:

```shell
docker run --rm -p 8000:80 -d saudo-galego apachectl -DFOREGROUND
```
Teríamos un container correndo coa nosa imaxe preparada e escoitando no porto 8000. Se vamos ó noso navegador e introducimos [http://localhost:8000](http://localhost:8000) a aplicación nos saludará.
