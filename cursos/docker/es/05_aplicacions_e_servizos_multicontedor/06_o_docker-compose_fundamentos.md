# docker-Compose: conceptos básicos

## Entidades

Dentro de nuestra composición, vamos a definir tres entidades fundamentales:

- **Servicios**: Estas son definiciones de contenedores.
- **Redes**: Definiciones de red que pueden usar los contenedores.
- **Volúmenes**: Un directorio accesible por contenedores.

## Servicios

Esta es una definición de contenedor, en la que se establece:

- La imagen a montar.
- Las variables de entorno.
- El número de réplicas del contenedor a ejecutar.
- Los puertos de conexión.
- Los volúmenes que monta.

Imaginemos que queremos ejecutar nuestro "gatito del día" como un servicio de redacción:


```yml
version: '3'

services:

  gatinhos:
    image: web-gatinhos
    ports:
      - "8000:5000"

volumes: {}

networks: {}
```


Simplemente ejecutamos una composición con un servicio ("gatinhos") que usa la imagen que creamos en el tema 4. También conecta el puerto 5000 del contenedor al puerto 8000 del host.

Si colocamos esas líneas en un archivo docker-compose.yaml y hacemos:

```shell
docker-compose up -d
```

Veremos como se lanza un contenedor con nuestra imagen y como se conecta al puerto 8000 del host.

## Redes

Las [redes en Docker](https://docs.docker.com/network/) son una construcción que permite que los diferentes contenedores pertenecientes se "vean" entre sí sin necesidad de conocer sus IPs.

Imaginemos que tenemos un servicio en PHP que se conecta a otro que ejecuta una bbdd en Mysql.

Si lo ponemos en una red común, el servicio PHP tendrá un host (bbdd) definido **que coincide con el nombre del servicio de bbdd** sin tener que preocuparse por la IP del contenedor.

![Container](../../_media/04_aplicacions_e_servizos_multicontedor/redes.png)

Si lo definimos en un compose:


```yml
version: '3'

services:

  app:
    image: php
    networks:
      - rede-foo

  bbdd:
    image: mysql
    networks:
      - rede-foo
    ports:
      - "8000:5000"

networks:
  rede-foo:
```

Vemos aquí cómo el contenedor de aplicaciones y el contenedor de bbdd están en la misma red: foo-network. Esta red se define en el mismo docker-compose.

Ahora bien, y dado que los dos servicios están en esta red, en un contenedor de aplicaciones se define el host **bbdd** que corresponde a la ip del contenedor del servicio bbdd.

## Volúmenes

Ya hablamos de volúmenes en una lección anterior.

Basta decir aquí que los volúmenes se pueden definir directamente en docker-compose a través del propio DSL de la herramienta.
