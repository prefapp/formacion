# Práctica guiada: Nesquik vs ColaCao

> Basado en este [ejemplo](https://github.com/dockersamples/example-voting-app).

## Explicación del proyecto

Creemos una aplicación de votación para saber a cuál pertenecemos: Nesquik o Cola Cao. El enfoque es simple:

Esta es una aplicación que tiene dos partes:

1. Un panel web donde votamos nuestra opción.
2. Otro web panel donde vemos los resultados.

## Servicios

### 1. Votación

La aplicación de encuestas está escrita en python con [Flask](https://flask.palletsprojects.com/en/1.1.x/) (sí, el "gatiño do día").

Esta aplicación expone un puerto al exterior donde acepta solicitudes (puerto 80).

![Servizos python](../../_media/04_aplicacions_e_servizos_multicontedor/servizos-python.png)

Cuando alguien vota, apunta el sentido del voto a una base de datos [Redis](https://redis.io/) (que escucha dentro del contenedor #6379).

![Servizos python redis](../../_media/04_aplicacions_e_servizos_multicontedor/servizos-python-redis.png)

### 2. worker

El worker es un servicio (en un contenedor transparente) que escucha mensajes en redis y agrega esos resultados parciales al resultado final.

Los resultados finales están en una base de datos [PostgreSQL](https://www.postgresql.org/).

El worker está escrito en [.NET](https://dotnet.microsoft.com/).

![Postgresql](../../_media/04_aplicacions_e_servizos_multicontedor/net_postgresql.png)

### 3. Servicio de resultados

El servicio de resultados se realiza en nodejs. Este servicio expone (en el puerto 80) una página en HTML5 y monitorea constantemente la base de datos de PostgreSQL para devolver el estado actual de la encuesta.

![Node](../../_media/04_aplicacions_e_servizos_multicontedor/node.png)

### 4. Esquema final de servicios

El esquema final de servicios sería el siguiente:

![Final](../../_media/04_aplicacions_e_servizos_multicontedor/final.png)

## Redes

Mirando el diagrama de servicio, parece claro que debería haber dos redes:

- Un **privado** donde todos los contenedores están conectados para comunicarse entre sí.
- Un **público** donde EXCLUSIVAMENTE los contenedores frontend (votación y resultados) tienen conectividad.

![Redes](../../_media/04_aplicacions_e_servizos_multicontedor/redes_redes.png)

De esta forma, los contenedores BBDD y el worker quedan aislados del mundo exterior, es decir, solo los contenedores que están en su red (privada) pueden hablar con ellos.

Por el contrario, los contenedores de votaciones y resultados, que exponen páginas web, están conectados a ambas redes para poder mediar entre el backend y el frontend de nuestra aplicación.

## Volúmenes: persistencia

Para esta práctica guiada, vamos a darle persistencia a la parte de resultados finales. Es decir, a los datos que se almacenan en PostgreSQL.

## El docker-compose

Expresemos ahora toda esta infraestructura en el DSL docker-compose.

Las imágenes a utilizar serán:

- Worker: (**.Net**) [prefapp/votacion_worker](https://hub.docker.com/r/prefapp/votacion_worker/).
- Votos: (**Python**) [prefapp/votacion_votar](https://hub.docker.com/r/prefapp/votacion_votar/).
- Resultados: (**NodeJS**) [prefapp/votacion_resultados](https://hub.docker.com/r/prefapp/votacion_resultados/).
- Bbdd resultados: (**PostgreSQL**) [postgres:9.4](https://hub.docker.com/_/postgres/).
- Bbdd: (**Redis**) [redis:alpine](https://hub.docker.com/_/redis/).

Para definir la parte de **redes**, se vería así:

```yml
version: '3'

networks:
  rede-privada:
  rede-publica:
```

Vemos que hemos creado dos redes, una pública y otra privada. En la parte de **volúmenes**, vamos a crear un volumen que luego asociaremos con el servicio de PostgreSQL:

```yml
version: '3'

volumes:
  bbdd-datos:

networks:
  rede-privada:
  rede-publica:
```

Pasemos a la definición de **servicios**, comenzando con bbdd:

```yml
services:

  redis:
    image: redis:alpine
    container_name: redis
    port:
      - "6379"
    networks:
      - rede-privada

  bbdd:
    image: postgres:9.4
    container_name: bbdd
    volumes:
      - "bbdd-datos:/var/lib/postgresql/data"
    networks:
      - rede-privada
```

También debe agregar las variables para la configuración de usuario y contraseña de postgres:


```yml
environment:
  POSTGRES_USER: "postgres"
  POSTGRES_PASSWORD: "postgres"
```

Vemos como ambos servicios se conectan a la red privada. Además, el servicio bbdd (postgresql) vincula el directorio de datos al volumen creado. Esto proporciona persistencia en los sucesivos reinicios del sistema.

También se agradece exponer el puerto redis [6379] para conexiones (siempre desde la red privada).

Ahora veamos el servicio del **worker**:

```yml
worker:
  image: prefapp/votacion_worker
  depends_on:
    - "redis"
networks:
  - rede-privada
```

El worker también está en la red privada. Vemos la etiqueta [**depends_on**](https://docs.docker.com/compose/compose-file/#depends_on) que establece el orden de inicio de los servicios (contenedores).

Como se indica en esta línea, el contenedor de workeres **no se puede iniciar** antes de que se ejecute el contenedor de Redis.

Pasamos ahora a la definición del **servicio de votación**:


```yml
services:

  votacions:
    image: prefapp/votacion_votar
    command: python app.py
    ports:
      - "8000:80"
    networks:
      - rede-privada
      - rede-publica
```

El servicio de votación no tiene mucha sorpresa. Se asocia tanto a redes públicas como privadas.

Asocie el puerto 8000 del host al puerto 80 del contenedor para garantizar la conectividad con el exterior.

Finalmente, veamos el **servicio de resultados**:

```yml
services:

  resultados:
    image: prefapp/votacion_resultados
    command: nodemon server.js
    ports:
      - "8001:80"
      - "5858:5858"
    networks:
      - rede-privada
      - rede-publica
```

El servicio de resultados tampoco tiene mucho que comentar. El puerto 8001 es el puerto de escucha del servidor y donde tendrás que conectarte para ver la página web con la información.

Escribimos un docker-compose.yaml con toda esa información y hacemos:

```shell
docker-compose up -d
```

¡¡Y voilá!! En [localhost:8000](localhost:8000) tendríamos la votación y en [localhost:8001](localhost:8001) tendríamos los resultados.

Si abrimos dos pestañas, una para cada lado, y votamos, veremos cómo cambian los resultados en tiempo real y sin necesidad de recargar nada.

## Actividad 📖

>- ✏️ Siguiendo los pasos y entendiendo lo que hacen, escribamos el docker-compose.yaml de esta infraestructura y ejecútelo.
