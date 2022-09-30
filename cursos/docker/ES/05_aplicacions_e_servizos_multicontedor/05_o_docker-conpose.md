# O Docker-Compose

O [docker-compose](https://docs.docker.com/compose/) é unha ferramenta de Docker deseñada para permitir unha orquestración a nivel dunha soa máquina. 

O funcionamento é relativamete sinxelo:

- Os distintos containers da aplicación organízanse en **servizos**.
Pódense crear **redes privadas** para conecta-los containers da aplicación.
- Aporta a posibilidad de crear **volumes** para aportar persistencia.
- O docker-compose aporta unha DSL que permite expresar estas funcionalidades nun ficheiro de [YAML](https://en.wikipedia.org/wiki/YAML) que despois interpreta para crear a nosa infraestructura tal e como a establezcamos.

> ⚠️ O docker-compose é unha ferramenta en constante evolución, en menos dun ano e medio teñense publicadas tres versións da súa DSL.

> ⚠️ Neste curso nos decantamos pola versión 3 que é a máis recente e a estable actualmente.

## Actividade 📖

>- ✏️ Imos instala-lo compose: basta seguir as instruccións deste [link](https://docs.docker.com/compose/install/#install-compose).
