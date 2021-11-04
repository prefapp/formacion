# Introducción

Ata o de agora vimos como lanzar contedores nun único anfitrión Docker.

Neste tema vamos a ir un paso máis ala, e ver unha opción existente, integrada dentro do propio Docker engine, para lanzar contedores e orquestalos nun cluster de anfitrións Docker (nun conxunto de máquinas que actuan coma se foran unha).

Nin que decir ten que ésta non é a única opción dispoñible\*, xa que este é un tema candente que persigue dar cabida as características demandadas nos entornos de producción (escalabilidade, alta dispoñibilidade, resilencia, elasticidade...). Pero si que é unha das máis empregadas pola súa integración completa dentro de Docker e do seu ecosistema,  permitindo manexar a complexidade que ten un cluster, cas abstraccións que xa coñecemos, o que facilita o seu uso.

*De todas maneiras, [Kubernetes](https://kubernetes.io), a alternativa open-source de Google, estase erixindo nos últimos meses, como o estandard para o orquestación de contedores nun cluster de máquinas*.

# O Docker Swarm

Un conxunto de 2 ou máis máquinas (físicas, virtuais) donde corra o demonio de Docker (docker engine) se poden conectar formando un cluster, de maneira que actuen como un único sistema, agrupando recursos e permitindo despregar un maior número de servicios, escalalos horizontalmente de 1 a N contedores, poñelos en alta dispoñibilidade...

Ata a versión 1.12 de Docker era preciso usar un novo compoñente aparte de Docker Engine, para poñer a funcionar esta característica, pero a partir de esa versión xa ven integrada de serie, o que simplificou enormemente a tarefa de crear un cluster de nodos Docker.

![img](../_media/05_docker_swarm/swarm01.png)

Na imaxen se pode apreciar como se pasou dun complexo proceso de 7 pasos a un novo, onde con 2 sinxelos comandos se logra activar o modo Swarm entre 2 nodos!

Sobra decir que, a pesar das ventaxes, sempre hai certos contras, xa que esta evolución rompeu con moitas asuncións definidas incialmente.

O novo swarm a pesar de ser compatible co anterior, modificaba os conceptos base de traballo (para equipararse a outras plataformas como Kubernetes), e esto xerou gran controversia na comunidade e no ecosistema, e ademais dificultou a súa adopción, xa que os usuarios viron a docker como unha plataforma pouco estable para postularse como opción a instalar en entornos de producción.
