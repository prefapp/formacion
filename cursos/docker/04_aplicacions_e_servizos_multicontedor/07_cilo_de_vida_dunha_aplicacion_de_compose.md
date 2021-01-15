# Ciclo de vida dunha aplicación de compose

O docker-compose é unha ferramenta de liña de comando. 

Para funcionar compre ter definido un docker-compose.yaml que é un ficheiro onde se expresa no [DSL](https://docs.docker.com/compose/compose-file/) de compose unha infraestructura de contedores, redes e volumes.

Unha vez que temos ese ficheiro creado, podemos:

- Lanzar a aplicación ([_**up**_](https://docs.docker.com/compose/reference/up/)).
- Detela e borrala ([_**down**_](https://docs.docker.com/compose/reference/down/)).
- Inspeccionala ([_**ps**_](https://docs.docker.com/compose/reference/ps/) e [_**top**_](https://docs.docker.com/compose/reference/top/)).
- Construí-la súas imaxes ([_**build**_](https://docs.docker.com/compose/reference/build/)).

![Ciclo vida compose](./../_media/04_aplicacions_e_servizos_multicontedor/ciclo_vida_compose.png)

## A estratexia de nomeamento de artefactos en Docker Compose

Como xa sabemos o compose lee o noso ficheiro de docker-compose.yaml e comeza a crear:

- Volumes
- Redes
- Contedores

O problema parece obvio: cómo nomea todos eses artefactos en Docker?

A solución que adopta o docker-compose e crear un nome composto:

![Dominio](./../_media/04_aplicacions_e_servizos_multicontedor/dominio.png)

Dado que cada contedor, volume e rede ten un nome (sexa o do servizo, ou o propio do artefacto) para evitar unha colisión de nomes, o que fai o docker-compose é determinar un dominio por aplicación e engadirlle o nome concreto do artefacto.

O dominio ou nome da app **virá dado polo nome do directorio onde se atope o docker-compose.yaml**.

Deste xeito:  

- Dado _**~/foo/docker-compose.yaml**_.
- Un contedor "**app**" chamarase **foo_app**.
- Unha rede "**privada**" chamarase _**foo_privada**_.

## Actividade 📖

>- ✏️ A partires deste [docker-compose](https://raw.githubusercontent.com/prefapp/saudo-gl/master/docker-compose.yaml) imos:
- Arrincar a app de saudo-gl.
- Comprobar que o contedor que constrúe está a funcionar.
- Detela.
- Borrar o servizo.

>- ✏️ Examinémos o compose:
- Por que baixa unha imaxe? que imaxe é?
- Qué nome lle pon ó contedor? por que?
- Como poderíamos crear unha rede para o contedor?
- Podemos facer un docker-exec nese contedor?
