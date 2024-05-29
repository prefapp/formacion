# Forjas de código abierto

Una forja, también conocida como plataforma de alojamiento de código, es un servicio web que permite alojar repositorios de código fuente y control de versiones. Esto ofrece a los desarrolladores la posibilidad de almacenar y compartir código fuente, así como colaborar en proyectos de código abierto. Además, garantiza un seguimiento de los problemas y errores, controlar las versiones del código y realizar la integración continua y la entrega continua.

Algunas de las forjas de código abierto más populares son:

- **[GitHub](https://github.com/)**: es una de las forjas de código abierto más populares y utilizadas. Es propiedad de Microsoft y ofrece servicios de alojamiento de repositorios Git, gestión de proyectos, seguimiento de problemas y control de versiones. 

- **[GitLab](https://about.gitlab.com/)**: es otra de las forjas de código abierto basadas en Git más populares y ofrece servicios de alojamiento de repositorios Git, gestión de proyectos y control de versiones. También cuenta con opciones avanzadas de integración continua y entrega continua.

- **[Bitbucket](https://bitbucket.org/)**: es una forja de código abierto basada en Git y propiedad de Atlassian que ofrece servicios de alojamiento de repositorios Git y Mercurial, seguimiento de problemas y control de versiones. También cuenta con opciones de integración continua y entrega continua.

- **[GitKraken](https://www.gitkraken.com/)**: es una forja de código abierto basada en Git que ofrece una interfaz gráfica de usuario intuitiva para trabajar con repositorios Git. También cuenta con opciones de integración con otras herramientas de desarrollo.

- **[SourceForge](https://sourceforge.net/)**: aunque no se limita exclusivamente a Git, también ofrece servicios de alojamiento de repositorios Git, seguimiento de problemas y control de versiones.

- **[Gitea](https://gitea.io/en-us/)**: es otra forja de código abierto basada en Git que ofrece servicios de alojamiento de repositorios Git, gestión de proyectos y control de versiones. También es compatible con otros sistemas de control de versiones, como Mercurial y Subversion.

Nos vamos a centrar en Github, ya que es la más utilizada y la que vamos a utilizar en el curso. Haremos un recorrido por la documentación que sí o sí tienes que leer para el buen uso de la plataforma.

## Github 

<div style="text-align: center;">
  <div style="margin: 0 auto;max-width:280px;">

![](../../_media/02_hands_on/github-logo.png)

  </div>
</div>

GitHub ofrece una amplia gama de características y herramientas para desarrolladores de software, incluyendo alojamiento de repositorios de código, seguimiento de problemas, gestión de proyectos, integración continua y entrega continua, herramientas de revisión de código, entre otros.

Características:

- **[Alojamiento de repositorios Git](https://docs.github.com/es/repositories)**: GitHub ofrece alojamiento gratuito de repositorios Git públicos, así como alojamiento de repositorios privados para equipos que desean mantener el control sobre su código fuente.

- **[Seguimiento de problemas](https://docs.github.com/es/issues)** (Issues): la función de seguimiento de problemas de GitHub permite a los equipos de desarrollo notificar y gestionar problemas y errores relacionados con el código fuente. Los usuarios pueden asignar estas issues a miembros del equipo y realizar un seguimiento del estado de resolución del problema.

- **[Gestión de proyectos](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)** (Projects): la función de gestión de proyectos de GitHub permite a los equipos de desarrollo organizar sus tareas y proyectos en tableros Kanban personalizables. Los usuarios pueden crear tareas, asignarlas a miembros del equipo y realizar un seguimiento del progreso del proyecto.

- **[Integración continua y entrega continua](https://docs.github.com/es/actions)**: GitHub Actions es una función de integración continua y entrega continua (CI/CD) integrada en la plataforma GitHub. Los usuarios pueden crear flujos de trabajo automatizados para compilar, probar y desplegar su código de forma automática.

- **[Revisión de código](https://docs.github.com/es/pull-requests)**: GitHub ofrece una serie de herramientas de revisión de código que permiten a los equipos de desarrollo revisar el código fuente de manera colaborativa. Los usuarios pueden hacer comentarios en el código, crear solicitudes de extracción para fusionar cambios y realizar revisiones de código de manera colaborativa.

- **[Opción en línea de comandos](https://docs.github.com/es/github-cli)**: GitHub también ofrece una herramienta en línea de comandos (CLI) que permite a los usuarios interactuar con la plataforma de GitHub directamente desde la línea de comandos. La CLI de GitHub admite una amplia gama de comandos y opciones para interactuar con repositorios, problemas, solicitudes de extracción y más.

Como hemos visto en los anteriores hipervínculos, en la [documentación de Github](https://docs.github.com/es) podrás encontrar multitud de información sobre la plataforma, sus funcionalidades, etc., así como una serie de tutoriales que te pueden ayudar a comenzar con la plataforma y con Git si es tu primera vez. Es interesante revisar la documentación para extraer las buenas prácticas que se recomiendan.

## Protección de ramas

Las mejores prácticas de seguridad en GitHub recomiendan [proteger las ramas principales](https://docs.github.com/es/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule) de los repositorios, como master o main, para evitar que se realicen cambios no deseados en ellas. 

Algunas buenas prácticas para proteger las ramas principales son:

- **Designar owners**: asigna a propietarios de la rama principal y requerir que sean ellos quienes aprueben cambios en la rama principal.

- **Requerir revisiones de código por los propietarios (Owners)**: requiere que los cambios en la rama principal sean aprobados por los propietarios de la rama principal.

- **Configura las revisiones necesarias**: configura las revisiones necesarias para cada rama, asegurándote de que haya suficientes revisores y de que estén calificados para realizar revisiones de código. También puedes configurar la cantidad mínima de aprobaciones que se necesitan antes de permitir un merge.

- **Limita el acceso a las ramas**: solo los miembros del equipo o los colaboradores que necesiten acceder a una rama deberían tener permiso para hacerlo. Esto se puede lograr a través de la configuración de permisos en GitHub.

- **Usa herramientas de integración continua**: usa herramientas de integración continua, como Travis CI o CircleCI, para realizar pruebas automáticas en cada commit y pull request. Esto te permitirá detectar y solucionar errores rápidamente. Más adelante veremos las Github Actions.

- **Limita el acceso a las credenciales**: limita el acceso a las credenciales, como claves SSH o contraseñas de acceso a la cuenta de GitHub. Solo los miembros del equipo que necesiten acceder a estas credenciales deberían tener permiso para hacerlo.

## secrets
Nunca se deben hardcodear las credenciales de acceso a los servicios externos en el código fuente. Por ejemplo, si se utiliza una API de terceros, como GitHub, para realizar una tarea, nunca se deben incluir las credenciales de acceso a la API en el código fuente. En su lugar, se debe utilizar variables de entorno o secretos para almacenar las credenciales de acceso a la API. 

## .gitignore y .gitattributes

`.gitignore` es un archivo que le indica a Git qué archivos o directorios deben ser ignorados durante el proceso de seguimiento de cambios. En otras palabras, Git no rastreará los cambios en los archivos y directorios que estén listados en `.gitignore`. Es importante utilizar `.gitignore` para evitar el seguimiento de archivos innecesarios que no deben formar parte de tu repositorio, como archivos temporales, archivos de compilación o archivos generados automáticamente.

El buen uso de `.gitignore` implica incluir en el archivo únicamente los archivos y directorios que no deben ser rastreados. Es importante mantenerlo actualizado, añadiendo nuevos archivos o directorios que deban ser ignorados a medida que se vayan creando. También se puede utilizar el archivo `.gitignore` para excluir archivos que contengan información confidencial, como claves de acceso o contraseñas.

Repositorio con una colección de plantillas de `.gitignore` para diferentes lenguajes y entornos se puede encontrar en [GitHub](https://github.com/github/gitignore). 👀 

`.gitattributes` es un archivo que le indica a Git cómo manejar archivos específicos. Se puede utilizar para establecer atributos de archivos, como el tipo de final de línea, el modo de ejecución, el conjunto de caracteres y la difusión binaria. También se puede utilizar para establecer reglas para la fusión de archivos.

El buen uso de `.gitattributes` implica utilizarlo para establecer los atributos correctos para los archivos del proyecto, de tal manera que se puedan manejar adecuadamente en Git. Por ejemplo, si trabajas en un proyecto que utiliza diferentes sistemas operativos, se puede utilizar `.gitattributes` para establecer el tipo de final de línea que debe ser utilizado, asegurando la compatibilidad entre los diferentes sistemas operativos.

## Lectura de buenas prácticas en Github

<div style="text-align: center;">
  <div style="margin: 0 auto;max-width:280px;">

![](../../_media/02_hands_on/lecturas.jpg)

  </div>
</div>

- Repositorios: https://docs.github.com/es/repositories/creating-and-managing-repositories/best-practices-for-repositories
- Organizaciones: https://docs.github.com/es/organizations/collaborating-with-groups-in-organizations/best-practices-for-organizations
- Projects: https://docs.github.com/es/issues/planning-and-tracking-with-projects/learning-about-projects/best-practices-for-projects 
- Asignación de varios propietarios: https://docs.github.com/es/enterprise-cloud@latest/admin/overview/best-practices-for-enterprises
- Seguridad del usuario: https://docs.github.com/es/enterprise-server@3.8/admin/user-management/managing-users-in-your-enterprise/best-practices-for-user-security
- Protección de cuentas: https://docs.github.com/es/code-security/supply-chain-security/end-to-end-supply-chain/securing-accounts
- Para integradores: https://docs.github.com/es/rest/guides/best-practices-for-integrators?apiVersion=2022-11-28
- Conversaciones con la comunidad: https://docs.github.com/es/discussions/guides/best-practices-for-community-conversations-on-github
