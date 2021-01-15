# O Docker-Compose: fundamentos

## Entidades 

Dentro do noso compose, imos definir tres entidades fundamentais:

- **Servizos**: trátase de definicións de contedores.
- **Redes**: definicións de rede que poden ser empregados polos contedores.
- **Volumes**: un directorio accesible polos contedores.

## Servizos

Trátase dunha definición de contedor, no que se establece:

- A imaxe a montar.
- As variables de entorno.
- O número de réplicas do contedor a correr.
- Os portos de conexión.
- Os volumes que monta.

Imaxinemos que queremos correr o noso "gatiño do día" como un servizo dun compose:

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

Simplemente corremos un compose cun servizo ("gatinhos") que emprega a imaxe que fixeramos no tema 4. Ademáis conecta o porto 5000 do contedor co 8000 do host. 

Se metemos esas liñas nun ficheiro docker-compose.yaml, e facemos:

```shell
docker-compose up -d
```

Veremos como se lanza un contedor coa nosa imaxe e como está conectada ó porto 8000 do host.

## Redes

As [redes en Docker](https://docs.docker.com/network/) son unha construcción que permite que os distintos contedores pertencentes se "vexan" uns ós outros sen necesidade de coñece-las súas IPs.

Imaxinemos que temos un servizo en PHP que se conecta a outro que corre unha bbdd en Mysql.

Se o metemos nunha rede común, o servizo de PHP vai a ter definido un host (bbdd) **que coincide co nome do servizo de bbdd** sen ter que preocuparse da IP do contedor.

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/redes.png)

Se o definimos nun compose:

```yml
version: '3'

services:

  app:
    image: php
    network:
      - rede-foo

  bbdd:
    image: mysql
    network:
      - rede-foo
    ports:
      - "8000:5000"

networks:
  rede-foo:
```

Vemos aquí como o contedor de app e o de bbdd están na mesma rede: a rede-foo. Esta rede atópase definida no mesmo docker-compose. 

Agora, e dado que os dous servizos están nesta rede, nun contedor de app existe definido o host **bbdd** que corresponde á ip do contedor do servizo bbdd.

## Volumes

Xa falamos dos volumes nunha lección anterior.

Baste dicir aquí que os volumes poden ser directamente definidos no docker-compose  a través da propia DSL da ferramenta.
