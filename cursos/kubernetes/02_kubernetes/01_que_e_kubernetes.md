# Qué é Kubernetes?

Kubernetes é un framework e unha plataforma de orquestración de contedores que ten como función principal a automatización do despregue, escalado e mantemento de aplicacións en producción que corren nun clúster de nodos ou máquinas.

Ós creadores de Kubernetes non lles doen prendas en confesar o obxectivo último da súa plataforma:

> Mediante Kubernetes queremos posibilitar o tratamento do CPD como se de unha soa máquina se tratase... [Joe Beda, Brendan Burns e Craig McLuckie]

**Cando dicimos que Kubernetes é un framework...**

Estámonos a referir a que nos ofrece un conxunto de fundamentos e mecanismos altamente configurables que permiten construir plataformas á medida das necesidades das empresas e organizacións usuarias do sistema. 

De feito, a meirande parte do tempo, trabállase con plataformas baseadas en Kubernetes onde o proveedor ou administrador ten feito un traballo de adaptación, programación e integración de compoñentes e preparación da contorna, ese é o caso:

- Principais proveedores cloud.
 - [AKS](https://azure.microsoft.com/es-es/services/kubernetes-service/) (Azure Kubernetes Service).
 - [EKS](https://aws.amazon.com/es/eks/) (Amazon Elastic Container Service for Kubernetes).
 - [GKE](https://aws.amazon.com/es/eks/) (Google Kubernetes Engine).
- Solucións aloxadas en outros proveedores (listado [aquí](https://kubernetes.io/docs/setup/pick-right-solution/#hosted-solutions)).
- Sistemas baseados en Kubernetes.
 - O [openshift](https://www.redhat.com/es/technologies/cloud-computing/openshift) de RedHat. 
- Instalacións de kubernetes para desenvolvemento:
 - Kind
 - Minikubes.
 - Minishift.
 - DockerDesktop.
 - MicroK8s.
- Neste artigo podemos ver con máis profundidade [diferentes solucións](https://betterprogramming.pub/choose-the-right-kubernetes-hosting-solution-a842878fc594) para diferentes tipos de despregues incluíndo Kubernetes en CPDs ou clouds privados ou "on premise".

A flexibilidade que permite o enfoque de framework de Kubernetes posibilita un gran conxunto de escenarios onde se pode empregar.

Ó longo deste curso, necesitaremos o uso dunha das ferramentas para desenvolvemento que mencionamos, para poder crear clústeres onde despregar as prácticas. Recomendamos o uso de Kind, pola potencia e flexibilidade que nos aporta. No seguinte enlace podedes acceder á [guía de instalción de kind](https://kind.sigs.k8s.io/docs/user/quick-start)

**Cando dicimos que as aplicacións en Kubernetes corren nun clúster de nodos ou máquinas...**

Estámonos a referir a que a vocación de Kubernetes é a de superar as limitacións dun só nodo. Esto é, o escalado horizontal, creando un conxunto de máquinas que traballan como se dunha soa se tratase. A través de Kubernetes, creamos un clúster ou agrupación de servidores (físicos ou virtuais) que serán controlados polo sistema. 

En Kubernetes, a meirande parte do tempo non teremos que nos preocupar de en qué máquina ou nodo están os nosos contedores; de feito, a idea é que nos despreocupemos da infraestructura, xa que K8s "agocha" esa complexidade e da resposta a preguntas como:

- Cantos nodos están a funcionar?
- Onde debería correr os contedores?
- Cal é o nodo máis axeitado para lanzar o seguinte contedor?
- ...

**Cando dicimos que Kubernetes é un orquestrador de contedores...**

Estamos a dicir que a función fundamental de Kubernetes é a de despregar aplicacións baseadas en contedores garantindo:

- Que os contedores que conforman a aplicación están correndo e teñen suficientes recursos computacionais para funcionar.
- Que esos contedores poden "verse" (teñen acceso por rede) independientemente da máquina ou nodo do clúster onde estén a correr.
- Que se pode interactúar cos contedores da aplicación como entidade (como conxunto) e de xeito individual para: paralos, escalalos, arrancalos, borralos...
