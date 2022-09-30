# Xestión da rede

Por defecto os contedores Docker poden acceder ó exterior (teñen conectividade, dependendo sempre da máquina anfitriona)

Nembargantes, o contedor está aillado con respecto a entrada de datos. É decir, por defecto, e coa excepción do comando exec, o contedor constitúe unha unidad aillada á que non se pode acceder. 

Por suposto, compre poder acceder ós contedores para poder interactuar dalgún xeito con eles. 

A regra básica aquí é: salvo que se estableza o contrario, **todo está pechado ó mundo exterior**. 

Nesta sección imos aprender cómo resolve Docker o problema de dar conectividade ós contedores. 

## Portos do contedor

Un contedor está dentro do seu namespace de rede polo que pode establecer regras específicas sen afectar ó resto do sistema. 

Deste xeito, e sempre dende o punto de vista do contedor, podemos establecer as regras que queiramos e conectar o que desexemos ós 65535 do contedor sen temor a colisións doutros servizos. 

Así, poderíamos ter un contedor cun apache conectado ó porto 80:

![Container porto](./../_media/02_docker/contedor_porto.png)

Ou poderíamos ter varios contedores con servizos apache conectados ó porto 80:

![Containers porto](./../_media/02_docker/contedores_porto.png)

Dado que cada un deles ten o seu propio namespace de rede, non habería ningún problema de colisión entre servizos conectados ó mesmo porto en contedores diferentes. 

> ⚠️  Por suposto, se dentro dun mesmo contedor poñemos dous servizos á escoita no mesmo porto, producirase un erro de rede.

O problema é que, pese a ter esta liberdade dentro do contedor, aínda precisamos conecta-lo extremo do contedor cun porto da máquina anfitriona para que as conexións externas poidan chega-lo noso contedor. Por sorte, ese traballo vaínolo facilitar moito Docker. 

## Conectar portos de docker ó exterior

Tal e como viramos na sección anterior, dentro dun contedor dispoñemos de todo o stack de rede para facer o que queiramos. 

Nembargantes, con iso non é suficiente para que o se poida chegar ó noso contedor dende o mundo exterior. Así:

![Container conexión](./../_media/02_docker/contedor_conexion_0.png)

Como vemos, o noso contedor está aillado do mundo exterior, por moito que o apache esté presente e conectado ó porto 80 dentro do contedor. 

Imos probar a arrincar unha imaxe que temos preparada para este curso:

- Está baseada en debian:8
- Ten instalado o apache2
- O proceso de arranque consiste en poñer a escoitar o apache no porto 80

```shell
docker run -d --name apache-probas prefapp/apache-formacion
```

Se facemos agora un _**docker ps**_, verémo-lo noso contedor funcionado. O problema: non podemos chegar de ningunha forma ó servizo de apache que corre escoitando no porto 80, porque o noso contedor non ten conectividade co exterior. 

O único xeito para poder conectarse ó apache, é entrar no contedor:

```shell
docker exec -ti apache-probas /bin/bash
```

E dende dentro do mesmo, xa poderíamos facer, por exemplo un curl ó porto 80:

```shell
root@378cc9f54153:/# curl localhost:80
```

E obteríamos unha resposta axeitada do apache. 

Docker permítenos conectar os portos do contedor con portos do anfitrión de tal xeito que este último sexa accesible dende fora. 

Imos borra-lo noso container:

```shell
docker rm -f -v apache-probas
```

E redesplegalo cunha nova opción:

```shell
docker run -d -p 9090:80 --name apache-probas prefapp/apache-formacion
```

Como vemos, a novidade aquí é o *(-p 9090:80)*:

- Estalle a dicir ó Docker que precisa conectar un porto do anfitrión cun do container.
- O porto 9090 corresponde cun porto do anfitrión.
- O porto 80 é o de dentro do contedor (onde escoita o noso apache)
Nun diagrama:

![Container conexión](./../_media/02_docker/contedor_conexion_1.png)

Agora o porto 80 do noso contedor está conectado ó porto 9090 da máquina anfitriona. Podemos, por tanto, chegar ó apache que corre dentro sen problema dende o exterior:

```shell
curl localhost:9090
```
> ⚠️ O porto do anfitrión é totalmente controlable mediante reglas de iptables ou de firewall para determinar a súa accesibilidade dende o exterior.

>> Aínda que teñamos liberdade nos portos dentro do contedor, os portos do anfitrión son un recurso limitado e de uso alternativo. Isto é, non se pode asignar o mesmo porto a varios portos de contedor. Isto supón un problema de xestión a resolver por parte das ferramentas de orquestración, obxecto do tema 6 do presente curso.
