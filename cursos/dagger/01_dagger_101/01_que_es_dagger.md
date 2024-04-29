# ¿Qué es dagger?

![Intro1](./../_media/01/intro1.svg)

Dagger es un herramienta que permite crear y correr funciones dentro de containers con el propósito principal de integrar y desplegar código. 

Gracias a su particular diseño y al empleo de buildkit permite el empleo de contenedores por cada función de nuestro workflow. 

En palabras de su creador: ```Dagger es el primer motor de containerización de funciones```.

## ¿Por qué usar dagger?

### La filosofía

Dagger parte de una filosofía clara:

1. La construcción y testeo de software es un proceso "íntimo" al propio desarrollo y debe acompañarlo en todas sus fases. 
2. El proceso debe poder expresarse en lenguajes conocidos (Go, NodeJS, Python...) y ser ejecutable en **cualquier** entorno (incluido el local). 
3. La ejecución de nuestro proceso de dagger, por su naturaleza repetitiva, debe ser rápida, evitando realizar pasos innecesarios y solo revisitando aquellos que sean necesarios. 
4. La construcción de nuestro proceso debería poderse beneficiar de piezas o módulos públicas o privadas puestas a nuestra disposición por la comunidad y/o terceros.

Partiendo de esta filosofía, dagger ha sido construido de manera que:

- Puede correr en todos los sitios (1) (2) exactamente igual que los contenedores de software. 
- La ejecución crea un (DAG)[https://en.wikipedia.org/wiki/Directed_acyclic_graph] (grafo acíclico directo) para poder cachear todos y cada uno de los pasos y evitar volverlos a realizar en sucesivas iteraciones (salvo que sea necesario).
- Puede expresarse en los principales lenguajes de programación y beneficiarse de cualquier librería o módulo que tengamos a nuestra disposición en el stack elegido. 
- Permite el empleo de módulos y funciones de terceros (daggerverse) de manera eficiente y sin preocuparnos del lenguaje en que estén expresados. 

Estos principios de construcción se destilan en una herramienta con la que implimentar una clara *estrategia de plataforma*. 

### La estrategia

Cuando el equipo de plataforma se enfrenta a gestionar los ciclos de construcción y despliegue del software de una organización se encuentra con el siguiente **dilema**:


1. **Ansia de control**: la tentación de controlar de manera férrea los ciclos de integración y despliegue está justificada: a mayor control, mayor facilidad y seguridad en el trabajo de plataforma. 
2. **Necesidad de flexibilidad**: no obstante, los equipos de desarrollo lidian con problemas específicos y propios de cada micro-servicio que motivan su necesidad de dar soluciones **ad hoc**. 

Si el control es excesivo:

1. Se forman "cuellos de botella" donde varios equipos de desarrollo están esperando a que el equipo de plataforma ofrezca una solución a su problema específico. 
2. El equipo de plataforma pierde eficacia al tener que adaptar su ciclo de trabajo a las necesidades propias de cada desarrollo pudiendo llegar a colapsar por inoperancia. 

Por otra parte, si la flexibilidad es total:

1. Se crea una "jungla de tecnologías y soluciones" al permitir que cada equipo de desarrollo llegue a una solución específica para su problema lo cual hace inmantenible e ingestionable la plataforma a largo plazo. 

¿Cuál es, entonces, el equilibrio óptimo de control y flexibilidad? ¿Qué conjunto de herramientas pueden satisfacer ambas necesidades?

Dagger aporta, aquí, su estrategia:

a) El equipo de plataforma emplea las características modulares y de neutralidad de lenguaje de dagger para ofrecer un conjunto de librerías y rutinas de trabajo en plataforma. 
Estos elementos constituyen el marco de trabajo que permite que el control resida en el equipo de plataforma. 
b) Por otra parte, los equipos de desarrollo emplean los módulos y funciones ofrecidas por plataforma en sus propios workflows utilizando el lenguaje de su preferencia y adaptándolo a sus necesidades específicas, obteniendo así la flexibilidad que reclaman y, manteniéndose al mismo tiempo dentro del marco ofrecido por plataforma. 







