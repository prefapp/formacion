# Práctica guiada: Nesquik vs ColaCao

> Baseada neste [exemplo](https://github.com/dockersamples/example-voting-app).

## Explicación do proxecto

Imos crear unha aplicación de voto para saber de qué somos: de Nesquik ou de Cola Cao. O plantexamento é sinxelo:

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

- Worker: (**.Net**) [prefapp/votacion_worker](https://hub.docker.com/r/prefapp/votacion_worker/).
- Votos: (**Python**) [prefapp/votacion_votar](https://hub.docker.com/r/prefapp/votacion_votar/).
- Resultados: (**NodeJS**) [prefapp/votacion_resultados](https://hub.docker.com/r/prefapp/votacion_resultados/).
- Bbdd resultados: (**PostgreSQL**) [postgres:9.4](https://hub.docker.com/_/postgres/).
- Bbdd: (**Redis**) [redis:alpine](https://hub.docker.com/_/redis/).

Para definir a parte de **redes**, quedaría como segue:

```yml
version: '3'

networks:
  rede-privada:
  rede-publica:
```

Vemos que creamos dúas redes, unha pública e outra privada. Na parte de **volumes**, imos a crear un volume que despois asociaremos ó servizo de PostgreSQL:

```yml
version: '3'

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
    port: ["6379"]
    networks:
      - rede-privada

  bbdd:
    image: postgress:9.4
    container_name: bbdd
    valumes:
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

Vemos como se conectan ambos servizos á rede privada. Ademáis, o servizo de bbdd (postgresql) vincula o directorio de datos ó volume creado. Isto otorga persistencia en caso de sucesivos reinicios do sistema. 

Apréciase tamén a exposición do porto de redis [6379] para conexións (sempre dende a rede privada).

Vexamos agora o servizo do **worker**:

```yml
worker:
  image: prefapp/votacion_worker
  depends_on:
    - "redis"
networks:
  - rede-privada
```

O worker tamén está na rede privada. Vemos a etiqueta [**depends_on**](https://docs.docker.com/compose/compose-file/#depends_on) que establece a orde de arranque dos servizos (dos contedores).

Tal e como está expresado nesta liña, o contedor do worker **non se pode iniciar** antes de que o do Redis esté en funcionamento.

Pasamos agora á definición do **servizo de votacións**:

```yml
services:

  votacions:
    image: prefapp/votacions_votar
    command: python app.py
    ports:
      - "8000:80"
    networks:
      - rede-privada
      - rede-publica
```

O servizo de votacións non ten moita sorpresa. Está asociado a ambas redes, a pública e a privada.

Asocia o porto 8000 do host ó porto 80 do contedor para asegurá-la conectividade co exterior.

Por último, imos ver o **servizo de resultados**:

```yml
services:

  resultados:
    image: prefapp/votacions_resultados
    command: nodemon server.js
    ports:
      - "8001:80"
      - "5858:5858"
    networks:
      - rede-privada
      - rede-publica
```

O servizo de resultados tampouco ten moito que comentar. O porto 8001 é o de escoita do servidor e por onde haberá que conectarse para ve-la páxina web coa información.

Escribimos un docker-compose.yaml con toda esa información e facemos:

```shell
docker-compose up -d
```

Et voila!! No [localhost:8000](localhost:8000) teríamos a votación e no [localhost:8001](localhost:8001) teremos os resultados.

Se abrimos duas lapelas, unha por cada parte, e votamos, veremos como cambian os resultados en tempo real e sen necesidade de recargar nada.

## Actividade 📖

>- ✏️ Seguindo os pasos e entendendo o que fan, escribamos o docker-compose.yaml de esta infraestructura e lancémola.
