# ¿Qué es dagger?

![Intro1](./../_media/01/intro1.svg)

Dagger es un herramienta que permite crear y correr funciones dentro de containers con el propósito principal de integrar y desplegar código. 

Gracias a su particular diseño y al empleo de buildkit permite el empleo de contenedores por cada función de nuestro workflow. 

En palabras de su creador: ```Dagger es el primer motor de containerización de funciones```.

## ¿Por qué usar dagger?

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








