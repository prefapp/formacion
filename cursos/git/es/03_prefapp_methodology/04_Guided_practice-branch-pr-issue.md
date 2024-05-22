
# Práctica Guiada: Creación de Ramas, Pull Request y Preparación de Trabajo Mediante Issue (Projects)

En esta práctica guiada, te mostraremos cómo aplicar la metodología de Prefapp para gestionar tu trabajo en GitHub, incluyendo la creación de ramas, la apertura de issues y la preparación del trabajo mediante proyectos.


## Paso 1: Creación de una Issue

1. Abre el proyecto correspondiente en GitHub Projects.
2. En la columna "New", crea una nueva issue para una tarea específica que necesite ser realizada. Por ejemplo, "Implementar funcionalidad de autenticación de usuarios".

También puedes hacerlo directamente desde la pestaña "Issues" en el repositorio:
1. Haz clic en el botón "New issue".
2. Escribe un título descriptivo para la issue, como "Actualizar funcionalidad de autenticación de usuarios".

👀 *Recuerda que puedes usar plantillas para los [procedimientos](https://github.com/prefapp/demo-state/blob/main/.github/docs/template_migration_es.md).*


## Paso 2: Configuración de la Issue

1. Asigna la issue a ti mismo o al miembro del equipo responsable de completarla.
2. Si no la has creado desde el project, añade la issue al proyecto correspondiente y muévela a la columna adecuada. En principio será "Ready to Start (DoD completed)". Cuando empieces el trabajo deberás moverla a "In Progress".


## Paso 3: Creación de una Rama y Pull Request (PR)

1. Asegurate que estás en la rama principal del repositorio y baja los cambios con:
```bash
git pull origin main
```

2. Crea una nueva rama para trabajar en la issue que acabas de crear:
```bash
git checkout -b feature/branch-test
```

3. Realiza los cambios necesarios en tu código para completar la tarea o subtarea de la issue.
   
4. Sube la rama a GitHub:
```bash
git push origin feature/branch-test
```

5. Crea una PR para fusionar tu rama con la rama principal del repositorio. En el output del anterior comando habrá un enlace para crear la PR. Si no lo ves, puedes hacerlo desde la interfaz de GitHub.

6. Asegurate que sigues las buenas prácticas para configurar la PR. Añade:
  - Una descripción clara de los cambios realizados.
  - Un revisor apropiado.
  - Etiquetas si es necesario.
  - La issue relacionada con la PR.

7. Una vez terminados los cambios descritos en la issue y mientras esperas la revisión, puedes mover la issue a la columna "In review" del project de GitHub.

## Paso 4: Revisión y Fusión del Pull Request

1. El revisor examinará tus cambios, realizará comentarios si es necesario y aprobará el PR una vez que esté satisfecho con el trabajo (looks good to me (LGTM)).
2. Una vez aprobado, la PR puede fusionarse con la rama principal del repositorio (squash and merge).
3. Si todos los cambios propuestos en la issue están completados, podremos mover la issue a la columna "Done".


¡Felicidades! Has completado con éxito la práctica guiada de creación de ramas, pull request y preparación de trabajo mediante issue en GitHub. Si tienes dudas, observa y pregunta a tus compañeros.

![](https://media1.tenor.com/images/a5d777014b8cdfee5199c41367ce6994/tenor.gif?itemid=4747406)

