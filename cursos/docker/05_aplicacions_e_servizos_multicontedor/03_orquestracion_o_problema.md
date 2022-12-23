# Orquestración: o problema

## O paradigma da conterización

A estas alturas do curso xa imos comprendendo porqué os containers son un cambio de paradigma no mundo dos sistemas, comparable ó que foi o da virtualización de máquinas.

- Gracias ós containers podemos illar un proceso e as súas dependencias nunha unidade que se pode arrancar/parar en cuestión de segundos.
- O custo da containerización en termos de CPU/Memoria é totalmente insignificante.
- Podemos expresar cómo se constrúe unha imaxe en código (Dockerfile) o que presenta importantísimas [vantaxes](https://en.wikipedia.org/wiki/Infrastructure_as_code).
- A posibilidade de crear infraestructuras baseadas en micro-servicios ábrese para todo o mundo.

Como vemos, a idea é a de romper o noso sistema en unidades funcionais pequenas e manexables que se comunican entre elas para facer un traballo máis grande.

Un simil ó que se recorre moitas veces é ó da programación orientada a obxectos:

- Igual que na [POO](https://gl.wikipedia.org/wiki/Programaci%C3%B3n_orientada_a_obxectos) temos clases e instancias, na conterización temos imaxes e obxectos. 
- A idea clave é encapsular funcionalidades en unidades independientes que falan entre sí mediante paso de mensaxes. 
- A evolución do sistema faise mediante a extensión/creación de novas clases e obxectos non mediante a modificación dos existentes. 

Polo tanto, a conterización introduce un novo paradigma de diseño de aplicacións e infraestructuras no que:

- O sistema se fragmenta en unidades moi pequenas, sendo o bloque mínimo de construcción **o contedor**.
- Cada unidade ten unha funcionalidade concreta e ben definida ([Separación de intereses](https://en.wikipedia.org/wiki/Separation_of_concerns)).
- Acadando esta modularidade, as diferentes partes pódense ver como **microservicios** que expoñen una interface clara para comunicarse e que traballan conxuntamente para asegura-lo cumprimento dos obxectivos do sistema como entidade. 
- Ademáis as nosas aplicación son por fin **escalables horizontalmente**, engandindo novas instancias (containers) podemos aumenta-la potencia da nosa aplicación sen necesidade de recurrir á gaiola do **escalado vertical**.

## O problema do paradigma de orquestración

Vale, agora temos claro que hai que romper todo en unidades pequenas que se comunican entre sí. Pero, cómo facemos iso?

Imos comenzar conha simple aplicación en Php dentro dun container:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/container_standalonoe.png)

A nosa aplicación quere ter **estado**. A solución obvia é agregar unha base de datos dentro do container:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/mega_container.png)

Isto, a pesar de qué sería unha solución obvia, é un horror e unha ruptura do paradigma da containerización:

- O container non ten unha única preocupación, ten dúas (xestión de bbdd e aplicación en Php).
- O cambio na bbdd ou na aplicación implica cambiar o resto de unidades.
- Introducimos dependencias do software de Mysql con respectoSeparación de intereses ó Php e viceversa.

O problema sería peor se queremos, por exemplo, engadir soporte para SSL, un servidor web, soporte para métricas e logs.... O noso container crecería e crecería, polo que non amañariamos ningún dos problemas que queremos resolver o por enriba perderíamos as vantaxes da containerización. 

A solución axeitada sería esta:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/container_bbdd.png)

Agora temos dúas unidades independentes en dous containers. Podemos modificar unha sen afecta-la outra. As preocupacións están correctamente separadas. 

Neste momento, os nosos containers poden ademáis **escalar**, basta con engadir novos containers de aplicación se é necesario:

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/escalado_container.png)

E, por suposto, podemos engadir os servicios auxiliares que creamos convintes, sen necesidade de modifica-los containers que xa temos (**encapsulación**).

![Container](./../_media/04_aplicacions_e_servizos_multicontedor/escalado_funcional.png)

Como podemos ver, a nosa aplicación **crece engandindo novas unidades funcionais**, **non modificando as existentes**. Esto aporta as vantaxes das que xa falaramos na sección previa.

Pero, xorden preguntas:

- Cómo coñece o noso container de Php a dirección e o porto no que escoita o Mysql?
- Cómo facemos para parar/arrincar todos os containers de vez?
- Se un container cae e o levantalo cambiou de Ip cómo o sabe o resto?
- Cómo inxectamos configuracións comúns a tódolos containers?

> A estas e outras moitas preguntas trata de dar resposta **a orquestración de containers**.