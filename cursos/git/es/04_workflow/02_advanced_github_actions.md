
# Github Actions avanzado

Ya hemos visto brevemente qué son las Github Actions, pero ahora vamos a profundizar un poco más en ellas. En este capítulo, exploraremos cómo se configuran, cómo se ejecutan y cómo se pueden personalizar para satisfacer necesidades específicas. 

GitHub Actions es una plataforma de integración continua y entrega continua (CI/CD) que automatiza los pipelines de construcción, prueba y despliegue. Te permite crear flujos de trabajo que construyen y prueban todas las pull requests a un repositorio, o puedes desplegar pull requests fusionadas en tu entorno de producción.

Los workflows se definen en el directorio .github/workflow del repositorio. Puedes definir múltiples workflows, cada uno realizando un conjunto diferente de acciones. Por ejemplo, un workflow puede especificar cómo crear y probar una pull request, mientras que otro workflow puede desplegar automáticamente una aplicación cuando se crea una nueva release.

Para una referencia más detallada, puedes consultar la [documentación oficial de Github Actions](https://docs.github.com/en/actions/using-workflows).


## Conceptos de los workflows en Github Actions

### Workflow Triggers

Un trigger de workflow es un evento que hace que se ejecute un workflow. Hay cuatro tipos de triggers:

- Eventos que ocurren en el repositorio de GitHub del workflow.
- Eventos que ocurren fuera de GitHub, que activan un evento repository_dispatch en GitHub.
- Un horario predefinido.
- Trigger manual.

Después de que se activa un workflow, el motor del workflow ejecuta uno o más jobs. Cada job contiene una lista predefinida de pasos; un paso puede ejecutar un script definido o realizar una acción específica (de una biblioteca de acciones disponibles en GitHub Actions). Esto se ilustra en el diagrama a continuación.

![](../../_media/04_workflow/GitHub-Actions-workflow-structure.webp)

El proceso que ocurre cuando se activa un evento es el siguiente:

1. Ocurre un evento en el repositorio. Cada evento tiene un SHA de commit y una referencia de Git (un alias legible para humanos del hash del commit).
2. GitHub busca en el directorio `.github/workflow` del repositorio archivos de workflow relacionados con el SHA de commit o la referencia de Git asociada con el evento.
3. Para los workflows con valores que coinciden con el evento desencadenante, se activa la ejecución del workflow. Algunos eventos requieren que el archivo del workflow esté en la rama predeterminada del repositorio para ejecutarse.
4. Cada workflow usa la versión del workflow en el SHA de commit o la referencia de Git asociada con el evento. Cuando se ejecuta el workflow, GitHub configura las variables de entorno `GITHUB_SHA` y `GITHUB_REF` en el entorno del launcher.


### Workflow Jobs y Concurrency

La ejecución de un workflow consta de uno o más jobs que se ejecutan en paralelo. Este es el comportamiento predeterminado, pero puedes definir dependencias en otros jobs para hacer que los jobs ejecuten tareas secuencialmente. Esto se hace utilizando la palabra clave `jobs.<job-id>.needs`.

Puedes ejecutar un número ilimitado de tareas dentro de los límites de uso de tu workflow. Para evitar que se ejecuten demasiados jobs simultáneamente, puedes usar `jobs.<job-id>.concurrency` para asegurar que solo un job o workflow en el mismo grupo de concurrencia se ejecute al mismo tiempo. El nombre de un grupo de concurrencia puede usar cualquier cadena o excepción, excepto secretos.

Si un job o workflow concurrente está en la cola, y otro job o workflow está en progreso, la tarea o workflow en cola se pone en espera, y cualquier tarea o workflow previamente suspendido en el grupo de concurrencia se cancela.


## Ejemplos de Workflows de GitHub Actions: Sintaxis y Comandos


### Sintaxis de las Github Actions

#### name

#### on

#### defauls

#### jobs



### Comandos del Workflow

#### Establecer Outputs

#### Mostrar Errores

#### Mostrar outputs completos


## GitOps

///////// Puede ser esto: https://codefresh.io/docs/docs/gitops-integrations/ci-integrations/github-actions/ /////////

///////// O esto: https://jacobtomlinson.dev/posts/2019/creating-github-actions-in-python/ /////////

