
# ¿Qué es un workflow?

![](../../_media/04_workflow/Workflow.webp)

Un workflow es una secuencia automatizada de tareas o procesos que se ejecutan de manera sistemática para completar una operación específica. Los workflows son esenciales en DevOps y CI/CD (Integración Continua/Entrega Continua), ya que permiten la automatización de procesos repetitivos y aseguran la consistencia y eficiencia en el desarrollo y despliegue de software.

El concepto de workflow no es nuevo y ha evolucionado significativamente a lo largo del tiempo. Originalmente, los workflows se utilizaban en contextos empresariales y administrativos para describir el flujo de trabajo entre diferentes departamentos o etapas de un proceso de negocio. Con la revolución digital y la evolución del software, los workflows comenzaron a ser utilizados en el ámbito de la tecnología de la información para describir la secuencia de tareas en sistemas informáticos.

En la década de 1990, con el auge de la metodología de desarrollo ágil y la necesidad de entregar software de manera más rápida y eficiente, los workflows comenzaron a ser adoptados en el desarrollo de software. Esta adopción se incrementó con la llegada de DevOps y CI/CD, donde la automatización de procesos es crucial para la entrega continua de software de alta calidad.


## Conceptos generales

Para comprender mejor los workflows en el contexto de DevOps y CI/CD, es importante conocer sus elementos, parámetros y características principales.


### Elementos de un Workflow

1. **Tareas (Tasks)**: son las unidades básicas de trabajo en un workflow. Cada tarea representa una acción específica que debe ser completada. Por ejemplo, compilar código, ejecutar pruebas, o desplegar una aplicación.

2. **Acciones (Actions)**: son operaciones específicas realizadas dentro de una tarea. Por ejemplo, en una tarea de compilación, una acción podría ser ejecutar un comando de compilación.

3. **Eventos (Events)**: son desencadenantes que inician un workflow. Los eventos pueden ser internos (por ejemplo, un commit de código) o externos (por ejemplo, una solicitud de pull en otro repositorio).

4. **Condiciones (Conditions)**: son reglas que determinan si una tarea o acción debe ser ejecutada. Pueden basarse en el estado de tareas anteriores o en parámetros específicos.

5. **Parámetros (Parameters)**: son valores que se pasan a tareas o acciones para personalizar su comportamiento. Por ejemplo, el nombre de una rama de código o una configuración específica.

6. **Artefactos (Artifacts)**: son los resultados generados por una tarea que pueden ser utilizados en tareas posteriores. Por ejemplo, archivos binarios generados por una tarea de compilación.


### Características de un Workflow

1. **Automatización**: los workflows automatizan tareas repetitivas, reduciendo el esfuerzo manual y minimizando errores.

2. **Secuencialidad**: los workflows siguen una secuencia definida de tareas, asegurando que los procesos se ejecuten en el orden correcto.

3. **Paralelismo**: en algunos casos, los workflows permiten la ejecución de tareas en paralelo para mejorar la eficiencia y reducir el tiempo total de ejecución.

4. **Modularidad**: los workflows pueden ser diseñados de manera modular, permitiendo la reutilización de tareas o secciones de un workflow en diferentes contextos.

5. **Monitorización**: los workflows suelen incluir mecanismos de monitorización y registro (logging) para rastrear el progreso y detectar problemas.

6. **Escalabilidad**: los workflows deben ser capaces de escalar para manejar un mayor volumen de tareas a medida que crecen las necesidades del proyecto.

7. **Integración**: los workflows se integran con otras herramientas y servicios en el ecosistema DevOps, como sistemas de control de versiones, servidores de integración continua, y plataformas de despliegue.


### Elementos clave en Workflows de CI/CD

1. **Branches**: las ramas de código en las que se ejecutan los workflows, permitiendo la integración y prueba de características nuevas sin afectar el código principal.

2. **Triggers**: los eventos que inician el workflow, como commits, pull requests, o despliegues programados.

3. **Environment Variables**: variables de entorno que proporcionan configuraciones específicas a los workflows, como credenciales de acceso o rutas de archivos.

