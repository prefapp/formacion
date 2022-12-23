# Docker: contenedores para todos

## El origen de Docker

Docker nació bajo el paraguas de una empresa en la actualidad extinta (dotCloud Inc.), que tenía como objetivo facilitar el despliegue de aplicaciones a los desarrolladores, liberándolos de tener que preocuparse por la infraestructura. Fundado en 2010, por el autor original de Docker (Salomon Hykes), actualmente ya no está operativo, pero es el germen de construir una herramienta que estandarizaría y agilizaría el despliegue de aplicaciones y servicios web, permitiendo **separar claramente las responsabilidades** del equipo de desarrollo, responsabilidad del equipo de operaciones, encargado de hospedar y mantener la disponibilidad de la aplicación.

> Inspirándonos en la evolución de la adopción de contenedores de carga en la industria del transporte, podemos ver [en el siguiente video](https://www.youtube.com/watch?v=Q5POuMHxW-0&feature=youtu.be) uno de las presentaciones más famosas que hizo el autor original, cuando la tecnología aún no tenía la tracción que tiene hoy.

El máximo exponente de este modelo de plataforma como servicio ([PaaS](https://azure.microsoft.com/es-es/overview/what-is-paas/)) fue en su momento [Heroku](https://www.heroku.com/), del que surgieron una serie de ideas y buenas prácticas, condensadas en un manifiesto de 12 reglas, destinadas a los desarrolladores de aplicaciones, que facilitarían la adopción de este tipo de proveedores.
Docker se basa en gran medida en este manifiesto, siendo una herramienta muy útil para adoptar este conjunto de buenas prácticas en nuestros proyectos de software.

**[La app de los doce factores](https://12factor.net/es/)**

**I.** [Código base (Codebase)](https://12factor.net/es/codebase): Un código base sobre el que hacer el control de versiones y multiples despliegues.

**II.** [Dependencias](https://12factor.net/es/dependencies): Declarar y aislar dependencias de forma explícita.

**III.** [Configuraciones](https://12factor.net/es/config): Guardar configuración en entorno, no en código.

**IV.** [Backing services](https://12factor.net/es/backing-services): Tratar los servicios que dan soporte a la aplicación ("backing services") como recursos enchufables.

**V.** [Construir, desplegar, ejecutar](https://12factor.net/es/build-release-run): Separa completamente la etapa de construcción de la etapa de ejecución.

**VI.** [Procesos](https://12factor.net/es/processes): Ejecuta aplicaciones como uno o más procesos **sin estado**.

**VII.** [Asignación de puertos](https://12factor.net/es/port-binding): Publicar servicios mediante asignación de puertos.

**VIII.** [Concurrencia](https://12factor.net/es/concurrency): Escala usando el modelo de proceso, mejor en horizontal que en vertical.

**IX.** [Desechabilidad](https://12factor.net/es/disposability): Maximice la robustez con inicios rápidos y cierres limpios de su servicio.

**X.** [Paridad en desarrollo y producción](https://12factor.net/es/dev-prod-parity): Mantener los entornos (desarrollo, preproducción, producción...) lo más parecidos posible.

**XI.** [Logs](https://12factor.net/es/logs): Trata los logs como un flujo de eventos.

**XII.** [Administración de procesos](https://12factor.net/es/admin-processes): Ejecuta las tareas de gestión/administración como nuevos procesos de tu servicio, con una única ejecución.

## Características de Docker

A pesar de la competencia que existía entre los diferentes proveedores de PaaS (Heroku, Cloudfoundry, Redhat Openshift, ...), y las herramientas que utilizaban para construir su servicio, algunas de código abierto y otras propietarias, Docker Managed se ha consolidado como el principal motor de contenedores debido al hecho de que:

- Facilita enormemente la gestión de los contenedores.
- Proporciona un sistema simple para crear, mantener y distribuir imágenes de contenedores.
- Proporciona sus propias herramientas de orquestación (Docker Swarm), y se integra con herramientas de terceros como Kubernetes.
- Se esfuerza por mantener una serie de [estándares](https://opencontainers.org/) para contenerización, que acomodan nuevos proyectos.

- Enlaces de interés:
   - [Azure Docs: Qué es PaaS](https://azure.microsoft.com/es-es/overview/what-is-paas/)
   - [Heroku PaaS](https://www.heroku.com/)
   - [La app de Los Doce factores](https://12factor.net/es/)