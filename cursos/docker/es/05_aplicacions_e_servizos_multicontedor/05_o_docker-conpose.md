# El Docker-Componer

[docker-compose](https://docs.docker.com/compose/) es una herramienta de Docker diseñada para habilitar la orquestación a nivel de una sola máquina.

El funcionamiento es relativamente sencillo:

- Los diferentes contenedores de la aplicación están organizados en **servicios**.
Se pueden crear **redes privadas** para conectar contenedores de aplicaciones.
- Brinda la capacidad de crear **volúmenes** para brindar persistencia.
- Docker-compose proporciona un DSL que permite expresar estas funcionalidades en un archivo [YAML](https://es.wikipedia.org/wiki/YAML) que luego se interpreta para crear nuestra infraestructura a medida que la configuramos.

> ⚠️ Docker-compose es una herramienta en constante evolución, en menos de año y medio se han publicado tres versiones de su DSL.

> ⚠️ En este curso optamos por la versión 3 que es la más reciente y actualmente estable.

## Actividad 📖

>- ✏️ Instalemos Compose: simplemente siga las instrucciones en este [enlace](https://docs.docker.com/compose/install/#install-compose).
