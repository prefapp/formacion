# Forxas de código aberto

Unha forxa, tamén coñecida como plataforma de aloxamento de código, é un servizo web que permite aloxar repositorios de código fonte e control de versións. Isto ofrece ós desenvolvedores a posibilidade de almacenar e compartir código fonte, así coma de colaborar en proxectos de código aberto. Ademais, garante un seguimento dos problemas e erros, controlar as versións do código e realizar a integración continua e a entrega continua.

Algunhas das forxas de código aberto máis coñecidas son:

- **[GitHub](https://github.com/)**: é unha das máis populares e utilizadas. É propiedade de Microsoft e oferta servizos de aloxamento de repositorios Git, xestión de proxectos, seguimento de problemas e control de versións.

- **[GitLab](https://about.gitlab.com/)**: outra das máis populares, oferta servizos de aloxamento de repositorios de Git, xestión de proxectos e control de versións. Tamén conta con opcións avanzadas de integración continua e entrega continua.

- **[Bitbucket](https://bitbucket.org/)**: é propiedade de Atlassian e oferta servizos de aloxamento de repositorios Git e Mercurial, seguimento de problemas e control de versións. Tamén conta con opcións de integración continua e entrega continua.

- **[GitKraken](https://www.gitkraken.com/)**: esta forxa oferta unha interface gráfica de usuario intuitiva para traballar con repositorios Git. Tamén conta con opcións de integración con outras ferramentas de desenvolvemento.

- **[SourceForge](https://sourceforge.net/)**: aínda que non se limita exclusivamente a Git, oferta o servizo de aloxamento de repositorios, seguimento de problemas e control de versións.

- **[Gitea](https://gitea.io/en-us/)**: oferta servizos de aloxamento de repositorios Git, xestión de proxectos e control de versións. Tamén é compatible con outros sistemas de control de versións, coma Mercurial ou Subversion.

Nós ímonos centrar en GitHub, xa que é a máis utilizada e a que vamos a usar durante o curso. Faremos un recorrido pola documentación que si ou si tes que ler para o bo uso da plataforma.

## GitHub 

<div style="text-align: center;">
  <div style="margin: 0 auto;max-width:280px;">

![](../_media/02_hands_on/github-logo.png)

  </div>
</div>

GitHub oferta unha ampla gama de características e ferramentas para desenvolvedores de software, incluíndo aloxamento de repositorios de código, seguimento de problemas, xestión de proxectos, integración continua e entrega continua e ferramentas de revisión de código, entre outros.

Características:

- **[Aloxamento de repositorios Git](https://docs.github.com/es/repositories)**: GitHub oferta aloxamento gratuito de repositorios Git públicos, así coma aloxamento de repositorios privados para equipos que desexan manter o control sobre o ser código fonte.

- **[Seguemento de problemas](https://docs.github.com/es/issues)** (Issues): a función de seguimento de problemas de GitHub permite ós equipos de desenvolvemento notificar e xestionar problemas e erros relacionados co código fonte. Os usuarios poden asignar estas issues a membros do equipo e realizar un seguimento do estado de resolución do problema.

- **[Xestión de proxectos](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)** (Projects): a función de xestión de proxectos de GitHub permite ós equipos de desenvolvemento organizar as súas tarefas e proxectos en taboleiros Kanban adaptables. Os usuarios poden crear tarefas, asignalas a membros do equipo e realizar un seguimento do progreso do proxecto.

- **[Integración continua e entrega continua](https://docs.github.com/es/actions)**: GitHub Actions é unha función de integración continua e entrega continua (CI/CD) integrada na plataforma GitHub. Os usuarios poden crear fluxos de traballo automatizados para compilar, probar e despregar o seu código de xeito automático.

- **[Revisión de código](https://docs.github.com/es/pull-requests)**: GitHub oferta unha serie de ferramentas de revisión de código que permiten ós equipos de desenvolvemento revisar o código fonte de maneira colaborativa. Os usuarios poden facer comentarios no código, crear pull requests para fusionar cambios e realizar revisións das modificacións.

- **[Opción en liña de comandos](https://docs.github.com/es/github-cli)**: GitHub tamén oferta unha ferramenta de liña de comandos (CLI) que permite ós usuarios interactuar coa plataforma de GitHub directamente dende o seu terminal. A CLI de GitHub admite unha ampla gama de comandos e opcións para interactuar con repositorios, issues, pull requests e máis.

Como vimos nos anteriores enlaces, na [documentación de GitHub](https://docs.github.com/es) poderás atopar multitude de información sobre a plataforma, as súas funcionalidades, etc., así coma unha serie de tutoriais que te poden axudar a comezar coa plataforma e con Git se é a túa primeira vez. É interesante revisar a documentación para extraer as boas prácticas que se recomendan.

## Protección de ramas

As mellores prácticas de seguridade en GitHub recomendan [protexer as ramas principais](https://docs.github.com/es/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule) dos repositorios, coma master ou main, para evitar que se realicen cambios non desexados nelas.

Algunhas boas prácticas para protexer as ramas principais son:

- **Designar owners**: asignar un ou varios usuarios coma propietarios da rama principal.

- **Requirir revisións de código polos propietarios (Owners)**: requirir que os cambios na rama principal sexan aprobados polos seus propietarios.

- **Configurar as revisións necesarias para cada rama**: asegurarse, ó crear unha nova rama, de que teña os revisores suficientes e que estean cualificados para realizar as revisións do código. Tamén é posible configurar a cantidade mínima de aprobacións que son precisas antes de permitir un merge.

- **Limitar o acceso ás ramas**: só deberían ter acceso a unha rama os membros do equipo ou os colaboradores que precisen acceder a esta. Isto pode lograrse mediante a configuración de permisos en GitHub.

- **Usar ferramentas de integración continua**: utilizar ferramentas de integración continua, como Travis CI ou CircleCI, para realizar probas automáticas en cada commit e pull request. Isto permitirá detectar e solucionar erros rapidamente. Máis adiante veremos as GitHub actions.

- **Limitar o acceso ás credenciais**: só os membros do equipo que o precisen deberían ter acceso a credenciais coma claves SSH ou contrasinais de acceso á conta de GitHub.

## secrets
Nunca se deben introducir directamente no código fonte as credenciais de acceso ós servizos externos. Por exemplo, se se utiliza unha API de terceiros, coma GitHub, para realizar unha tarefa, nunca se deben incluír as credenciais de acceso á API no código fonte. No seu lugar, usaranse variables de entorno ou segredos para almacenar estes valores.

## .gitignore y .gitattributes

`.gitignore` é un arquivo que lle indica a Git que arquivos ou directorios deben ser ignorados durante o proceso de seguimento de cambios. Noutras palabras, Git non rastreará os cambios dos arquivos e directorios que estean listados no `.gitignore`. É importante utilizar este ficheiro para evitar o seguimento de arquivos innecesarios que non deben formar parte do teu repositorio, como arquivos temporais, arquivos de compilación ou arquivos xerados automaticamente.

O bo uso do `.gitignore` implica incluír no arquivo unicamente os ficheiros e directorios que non deban ser rastreados. É importante mantelo actualizado, engadindo novos arquivos e directorios a medida que se vaian creando. Tamén se pode utilizar o arquivo `.gitignore` para excluír arquivos que conteñan información confidencial, coma claves de acceso ou contrasinais.

No seguinte repositorio atópase unha colección de modelos de `.gitignore` para diferentes linguaxes e contornas: [https://github.com/github/gitignore](https://github.com/github/gitignore). 👀

`.gitattributes` é un arquivo que lle indica a Git momo manexar arquivos específicos. Pódese utilizar para establecer atributos de arquivos, coma o tipo de final de liña, o modo de execución, o conxunto de caracteres e a difusión binaria. Tamén se pode utilizar para estableces regras para a fusión de arquivos.

O bo uso de `.gitattributes` implica utilizalo para establecer os atributos correctos para os arquivos do proxecto, de tal xeito que se poidan manexar adecuadamente en Git. Por exemplo, se traballas nun proxecto que utilizar distintos sistemas operativos, pódese utilizar `.gitattributes` para establecer o tipo de final de liña que debe ser utilizado, asegurando a compatibilidade entre os distintos sistemas operativos.

## Lectura de boas prácticas en GitHub

<div style="text-align: center;">
  <div style="margin: 0 auto;max-width:280px;">

![](../_media/02_hands_on/lecturas.jpg)

  </div>
</div>

- Repositorios: https://docs.github.com/es/repositories/creating-and-managing-repositories/best-practices-for-repositories
- Organizacións: https://docs.github.com/es/organizations/collaborating-with-groups-in-organizations/best-practices-for-organizations
- Projects: https://docs.github.com/es/issues/planning-and-tracking-with-projects/learning-about-projects/best-practices-for-projects 
- Asignación de varios propietarios: https://docs.github.com/es/enterprise-cloud@latest/admin/overview/best-practices-for-enterprises
- Seguridade do usuario: https://docs.github.com/es/enterprise-server@3.8/admin/user-management/managing-users-in-your-enterprise/best-practices-for-user-security
- Protección de contas: https://docs.github.com/es/code-security/supply-chain-security/end-to-end-supply-chain/securing-accounts
- Para integradores: https://docs.github.com/es/rest/guides/best-practices-for-integrators?apiVersion=2022-11-28
- Conversacións coa comunidade: https://docs.github.com/es/discussions/guides/best-practices-for-community-conversations-on-github