4. **Stages**: fases del workflow que agrupan tareas relacionadas, como 'build', 'test', y 'deploy'.

5. **Dependencies**: las dependencias entre tareas, asegurando que ciertas tareas se completen antes de que otras comiencen.

Comprender estos conceptos es crucial para diseñar y gestionar workflows eficaces que mejoren la eficiencia y calidad en el desarrollo de software. La correcta implementación de workflows puede significar la diferencia entre un proceso de desarrollo ágil y eficiente y uno lento y propenso a errores.


## Servidores para la automatización

Existen diferentes servidores que permiten la automatización de tareas. Este curso se centrará en Github Actions, ya que es el más usado en Prefapp, pero veamos en una tabla comparativo con otros servidores que también utilizamos.


<table>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px 5px;
            text-align: center;
        }
        tr td:first-child {
            text-align: right;
             font-weight: bold;
        }
        img {
            display: block;
            margin: 0 auto;
        }
    </style>
    <thead>
        <tr>
            <th></th>
            <th>Github Actions</th>
            <th>Gitlab CI/CD</th>
            <th>Jenkins</th>
            <th>Apache Airflow</th>
            <th>Azure DevOps</th>
            <th>AWS CodePipeline</th>
            <th>Google Cloud Build</th>
            <th>Bitbucket Pipelines</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Logo</td>
            <td><img src="https://raw.githubusercontent.com/devicons/devicon/6910f0503efdd315c8f9b858234310c06e04d9c0/icons/githubactions/githubactions-original.svg" alt="GitHub Logo" width="50"></td>
            <td><img src="https://about.gitlab.com/images/ci/gitlab-ci-cd-logo_2x.png" alt="GitLab Logo" width="50"></td>
            <td><img src="https://raw.githubusercontent.com/devicons/devicon/6910f0503efdd315c8f9b858234310c06e04d9c0/icons/jenkins/jenkins-original.svg" alt="Jenkins Logo" width="50"></td>
            <td><img src="https://raw.githubusercontent.com/devicons/devicon/6910f0503efdd315c8f9b858234310c06e04d9c0/icons/apacheairflow/apacheairflow-original.svg" alt="Apache Airflow Logo" width="50"></td>
            <td><img src="https://raw.githubusercontent.com/devicons/devicon/6910f0503efdd315c8f9b858234310c06e04d9c0/icons/azuredevops/azuredevops-original.svg" alt="Azure DevOps Logo" width="50"></td>
            <td><img src="https://symbols.getvecta.com/stencil_12/3_aws-codepipeline.670ed60e36.svg" alt="AWS CodePipeline Logo" width="50"></td>
            <td><img src="https://avatars.githubusercontent.com/u/38220399?s=200&v=4" alt="Google Cloud Build Logo" width="50"></td>
            <td><img src="https://wac-cdn.atlassian.com/dam/jcr:a17e66da-d0a1-4912-878c-6e103111b9df/Bitbucket-icon-blue-rgb.svg?cdnVersion=1755" alt="Bitbucket Pipelines Logo" width="50"></td>
        </tr>
        <tr>
            <td>Empresa propietaria</td>
            <td>GitHub (Microsoft)</td>
            <td>Gitlab Inc.</td>
            <td>Comunidad Open Source</td>
            <td>Apache Software Foundation</td>
            <td>Microsoft</td>
            <td>Amazon Web Services</td>
            <td>Google</td>
            <td>Atlassian</td>
        </tr>
        <tr>
            <td>Primera release</td>
            <td>2018</td>
            <td>2015</td>
            <td>2011</td>
            <td>2014</td>
            <td>2018</td>
            <td>2015</td>
            <td>2018</td>
            <td>2016</td>
        </tr>
        <tr>
            <td>Tipo de software</td>
            <td>Freemium</td>
            <td>Freemium</td>
            <td>Open Source</td>
            <td>Open Source</td>
            <td>Freemium</td>
            <td>Privativo</td>
            <td>Privativo</td>
            <td>Freemium</td>
        </tr>
        <tr>
            <td>Licencia</td>
            <td>Copyright</td>
            <td>Licencia MIT</td>
            <td>Licencia MIT</td>
            <td>Apache License 2.0</td>
            <td>Copyright</td>
            <td>Copyright</td>
            <td>Copyright</td>
            <td>Proprietary</td>
        </tr>
        <tr>
            <td>Hosting</td>
            <td>Cloud</td>
            <td>Cloud o self-hosted</td>
            <td>Self-hosted</td>
            <td>Self-hosted</td>
            <td>Cloud</td>
            <td>Cloud</td>
            <td>Cloud</td>
            <td>Cloud</td>
        </tr>
        <tr>
            <td>Instalación</td>
            <td>No requiere instalación</td>
            <td>Opción de instalación self-hosted</td>
            <td>Requiere instalación</td>
            <td>Requiere instalación</td>
            <td>No requiere instalación</td>
            <td>No requiere instalación</td>
            <td>No requiere instalación</td>
            <td>No requiere instalación</td>
        </tr>
        <tr>
            <td>Prerrequisitos</td>
            <td>Cuenta de GitHub</td>
            <td>Cuenta de Gitlab</td>
            <td>Servidor propio (1 CPU, 1GB RAM)</td>
            <td>Servidor propio (4 CPU, 8GB RAM)</td>
            <td>Cuenta de Azure</td>
            <td>Cuenta de AWS</td>
            <td>Cuenta de Google Cloud</td>
            <td>Cuenta de Bitbucket</td>
        </tr>
        <tr>
            <td>Bases de datos</td>
            <td>No requiere</td>
            <td>No requiere</td>
            <td>Opcional</td>
            <td>Opcional</td>
            <td>No requiere</td>
            <td>No requiere</td>
            <td>No requiere</td>
            <td>No requiere</td>
        </tr>
        <tr>
            <td>Escalabilidad</td>
            <td>Alta</td>
            <td>Alta</td>
            <td>Alta</td>
            <td>Alta</td>
            <td>Alta</td>
            <td>Alta</td>
            <td>Alta</td>
            <td>Alta</td>
        </tr>
        <tr>
            <td>Control</td>
            <td>Medio</td>
            <td>Alto</td>
            <td>Alto</td>
            <td>Alto</td>
            <td>Medio</td>
            <td>Medio</td>
            <td>Medio</td>
            <td>Medio</td>
        </tr>
        <tr>
            <td>Dificultad de uso</td>
            <td>Media</td>
            <td>Media</td>
            <td>Alta</td>
            <td>Media</td>
            <td>Media</td>
            <td>Media</td>
            <td>Media</td>
            <td>Media</td>
        </tr>
        <tr>
            <td>Comunidad</td>
            <td>Amplia</td>
            <td>Amplia</td>
            <td>Muy amplia</td>
            <td>Amplia</td>
            <td>Amplia</td>
            <td>Amplia</td>
            <td>Amplia</td>
            <td>Amplia</td>
        </tr>
        <tr>
            <td>Integraciones</td>
            <td>Nativo con GitHub</td>
            <td>Nativo con Gitlab, múltiples integraciones</td>
            <td>Amplia gama de integraciones a través de plugins</td>
            <td>Amplia gama de integraciones a través de operadores</td>
            <td>Nativo con Azure, múltiples integraciones</td>
            <td>Nativo con AWS, múltiples integraciones</td>
            <td>Nativo con Google Cloud, múltiples integraciones</td>
            <td>Nativo con Bitbucket, múltiples integraciones</td>
        </tr>
        <tr>
            <td>Precio y planes</td>
            <td><a href="https://github.com/pricing" target="_blank">GitHub Pricing</a></td>
            <td><a href="https://about.gitlab.com/pricing/" target="_blank">GitLab Pricing</a></td>
            <td><a href="https://jenkins.io/download/" target="_blank">Jenkins Pricing</a></td>
            <td><a href="https://airflow.apache.org/docs/" target="_blank">Airflow Pricing</a></td>
            <td><a href="https://azure.microsoft.com/en-us/pricing/details/devops/azure-devops-services/" target="_blank">Azure DevOps Pricing</a></td>
            <td><a href="https://aws.amazon.com/codepipeline/pricing/" target="_blank">AWS CodePipeline Pricing</a></td>
            <td><a href="https://cloud.google.com/cloud-build/pricing" target="_blank">Google Cloud Build Pricing</a></td>
            <td><a href="https://bitbucket.org/product/pricing" target="_blank">Bitbucket Pipelines Pricing</a></td>
        </tr>
        <tr>
            <td>Doc oficial</td>
            <td><a href="https://docs.github.com/en/actions" target="_blank">GitHub Actions Docs</a></td>
            <td><a href="https://docs.gitlab.com/ee/ci/" target="_blank">GitLab CI/CD Docs</a></td>
            <td><a href="https://www.jenkins.io/doc/" target="_blank">Jenkins Docs</a></td>
            <td><a href="https://airflow.apache.org/docs/" target="_blank">Airflow Docs</a></td>
            <td><a href="https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops" target="_blank">Azure DevOps Docs</a></td>
            <td><a href="https://docs.aws.amazon.com/codepipeline/" target="_blank">AWS CodePipeline Docs</a></td>
            <td><a href="https://cloud.google.com/cloud-build/docs" target="_blank">Google Cloud Build Docs</a></td>
            <td><a href="https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/" target="_blank">Bitbucket Pipelines Docs</a></td>
        </tr>
    </tbody>
