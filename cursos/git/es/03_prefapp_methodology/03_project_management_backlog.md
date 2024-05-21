
# Manejo de Projects en Backlog con GitHub

En el contexto del desarrollo de software, los proyectos de GitHub son una herramienta fundamental para la planificación y gestión del trabajo. Permiten a los equipos organizar, priorizar y realizar un seguimiento del progreso de las tareas y características de un proyecto en un entorno colaborativo. En Prefapp, utilizamos proyectos de GitHub como una forma centralizada de gestionar nuestro backlog y coordinar el trabajo en equipo.


## GitHub Projects

Los proyectos de GitHub son tableros flexibles y personalizables que permiten a los equipos organizar y priorizar su trabajo. Cada proyecto puede tener múltiples columnas que representan diferentes etapas del flujo de trabajo, desde la planificación inicial hasta la finalización del trabajo. Las tareas se representan como tarjetas que pueden moverse entre columnas para reflejar su estado actual.


## Metodología Scrum y GitHub Issues

En Prefapp, adoptamos una metodología Scrum ágil para gestionar nuestros proyectos de desarrollo de software. Utilizamos GitHub Issues para representar las distintas unidades de trabajo, que pueden ser historias de usuario (epic), tareas (story/task) o subtareas (subtask). Cada issue representa una unidad de trabajo específica que debe completarse como parte del proyecto.

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../_media/03_prefapp_methodology/epic-story-subtask.png)

  </div>
</div>


### GitHub Issues

Las GitHub Issues son una forma de realizar un seguimiento de las tareas, mejoras, errores y otros elementos de trabajo en un proyecto. Cada issue puede tener asignado un responsable, etiquetas, comentarios, y otros metadatos que facilitan la gestión y colaboración en el desarrollo de software.

- **Epic**: Representa una característica o funcionalidad completa que puede dividirse en múltiples tareas más pequeñas. Los epics suelen ser issues de alto nivel que abarcan múltiples tareas (task) o historias de usuario (story).
  
- **Story/Task**: Representa una unidad de trabajo más específica que debe completarse como parte de un epic o de manera independiente. Las tasks representan tareas individuales que deben realizarse para cumplir con un objetivo más amplio.

- **Subtask**: Representa una tarea más pequeña y específica que forma parte de una tarea principal. Es conveniente evitar el uso de subtareas en favor de las pull requests, que suelen representar cambios más específicos en el código.

Si ves alguna necesidad en el código, alguna mejora o, simplemente, un error, puedes abrir una issue en GitHub para que el equipo pueda abordarla. Las issues son una forma efectiva de comunicar y gestionar el trabajo en un proyecto de software. Es importante que refleje "La motivación" y los "Criterios de aceptación" para que el equipo pueda entender y trabajar en la issue de manera efectiva. También puedes añadir observaciones, dejar la evolución de la tarea, documentación, etc.


## Procedimientos

Algunas de las tareas de operaciones en produción requieren de **ventanas de actualización**. Estas son periodos programados y pactados con el cliente durante los cuales se realizan cambios significativos en el sistema, con el objetivo de minimizar la interrupción del servicio y asegurar una ejecución exitosa.

Normalmente, se redactan **procedimientos** en issues (pueden ser aisladas, epics, stories...) donde se describe el plan de acción, los impactos esperados, y los pasos detallados para la ejecución y posibles rollbacks. 

Plantilla de procedimiento: https://github.com/prefapp/demo-state/blob/main/.github/docs/template_migration_es.md

Lo importante al redactar un procedimiento es que sea **claro, conciso y detallado**. Debe contener toda la información necesaria para que cualquier miembro del equipo pueda ejecutarlo de manera efectiva y segura. Puedes utilizar elementos como los checklist, comandos, y ejemplos para facilitar la comprensión y ejecución del procedimiento.


## Uso de GitHub Projects en Prefapp

En Prefapp, abrimos un proyecto de GitHub para cada proyecto de software que estamos desarrollando. Utilizamos las siguientes columnas en nuestros proyectos de GitHub para reflejar nuestro flujo de trabajo:

- **New**: Aquí es donde se agregan nuevas tareas o características al backlog del proyecto. Estas tareas aún no han sido priorizadas ni asignadas a un sprint.

- **Refining**: En esta columna, refinamos y detallamos las tareas o características que han sido agregadas al backlog. Esto puede implicar la división de epics en tareas más pequeñas o la clarificación de los requisitos.

- **Ready to Start (DoD completed)**: Una vez que una tarea o característica ha sido completamente definida y está lista para ser implementada, se mueve a esta columna. Aquí se asegura de que se cumplan todos los criterios de aceptación y definición de done (DoD) antes de comenzar el trabajo.

- **In Progress**: Cuando un miembro del equipo comienza a trabajar en una tarea o característica, se mueve a esta columna para indicar que está en progreso.

- **Blocked / On hold**: Si una tarea o característica se encuentra bloqueada por algún motivo, se mueve a esta columna para indicar que no se puede avanzar en ella temporalmente.

- **In Review**: Una vez que se ha completado una tarea o característica y está lista para su revisión, se mueve a esta columna. Aquí se realiza la revisión del trabajo realizado antes de su integración final.

- **Done**: Finalmente, cuando una tarea o característica ha sido completada y revisada satisfactoriamente, se mueve a esta columna para indicar que está terminada.


## Integración de GitHub Projects con Pull Requests

En Prefapp, vinculamos nuestras tareas de GitHub Issues con pull requests (PRs) que representan los cambios de código asociados con esas tareas. Esto nos permite rastrear el progreso del trabajo y la implementación de características específicas directamente desde el proyecto de GitHub.

Al utilizar GitHub Projects de esta manera, podemos mantener un seguimiento claro del trabajo pendiente, colaborar de manera efectiva en el desarrollo de software y garantizar la entrega oportuna de proyectos de alta calidad en Prefapp.

Además, con las keywords de github, podemos relacionar los issues con los PRs, de manera que se cierre automáticamente el issue al hacer merge del PR.

Doc: 
- "Using keywords in issues and pull requests" https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/using-keywords-in-issues-and-pull-requests
- "Linking a pull request to an issue" https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue


# Ejemplo Práctico

Un buen ejemplo de una epic issue es la que se uso para la creación de este curso. "Add Git course": https://github.com/prefapp/formacion/issues/107

Se puede apreciar como se crearon story issues a partir de esta:
- Build course structure https://github.com/prefapp/formacion/issues/108
- Build 1st module fundamentals and introductionhttps://github.com/prefapp/formacion/issues/109
- Build 2nd module Hands on https://github.com/prefapp/formacion/issues/110
- ...

Y, en este caso, cada story issue contiene una PR o varias relacionadas con la tarea. 
por ejemplo, "Build course structure" tiene la PR "structure, readme and 1st module" (https://github.com/prefapp/formacion/pull/112) que soluciono dos issues a la vez con la relación:

```
resolves #108 and resolves #109
```
