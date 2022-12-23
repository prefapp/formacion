# Introducción

# El problema de la orquestación de contenedores

> En los últimos años, las tecnologías de contenedores están provocando un cambio disruptivo en la forma en que las organizaciones crean, evolucionan e implementan aplicaciones.

Las plataformas de contenedores, principalmente [Docker](https://docker.com/), se utilizan para empaquetar aplicaciones de tal manera que tienen acceso controlado a un determinado grupo de recursos del sistema operativo que se ejecuta en una máquina física o virtual. .

Si vamos también a [arquitecturas de microservicios](https://es.wikipedia.org/wiki/Arquitectura_de_microservicios), donde las aplicaciones se dividen en múltiples pequeños servicios que se comunican entre sí, el adecuado y empaquetan cada uno en su contenedor correspondiente

Los beneficios, especialmente para las organizaciones que utilizan prácticas de integración y despliegue continuos (CI/CD), se basan en el hecho de que los contenedores son escalables y efímeros, las instancias de aplicaciones o servicios que se ejecutan en esos contenedores van y vienen según sea necesario (para ejecutar las pruebas, lanzar un nuevo entorno para el desarrollador, actualizar la versión de la aplicación en producción, escalar...).

Y esto, llevado a escala, es un gran desafío. Si usamos 8 contenedores para alojar 4 aplicaciones, la tarea de implementar y mantener nuestros contenedores se puede manejar manualmente. Si por el contrario tenemos 2000 contenedores y 400 servicios que gestionar, la tarea de gestionarlos manualmente se hace realmente difícil.

La orquestación de contenedores se trata de **automatizar el despliegue, gestión, escalado, conectividad y disponibilidad de los contenedores** que alojan nuestras aplicaciones.