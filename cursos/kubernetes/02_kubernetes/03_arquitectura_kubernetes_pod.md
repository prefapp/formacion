# Artefactos en Kubernetes: o Pod

Para ser quen despregar e controlar as aplicacións en Kubernetes, póñense á disposición dos usuarios unha serie de elementos básicos que actúan de bloques de construcción mediante os cales pódese expresar unha topoloxía e estrutura moi flexible que se axuste ás necesidades de cada caso.  

O que segue é unha descrición dos principais elementos e da súa relación co resto do sistema.

## A. Pod

Un [pod](https://kubernetes.io/docs/concepts/workloads/pods/) é o elemento mínimo ou atómico dentro de Kubernetes.

Non podemos pensar nun pod coma nun contedor: o pod consiste en 1..n contedores **agrupados lóxicamente pola súa función.** 

Deste xeito, os contedores despregados dentro dun pod:

- Irán sempre despregados de forma conxunta nun só nodo ou servidor. 
- Comparten a configuración de rede.
- Comparten os volumes e o almacenamento. 

![Pod](./../_media/02/pod1.png)