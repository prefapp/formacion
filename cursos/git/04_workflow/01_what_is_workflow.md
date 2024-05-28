
# Que é un workflow?

Un workflow é unha secuencia automatizada de tarefas ou procesos que se executan de xeito sistemático para completar unha operación específica. Os workflows son esenciais en DevOps e CI/CD (Integración Continua/Entrega Continua), xa que permiten a automatización de procesos repetitivos e aseguran a consistencia e eficiencia no desenvolvemento e despregamento de software.

O concepto de workflow non é novo e evolucionou de xeito significativo ó longo do tempo. Na súa orixe, os workflows utilizábanse en contextos empresariais e administrativos para describir o fluxo de traballo entre distintos departamentos ou etapas dun proceso de negocio. Coa revolución dixital e a evolución do software, os workflows comezaron a ser utilizados no ámbito da tecnoloxía da información para describir a secuencia de tarefas en sistemas informáticos.

Na década de 1990, coa auxe da metodoloxía de desenvolvemento áxil e a necesidade de entregar software de xeito máis rápido e eficiente, os workflows comezaron a ser adoptados no desenvolvemento de software. Esta adopción incrementouse coa chegada de DevOps e CI/CD, onde a automatización de procesos é crucial para a entrega continua de software de alta calidade.


## Conceptos xerais

Para comprender mellor os workflows no contexto de DevOps e CI/CD é importante coñecer os seus elementos, parámetros e características principais.


### Elementos dun Workflow

1. **Tarefas (Tasks)**: unidades básicas de traballo nun workflow. Cada tarefa representa unha acción específica que debe ser completada. Por exemplo: compilar código, executar probas ou despregar unha aplicación.

2. **Accións (Actions)**: operacións específicas realizadas dentro dunha tarefa. Por exemplo, nunha tarefa de compilación, unha acción podería ser executar un comando de compilación.

3. **Eventos (Events)**: desencadeantes que inician un workflow. Os eventos poden ser internos (por exemplo, un commit do código) ou externos (por exemplo, unha solicitude de pull noutro repositorio).

4. **Condicións (Conditions)**: regras que determinan se unha tarefa ou acción debe ser executada. Poden basearse no estado de tarefas anteriores ou en parámetros específicos.

5. **Parámetros (Parameters)**: valores que se pasan a tarefas ou accións para personalizar o seu comportamento. Por exemplo, o nome dunha rama de código ou unha configuración específica.

6. **Artefactos (Artifacts)**: resultados xerados por unha tarefa que poden ser utilizados en tarefas posteriores. Por exemplo, arquivos binarios xerados por unha tarefa de compilación.


### Características dun Workflow

1. **Automatización**: os workflows automatizan tarefas repetitivas, reducindo o esforzo manual e minimizando erros.

2. **Secuencialidade**: os workflows seguen unha secuencia definida de tarefas, asegurando que os procesos se executen na orde correcta.

3. **Paralelismo**: nalgúns casos, os workflows permiten a execución de tarefas en paralelo para mellorar a eficiencia e reducir o tempo total de execución.

4. **Modularidade**: os workflows poden ser deseñados de xeito modular, permitindo reutilizar tarefas ou seccións dun workflow en distintos contextos.

5. **Vixilancia**: os workflows adoitan incluír mecanismos de vixilancia e rexistro (logging) para rastrear o progreso e detectar problemas.

6. **Escalabilidade**: os workflows deben ser capaces de escalar para manexar un maior volume de tarefas a medida que crecen as necesidades do proxecto.

7. **Integración**: os workflows intégranse con outras ferramentas e servizos no ecosistema DevOps, coma sistemas de control de versións, servidores de integración continua e plataformas de despregamento.


### Elementos clave en Workflows de CI/CD

1. **Branches**: as ramas de código nas que se executan os workflows, permitindo a integración e proba de características novas sen afectar ó código principal.

2. **Triggers**: os eventos que inician o workflow, coma commits, pull requests, ou despregamentos programados.

3. **Environment Variables**: variables de entorno que proporcionan configuracións específicas ós workflows, coma credenciais de acceso ou rutas de arquivos.

4. **Stages**: fases do workflow que agrupan tarefas relacionadas, coma 'build', 'test', e 'deploy'.

5. **Dependencies**: as dependencias entre tarefas, asegurando que certas tarefas se completen antes de que outras comecen.

Comprender estes conceptos é crucial para deseñar e xestionar workflows eficaces que melloren a eficiencia e calidade no desenvolvemento de software. A correcta implantación de workflows pode supor a diferenza entre un proceso de desenvolvemento áxil e eficiente e un lento e propenso a erros.


## Servidores para a automatización

Existen distintos servidores que permiten a automatización de tarefas. Este curso vaise centrar en GitHub Actions, xa que é o máis usado en Prefapp, pero vexamos unha táboa comparativa con outros servidores que tamén usamos.


