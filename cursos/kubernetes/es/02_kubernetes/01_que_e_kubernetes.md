# ¿Qué es Kubernetes?

Kubernetes es un framework y una plataforma de orquestación de contenedores cuya función principal es automatizar la implementación, el escalado y el mantenimiento de aplicaciones en producción que se ejecutan en un clúster de nodos o máquinas.

Los creadores de Kubernetes no dudan en confesar el objetivo final de su plataforma:

> A través de Kubernetes queremos hacer posible tratar el CPD como si fuera una sola máquina... [Joe Beda, Brendan Burns y Craig McLuckie]

**Cuando decimos que Kubernetes es un framework...**

Nos referimos a lo que nos ofrece un conjunto de bases y mecanismos altamente configurables que nos permiten construir plataformas a la medida de las necesidades de las empresas y organizaciones que utilizan el sistema.

De hecho, la mayoría de las veces se trabaja con plataformas basadas en Kubernetes donde el proveedor o administrador ha hecho un trabajo de adaptación, programación e integración de componentes y preparación del entorno, así es:

- Principales proveedores de nube.
   - [AKS](https://azure.microsoft.com/es-es/services/kubernetes-service/) (Servicio Azure Kubernetes).
   - [EKS](https://aws.amazon.com/es/eks/) (Amazon Elastic Container Service for Kubernetes).
   - [GKE](https://aws.amazon.com/es/eks/) (Google Kubernetes Engine).
- Soluciones alojadas por otros proveedores (enumeradas [aquí](https://kubernetes.io/partners/#conformance)).
- Sistemas basados ​​en Kubernetes.
   - RedHat [openshift](https://www.redhat.com/es/technologies/cloud-computing/openshift).
- Instalaciones de Kubernetes para desarrollo:
   - Kind
   - Minikubes
   - Minishift.
   - DockerDesktop.
   - MicroK8s.
- En este artículo podemos ver más a fondo [diferentes soluciones](https://betterprogramming.pub/choose-the-right-kubernetes-hosting-solution-a842878fc594) para diferentes tipos de despliegues incluyendo Kubernetes en CPDs o nubes privadas o "en las instalaciones".

La flexibilidad que permite el enfoque del framework de Kubernetes posibilita un gran conjunto de escenarios en los que se puede emplear.

A lo largo de este curso, necesitaremos el uso de una de las herramientas de desarrollo que mencionamos, para poder crear clústeres donde se puedan desplegar las prácticas. Recomendamos el uso de Kind, por la potencia y flexibilidad que proporciona. En el siguiente enlace puede acceder a la [tipo de guía de instalación](https://kind.sigs.k8s.io/docs/user/quick-start)

**Cuando decimos que las aplicaciones en Kubernetes se ejecutan en un grupo de nodos o máquinas...**

Nos referimos a que la vocación de Kubernetes es superar las limitaciones de un solo nodo. Esto es escalado horizontal, creando un conjunto de máquinas que funcionan como si fueran una sola. A través de Kubernetes, creamos un clúster o agrupación de servidores (físicos o virtuales) que serán controlados por el sistema.

En Kubernetes, la mayor parte del tiempo no tendremos que preocuparnos de en qué máquina o nodo están nuestros contenedores; de hecho, la idea es que no nos importe la infraestructura, ya que K8s "esconde" esa complejidad y responde preguntas como:

- ¿Cuántos nodos se están ejecutando?
- ¿Hacia dónde deben correr los contenedores?
- ¿Cuál es el nodo más adecuado para lanzar el próximo contenedor?
- ...

**Cuando decimos que Kubernetes es un orquestador de contenedores...**

Estamos diciendo que la función principal de Kubernetes es desplegar aplicaciones basadas en contenedores al garantizar:

- Que los contenedores que componen la aplicación estén en ejecución y dispongan de los recursos informáticos suficientes para funcionar.
- Que esos contenedores puedan "ver" (tener acceso a la red) independientemente de la máquina o nodo del clúster donde se estén ejecutando.
- Que puedes interactuar con los contenedores de la aplicación como una entidad (como un conjunto) e individualmente para: detener, escalar, iniciar, eliminar...
