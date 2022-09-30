# Xestión de volumes

Sabemos que os contedores son efémeros, isto é, unha vez rematado o contedor (cando o proceso que o arrincou finalize) tódolos datos que teñamos no contedor desaparecen. 

Para velo, podemos facer a seguinte práctica:

# 📖 Actividade 1

Arrinquemos un container con run da nosa debian de formación:

```shell
docker run --rm -ti prefapp/debian-formacion bash
```

Agora, actualizamo-las fontes con _**apt-get updat**_e. De seguido instalamo-lo programa curl. 

```shell
apt-get update && apt-get install --yes curl
```

Comprobamos que funciona. 

Salimos do container (a opción _**--rm**_ provocará o seu inmediato borrado).

Se volvemos a lanzar un container co comando de enriba, temos curl? Por que?

# Volumes: a conexión do contedor co sistema de ficheiros do anfitrión

Unha das solucións principais para o problema da falta de persistencia dos contedores é a dos volumes. 

Podemos pensar nun volume como un directorio do noso anfitrión que se "monta" como parte do sistema de ficheiros do contedor. Este directorio pasa a ser accesible por parte do contedor e, os datos almacenados nel, persistirán con independencia do ciclo de vida do contedor.

![Container volume](./../_media/02_docker/contedor_volume.png)

Para acadar isto, abonda con indicarlle a Docker qué directorio do noso anfitrión queremos montar como volume e en qué ruta queremos montalo no noso contedor. 

Nun exemplo:

```shell
docker run --rm -ti -v ~/meu_contedor:/var/datos prefapp/debian-formacion bash
```

Como podemos ver:

- Indicamoslle ó Docker que queremos un contedor interactivo que se autodestrúa  (_**run --rm -ti**_).
- Imos corre-la imaxe _**prefapp/debian**_.
- O comando de entrada é o _**bash**_.
- Montamos un volume: _**-v**_, indicándolle ruta_anfitrion:ruta_contedor _**(~/meu_contedor:/var/datos)**_.

# 📖 Actividade 2

>- ✏️ Probemos este comando. Lanzamos un contedor que cree un volume e, unha vez dentro do contedor, creamos tres ficheiros en /var/datos. 
>- ✏️ Pechamola-sesión do contedor e miramos no directorio do anfitrión, qué ten dentro?
>- ✏️ Volvemos lanzar un contedor co mesmo comando, se vamos a _**/var/datos**_: están os ficheiros? Se están, borramos o /var/datos/a e o /var/datos/b. 
>- ✏️ echamos outra vez a sesión, miramos no directorio do anfitrión, qué ficheiros hai?
