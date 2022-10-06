# Ciclo de vida de una aplicación compuesta

docker-compose es una herramienta de línea de comandos.

Para funcionar, debe tener definido un docker-compose.yaml que es un archivo donde se expresa en el [DSL](https://docs.docker.com/compose/compose-file/) de compose con una infraestructura de contenedores, redes y volúmenes.

Una vez que tenemos ese archivo creado, podemos:

- Inicie la aplicación ([_**up**_](https://docs.docker.com/compose/reference/up/)).
- Deténgalo y elimínelo ([_**down**_](https://docs.docker.com/compose/reference/down/)).
- Inspecciónelo  ([_**ps**_](https://docs.docker.com/compose/reference/ps/)  y  [_**top**_](https://docs.docker.com/compose/reference/top/)).
- Cree sus imágenes ([_**build**_](https://docs.docker.com/compose/reference/build/)).

![Ciclo vida compose](./../_media/04_aplicacions_e_servizos_multicontedor/ciclo_vida_compose.png)

## La estrategia de nomenclatura de artefactos en Docker Compose

Como ya sabemos, compose lee nuestro archivo docker-compose.yaml y comienza a compilar:

- Volúmenes
- Redes
- Contenedores

El problema parece obvio: ¿cómo se nombran todos esos artefactos en Docker?

La solución que toma docker-compose y crea un nombre compuesto:

![Dominio](./../_media/04_aplicacions_e_servizos_multicontedor/dominio.png)

Dado que cada contenedor, volumen y red tiene un nombre (ya sea el nombre del servicio o el nombre del artefacto) para evitar una colisión de nombres, lo que hace docker-compose es determinar un dominio por aplicación y agregarle el nombre del artefacto específico.

El dominio o nombre de la app **lo dará el nombre del directorio donde se encuentra docker-compose.yaml**.

De este modo:

- Dado _**~/foo/docker-compose.yaml**_.
- Un contenedor "**app**" se llamará **foo_app**.
- Una red "**privada**" se llamará _**foo_private**_.

## Actividad 📖

>- ✏️ A partir de este [docker-compose](https://raw.githubusercontent.com/prefapp/saudo-gl/master/docker-compose.yaml) vamos:
- Inicie la aplicación saudo-gl.
- Verifique que el contenedor que construya esté funcionando.
- Para.
- Eliminar el servicio.

>- ✏️ Examinemos la composición:
- ¿Por qué descargar una imagen? ¿qué imagen es?
- ¿Qué nombre le das al contenedor? ¿por qué?
- ¿Cómo podríamos crear una red para el contenedor?
- ¿Podemos hacer un docker-exec en ese contenedor?
