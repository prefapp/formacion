# Repositorio privado de imaxes: o Docker Registry

Unha das necesidades importantes que se teñen cando se traballa con imaxes é a de dispoñer dun repositorio fiable  no que se poida:

- Probar e xestionar imaxes en desenvolvemento.
- Asegura-la privacidade das imaxes.

> Docker pon á nosa disposición un software especial para que poidamos ter un repositorio privado de imaxes: o [Docker Registry](https://docs.docker.com/registry/).

## Características principais

O docker registry é un software de xestión de imaxes de Docker que:

- Permite o almacenamento de imaxes compatibles con Docker, Kubernetes e Rocket. 
- Ten a capacidade de servir esas imaxes a clientes das principais plataformas de contedores (Docker, Kubernetes, Rocket)
- Pódese conectar contra un almacen de obxectos (AZURE, AWS) un volume en NTFS ou a nosa propia máquina. 
- Ademáis, distribúese como un contedor!!!

## Montando o Docker Registry na nosa máquina

Dado que o propio Docker Registry pode funcionar nun contedor, ninguen nos impide poder montalo na nosa propia máquina. Deste xeito, abonda con facer:

```shell
docker run -d --name meu-rexistro -p 5000:5000 registry:2
```

Para que teñamos un registry montado nun contedor con nome meu-rexistro e que escoita no porto 5000 do localhost.

Agora, poderíamos interactuar con él para subir imaxes e descargalas.

## Subida de imaxes ó registry privado - Tags de imaxes

Para poder subir unha imaxe ó noso registry privado, primeiro temos que indicar a Docker que a imaxe ten un registry diferente do de defecto (que será o Dockerhub).

Para iso, imos empregar [docker-tag](https://docs.docker.com/engine/reference/commandline/tag/). Trátase dunha ferramenta que nos permite producir unha nova imaxe creando unha referencia á outra que se convirte na sua orixe. 

![dockertag](./../_media/03_xestion_de_imaxes_e_contedores/docker_tag.png)

Dende o momento de creación da nova imaxe, mediante tag, xa se pode facer referencia á mesma sen afectar á imaxe orixinal. 

Dado que o nome da imaxe está constituido por segmentos alfanuméricos separados por "**/**" e que se pode, opcionalmente, introducir o registry como primer segmento, podemos almacenar a nosa imaxe de prefapp/debian-formacion no registry privado de xeito sinxelo:

```shell
docker tag prefapp/debian-formacion localhost:5000/prefapp/debian-formacion
```

Neste comando estamos a dicir:

- Crear unha nova imaxe (_**docker tag**_).
- Toma como orixe a imaxe **prefapp/debian-formacion**.
- A nova imaxe terá como nome **localhost:5000/prefapp/debian-formacion**.

O nome a imaxe creada, ten como punto inicial un **hostname**, deste xeito, docker entende que o registry desta imaxe non é o de defecto (o Dockerhub) senón un novo, que corresponde co hostname do noso registry privado. 

Agora podemos "**empurrar**" esa imaxe ó noso registry. 

```shell
docker push localhost:5000/prefapp/debian-formacion
```

Nuns intres teremos a nosa imaxe subida ó registry privado. Agora, podemos borrala do noso docker local sen medo, posto que está xa almacenada no registry privado. 

```shell
docker rmi localhost:5000/prefapp/debian-formacion
```

## Emprego das imaxes do registry privado

Para empregar as imaxes do noso registry privado, abonda con empregar o [docker-pull](https://docs.docker.com/engine/reference/commandline/pull/):

```shell
docker pull localhost:5000/prefapp/debian-formacion
```

Teriamos xa a nosa imaxe en local, descargada dende o registry privado.

> 👀 Non se nos escapan as posibilidades que esto supón para o desenvolvemento. 

> 👀 Basta poñer unha máquina cun registry que esté conectada únicamente á rede local, para que nunha empresa se poidan ter tódolos desenvolvementos controlados e seguros e á total dispoñibilidade dos membros do equipo.