</table>


### Otros

- CircleCI: https://circleci.com/
- Travis CI: https://travis-ci.org/
- Heroku CI: https://www.heroku.com/continuous-integration
- TeamCity: https://www.jetbrains.com/teamcity/
- Bamboo: https://www.atlassian.com/software/bamboo
- Buddy: https://buddy.works/
- Codefresh: https://codefresh.io/
- Concourse: https://concourse-ci.org/
- Drone: https://drone.io/
- GoCD: https://www.gocd.org/
- Spinnaker: https://www.spinnaker.io/
- Tekton: https://tekton.dev/

Más info: https://en.wikipedia.org/wiki/Comparison_of_source-code-hosting_facilities


### Github Actions

Ahora, centrándonos en Github Actions, vamos a ver una descripción básica. Como hemos comentado, es un servicio de integración continua y entrega continua (CI/CD) que permite automatizar tareas en un repositorio de Github. Se basa en la ejecución de workflows, que son conjuntos de tareas que se ejecutan en un servidor de Github. Los workflows se definen en un archivo YAML que se almacena en el directorio `.github/workflows` del repositorio.

Es un servicio gratuito para repositorios públicos y privados, con un límite de 2000 minutos de ejecución al mes para los repositorios privados. Para los repositorios públicos, no hay límite de tiempo de ejecución.

Github Actions se integra con Github, lo que permite ejecutar workflows en respuesta a eventos de Github, como la creación de un pull request, el push de un commit, la creación de un tag, etc. También se pueden ejecutar workflows de forma manual o programada.

Proporciona un conjunto de acciones predefinidas que se pueden utilizar en los workflows, así como la posibilidad de crear acciones personalizadas.

También existe la posibilidad de crear runners en un servidor propio. Los runners de Github son máquinas virtuales alojadas por Github que ejecutan los workflows, pero la posibilidad de configurarlos en servidores propios o en la nube puede aportar ventajas.

En el siguiente capítulo, vamos a ver más en detalle cómo funcionan los workflows de Github Actions y cómo nos puede facilitar la vida el CI/CD para el desarrollo de software propio o de nuestros clientes.

Enlaces de interés:
- [Github Pricing](https://github.com/pricing)
- [Github Actions Docs](https://docs.github.com/en/actions)
- [Github Marketplace](https://github.com/marketplace?type=actions)
- [Github Runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-larger-runners/about-larger-runners)
