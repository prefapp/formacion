# Introducción

# A problemática da orquestración de contedores

> Nos últimos anos, as tecnoloxías de contedores están provocando un cambio disruptivo na maneira na que as organizacións construen, evolucionan e despregan aplicacións.

As plataformas de contedores, fundamentalmente [Docker](https://docker.com/), están sendo usadas para empaquetar aplicacións de xeito que teñan acceso controlado, a un determinado grupo de recursos do sistema operativo que corre nunha máquina  física ou virtual.

Se ademáis nos imos a [arquitecturas de microservicios](https://es.wikipedia.org/wiki/Arquitectura_de_microservicios), onde as aplicacións son troceadas en multiples pequenos servicios que se comunican entre eles, o axeitado e empaquetar cada un no seu correspondente contedor.

Os beneficios, especialmente para as organizacións que empregan prácticas de integración e despregue continuos (CI/CD) se basean en que os contedores son escalables e efímeros, as instancias das aplicacións ou servicios, correndo sobre esos contedores, van e veñen segundo se necesite (para executar os test, lanzar un novo entorno para o desenvoledor, actualizar a versión da aplicación en producción, escalar...).

E esto, levado a escala,  é un gran desafio. Se empregamos 8 contedores para aloxar 4 aplicacións,  a tarefa de desplegar e manter os nosos contedores se pode manexar de xeito manual.  Se pola contra contamos con 2000 contedores e 400 servizos que xestionar, a tarefas de manexalos de xeito manual vólvese realmente dificil.

A orquestración de contedores consiste en **automatizar o despregue**, **manexo**, **escalado**, **conectividade** e **dispoñibilidade dos contedores** que aloxan as nosas aplicacións.
