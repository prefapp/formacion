# Práctica guiada: Perros vs Gatos

> Baseada neste [exemplo](https://github.com/dockersamples/example-voting-app).

## Explicación do proxecto

Imos crear unha aplicación de voto para saber de qué somos: de Perros ou de Gatos. O plantexamento é sinxelo:

Trátase dunha aplicación que ten dúas partes:

1.  Un panel web onde votamo-la nosa opción.
2. Outro panel web onde vemos os resultados.

## Servizos

### 1. Votación

A aplicación de votacións está escrita en python con [Flask](https://flask.palletsprojects.com/en/1.1.x/) (sí como a do "gatiño do día").

Esta aplicación expón un porto ó exterior por onde acepta peticións (porto 80).

![Servizos python](./../_media/04_aplicacions_e_servizos_multicontedor/servizos-python.png)

Cando alguén vota, apunta o senso do voto nunha base de datos [Redis](https://redis.io/) (que escoita dentro do contedor no 6379).

![Servizos python redis](./../_media/04_aplicacions_e_servizos_multicontedor/servizos-python-redis.png)

### 2. Worker

O worker é un servizo (nun contedor claro) que escoita mensaxes no redis e agrega eses resultados parciais ó resultado final. 

Os resultados fináis atópanse nunha base de datos [PostgreSQL](https://www.postgresql.org/). 

O worker está escrito en [.NET](https://dotnet.microsoft.com/).

![Postgresql](./../_media/04_aplicacions_e_servizos_multicontedor/net_postgresql.png)

### 3. Servizo de resultados

O servizo de resultados está feito en nodejs. Este servizo expón (no porto 80) unha páxina en HTML5 e monitoriza constantemente a base de datos PostgreSQL para devolver o estado actual da enquisa.

![Node](./../_media/04_aplicacions_e_servizos_multicontedor/node.png)

### 4. Esquema final dos servizos

O esquema final dos servizos quedaría como segue:

![Final](./../_media/04_aplicacions_e_servizos_multicontedor/final.png)

## Redes

Vendo o esquema de servizos, parece claro que debería haber dúas redes:

- Unha **privada** onde estén conectados tódolos contedores para comunicarse entre sí.
- Unha **pública** onde teñan conectividade EXCLUSIVAMENTE os contedores de frontend (o de votacións e o de resultados).

![Redes](./../_media/04_aplicacions_e_servizos_multicontedor/redes_redes.png)

Deste xeito, os contedores de BBDD e o worker están illados do mundo exterior, é dicir, únicamente os contedores que estén na súa rede (privada) poden falar con eles.

Polo contrario, os contedores de votación e resultados, que expoñen páxinas web, están conectados a ambas redes para poder face-lo traballo de mediación entre o backend e o fronted da nosa aplicación.

## Volumes: persistencia

Para esta práctica guiada, imos dar persistencia á parte de resultados finais. Isto é, ós datos que están almacenados no PostgreSQL.

## O docker-compose

Imos agora expresar toda esta infraestructura no DSL de docker-compose. 

As imaxes a empregar serán:

- Worker: (**.Net**) [dockersamples/examplevotingapp_worker](https://hub.docker.com/r/dockersamples/examplevotingapp_worker).
- Votos: (**Python**) [dockersamples/examplevotingapp_vote](https://hub.docker.com/r/dockersamples/examplevotingapp_vote).
- Resultados: (**NodeJS**) [dockersamples/examplevotingapp_result](https://hub.docker.com/r/dockersamples/examplevotingapp_result).
- Bbdd resultados: (**PostgreSQL**) [postgres:15-alpine](https://hub.docker.com/_/postgres/).
- Bbdd: (**Redis**) [redis:alpine](https://hub.docker.com/_/redis/).

Para definir a parte de **redes**, quedaría como segue:

```yml
networks:
  rede-privada:
  rede-publica:
```

Vemos que creamos dúas redes, unha pública e outra privada. Na parte de **volumes**, imos a crear un volume que despois asociaremos ó servizo de PostgreSQL:

```yml
volumes:
  bbdd-datos:

networks:
  rede-privada:
  rede-publica:
```

Pasemos á definición dos **servizos**, comezamos cos de bbdd:

```yml
services:

  redis:
    image: redis:alpine
    container_name: redis
    networks:
      - rede-privada

  db:
    image: postgres:15-alpine
    container_name: db
    volumes:
      - "bbdd-datos:/var/lib/postgresql/data"
    networks:
      - rede-privada
```

Hai que engadir tamen as variables para a configuración do usuario e contraseña de postgres:


```yml
environment:
  POSTGRES_USER: "postgres"
  POSTGRES_PASSWORD: "postgres"
```

Vemos como se conectan ambos servizos á rede privada. Ademáis, o servizo de db (postgresql) vincula o directorio de datos ó volume creado. Isto otorga persistencia en caso de sucesivos reinicios do sistema. 

Vexamos agora o servizo do **worker**:

```yml
worker:
  image: dockersamples/examplevotingapp_worker
  container_name: worker
  depends_on:
    - redis
    - db
networks:
  - rede-privada
```

O worker tamén está na rede privada. Vemos a etiqueta [**depends_on**](https://docs.docker.com/compose/compose-file/#depends_on) que establece a orde de arranque dos servizos (dos contedores).

Tal e como está expresado nesta liña, o contedor do worker **non se pode iniciar** antes de que o do redis e o de db estén en funcionamento.

Pasamos agora á definición do **servizo de votacións**:

```yml
services:

  votacions:
    image: dockersamples/examplevotingapp_vote
    container_name: votos
    depends_on:
      - redis
    ports:
      - "8080:80"
    networks:
      - rede-privada
      - rede-publica
```

O servizo de votacións non ten moita sorpresa. Está asociado a ambas redes, a pública e a privada.

Asocia o porto 8080 do host ó porto 80 do contedor para asegurá-la conectividade co exterior.

Por último, imos ver o **servizo de resultados**:

```yml
services:

  resultados:
    image: dockersamples/examplevotingapp_result
    container_name: resultados
    ports:
      - "8081:80"
    networks:
      - rede-privada
      - rede-publica
```

O servizo de resultados tampouco ten moito que comentar. O porto 8081 é o de escoita do servidor e por onde haberá que conectarse para ve-la páxina web coa información.

Escribimos un docker-compose.yaml con toda esa información e facemos:

```shell
docker-compose up -d
```

Et voila!! No [localhost:8080](localhost:8080) teríamos a votación e no [localhost:8081](localhost:8081) teremos os resultados.

Se abrimos duas lapelas, unha por cada parte, e votamos, veremos como cambian os resultados en tempo real e sen necesidade de recargar nada.

## Actividade 📖

>- ✏️ Seguindo os pasos e entendendo o que fan, escribamos o docker-compose.yaml de esta infraestructura e lancémola.