<table style="width:100%; max-width:1200px; margin:0 auto; border-collapse:collapse; overflow-x:auto; display:block;">
    <thead>
        <tr>
            <th>Característica</th>
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
            <td><strong>Empresa propietaria</strong></td>
            <td>GitHub (Microsoft)</td>
            <td>Gitlab Inc.</td>
            <td>Comunidade Open Source</td>
            <td>Apache Software Foundation</td>
            <td>Microsoft</td>
            <td>Amazon Web Services</td>
            <td>Google</td>
            <td>Atlassian</td>
        </tr>
        <tr>
            <td><strong>Primeira release</strong></td>
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
            <td><strong>Tipo de software</strong></td>
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
            <td><strong>Licenza</strong></td>
            <td>Copyright</td>
            <td>Licenza MIT</td>
            <td>Licenza MIT</td>
            <td>Apache License 2.0</td>
            <td>Copyright</td>
            <td>Copyright</td>
            <td>Copyright</td>
            <td>Proprietary</td>
        </tr>
        <tr>
            <td><strong>Hosting</strong></td>
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
            <td><strong>Instalación</strong></td>
            <td>Non require instalación</td>
            <td>Opción de instalación self-hosted</td>
            <td>Require instalación</td>
            <td>Require instalación</td>
            <td>Non require instalación</td>
            <td>Non require instalación</td>
            <td>Non require instalación</td>
            <td>Non require instalación</td>
        </tr>
        <tr>
            <td><strong>Requerimentos</strong></td>
            <td>Conta de GitHub</td>
            <td>Conta de Gitlab</td>
            <td>Servidor propio (1 CPU, 1GB RAM)</td>
            <td>Servidor propio (4 CPU, 8GB RAM)</td>
            <td>Conta de Azure</td>
            <td>Conta de AWS</td>
            <td>Conta de Google Cloud</td>
            <td>Conta de Bitbucket</td>
        </tr>
        <tr>
            <td><strong>Bases de datos</strong></td>
            <td>Non require</td>
            <td>Non require</td>
            <td>Opcional</td>
            <td>Opcional</td>
            <td>Non require</td>
            <td>Non require</td>
            <td>Non require</td>
            <td>Non require</td>
        </tr>
        <tr>
            <td><strong>Escalabilidade</strong></td>
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
            <td><strong>Control</strong></td>
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
            <td><strong>Dificultade de uso</strong></td>
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
            <td><strong>Comunidade</strong></td>
            <td>Ampla</td>
            <td>Ampla</td>
            <td>Moi ampla</td>
            <td>Ampla</td>
            <td>Ampla</td>
            <td>Ampla</td>
            <td>Ampla</td>
            <td>Ampla</td>
        </tr>
        <tr>
            <td><strong>Integracións</strong></td>
            <td>Nativo con GitHub</td>
            <td>Nativo con Gitlab, múltiples integracións</td>
            <td>Ampla gama de integracións a través de plugins</td>
            <td>Ampla gama de integracións a través de operadores</td>
            <td>Nativo con Azure, múltiples integracións</td>
            <td>Nativo con AWS, múltiples integracións</td>
            <td>Nativo con Google Cloud, múltiples integracións</td>
            <td>Nativo con Bitbucket, múltiples integracións</td>
        </tr>
        <tr>
            <td><strong>Prezo e plans</strong></td>
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
            <td><strong>Doc oficial</strong></td>
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


### Outros

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

Máis info: https://en.wikipedia.org/wiki/Comparison_of_source-code-hosting_facilities


### Github Actions

Agora, centrándonos en GitHub Actions, imos ver unha descrición básica. Como comentamos, é un servizo de integración continua e entrega continua (CI/CD) que permite automatizar tarefas nun repositorio de GitHub. Baséase na execución de workflows, que son conxuntos de tarefas que se executan nun servidor de GitHub. Os workflows defínense nun arquivo YAML que se almacena no directorio `.github/workflows` do repositorio.

É un servizo gratuíto para repositorios públicos e privados, cun límite de 2000 minutos de execución ó mes para os repositorios privados. Para os repositorios públicos non hai límite de tempo de execución.

GitHub Actions intégrase con GitHub, o que lle permite executar workflows en resposta a eventos de GitHub, como a creación dun pull request, o push dun commit, a creación dun tag, etc. Tamén se poden executar workflows de xeito manual ou programado.

Proporciona un conxunto de accións predefinidas que se poden utilizar nos workflows, así como a posibilidade de crear accións personalizadas.

Tamén existe a posibilidade de crear runners nun servidor propio. Os runners de GitHub son máquinas virtuais aloxadas por GitHub que executan os workflows, pero a posibilidade de configuralos en servidores propio ou na nube pode aportar vantaxes.

No seguinte capítulo imos ver máis en detalle como funcionan os workflows de GitHub Actions e como pode facilitarnos a vida o CI/CD para o desenvolvemento de software propio ou dos nosos clientes.

Enlaces de interés:
- [Github Pricing](https://github.com/pricing)
- [Github Actions Docs](https://docs.github.com/en/actions)
- [Github Marketplace](https://github.com/marketplace?type=actions)
- [Github Runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-larger-runners/about-larger-runners)
