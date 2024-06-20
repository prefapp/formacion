
# Práctica guiada - Crear un workflow

Ya hemos visto opciones avanzadas en los anteriores ejemplos de [Workflows utilizados en Prefapp](./04_workflow/03_used_in_prefapp). Ahora vamos a hacer una práctica sencilla que nos servirá para repasar conceptos creando un workflow en GitHub Actions desde 0.

Para empezar, simplemente enviaremos un saludo a la consola que podremos ver en el panel de Github Action. Estará coloreado y se ejecutará en respuesta a un evento "pull request". Con esta base, iremos añadiendo complejidad.

⚠️ *Recordad que el workflow se debe guardar en la carpeta* `.github/workflows` *de vuestro repositorio.*

## Manos a la obra

Empezamos con el nombre, debe ser descriptivo y fácil de identificar:

```yaml
name: saludo-color 🌈
```

El trigger haremos que sea la pull request, pero añadimos también la opción manual:

```yaml
on:
  pull_request:
  workflow_dispatch:
```

Necesitamos unas variables de entorno para definir colores y un mensaje standard. Estas **variables serán globales** para todo el workflow:

```yaml
  SALUDO: "Hola "
  RED: \033[31m
  GREEN: \033[32m
  YELLOW: \033[33m
  BLUE: \033[34m
  PINK: \033[35m
  CYAN: \033[36m
  WHITE: \033[37m
  NORMAL: \033[0;39m
```

Ahora, vamos a definir algunos aspectos del job que afectarán dentro de este ámbito a los steps que anidemos en él:
- Nombre. [Más info](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#name)
- Sistema operativo. Le asignamos una Ubuntu latest. [Más info](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on)
- Variables de entorno. Vamos a especificar una **variable específica para el job**. [Más info](https://docs.github.com/en/actions/learn-github-actions/variables)

```yaml
jobs:
  pruebas:
    name: Pruebas 🏗️
    runs-on: ubuntu-latest
    env:
      NOMBRE: "Mundo"
```

Ahora ya podemos especificar un step dentro del job. Podemos empezar por el checkout para poder acceder a los archivos del repositorio:

```yaml
    steps:
      - name: Checkout repository 🛎️
        uses: actions/checkout@v3
```

Y el segundo step será el encargado de enviar el saludo. Además añadimos la fecha mediante una **variable que actuará tan solo a nivel de step**:

```yaml
    steps:
      - name: Decir hola 👋
        run: |
          echo -e "$RED $SALUDO$NOMBRE. Hoy es $DIA! red"
          echo -e "$GREEN $SALUDO$NOMBRE. Hoy es $DIA! green"
          echo -e "$YELLOW $SALUDO$NOMBRE. Hoy es $DIA! yellow"
          echo -e "$BLUE $SALUDO$NOMBRE. Hoy es $DIA! blue"
          echo -e "$PINK $SALUDO$NOMBRE. Hoy es $DIA! pink"
          echo -e "$CYAN $SALUDO$NOMBRE. Hoy es $DIA! cyan"
          echo -e "$WHITE $SALUDO$NOMBRE. Hoy es $DIA! white"
          echo -e "$NORMAL $SALUDO$NOMBRE. Hoy es $DIA! normal"
          echo -e "$NORMAL $SALUDO$RED$NOMBRE. $GREEN Hoy es $YELLOW$DIA! varios $NORMAL"

        env:
          DIA: "Lunes"
```

Con este workflow hemos visto cada parte de un workflow básico. Además, hemos definido variables en distintos `scopes` para ver cómo se comportan.

Si añadimos estos cambios a una rama y los subimos, podremos ver que al crear la pull request se dispará el workflow. A cada cambio que efectuemos en la rama, se reflejará en la pull request y provocará que se disparé el trigger de nuevo. En la interfaz de GitHub Actions se ve así:

![](../../_media/04_workflow/workflow-example01.webp)

¡Genial! Vamos a modificar el workflow para ver algo más complejo. 

## Añadimos complejidad

Vamos a añadir un step que se ejecute en un nuevo runner, en concreto, en un contenedor ubuntu 20.04 ([Más info de standard hosted](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners)). Este runner se ejecutará de manera paralela. Simplemente, envía un nuevo saludo en color. 

```yaml
      - name: Ejecutar en paralelo 🐳
        uses: ubuntu-20.04
        with:
          entrypoint: /bin/sh
        run: echo -e "$GREEN Hola desde un contenedor! $NORMAL"
```

Además, vamos a recoger información del contenedor con los comandos `whoami`, `free -h` y `ps aux` para escribirlo guardarlo en el fichero `info.txt` (Se guarda dentro del runner) y lo mostraremos. 

```yaml
      - name: Recoger información del contenedor 📝
        with:
          entrypoint: /bin/sh
        run: |
          whoami > info.txt
          free -h >> info.txt
          ps aux >> info.txt
          cat info.txt
```

![](../../_media/04_workflow/workflow-example02.webp)


Para poder recuperar el documento info.txt creado debemos añadir un step con la action [upload-artifact@](https://github.com/actions/upload-artifact) que lo subirá como un artefacto que podremos utilizar desde otros runners.

```yaml
      - name: Upload info.txt 📤
        uses: actions/upload-artifact@v4
        with:
          name: info
          path: ./info.txt
```

Ahora, vamos a añadir un nuevo job que dependa del job `paralelo` para ver como se comporta. En este caso, vamos a instalar [Bats](https://bats-core.readthedocs.io/en/stable/installation.html), un framework de testing para Bash. Utilizaremos Node.js para instalarlo y comprobar la versión.

```yaml
  check-bats-version:
    name: Testing Bats 🦇
    runs-on: ubuntu-latest
    needs: paralelo
    steps:
      - name: Checkout repository 🛎️
        uses: actions/checkout@v4
      - name: Setup Node.js 🚀
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Install Bats 🦇
        run: npm install -g bats
      - name: Check Bats version 🦇
        run: bats -v
```

Necesitaremos crear un fichero `test.bats` en la raíz. Para comprobar que tenemos el fichero `info.txt` en el nuevo runner, tan solo vamos a comprobar que existe:

```bash
@test "Check if the file exists" {
  run ls info.txt
  [ "$status" -eq 0 ]
}
```

Ahora ya podemos incluir en nuestro workflow otro step para ejecutar el test de Bats. 

```yaml
      - name: Ejecutar test de Bats 🦇
        run: bats test.bats
```

Y para finalizar, añadimos un step en este job para descargar el artefacto con la action [download-artifact](https://github.com/actions/download-artifact).

```yaml
      - name: Download info.txt 📥
        uses: actions/download-artifact@v4
        with:
          name: info
          path: ./info.txt
```

![](../../_media/04_workflow/workflow-example03.webp)

## Visión general del workflow

![](../../_media/04_workflow/workflow-example04.webp)

1. Se puede ver como los jobs `Pruebas` y `Paralelo` se ejecutan en paralelo.
2. Se puede ver la dependencia del job `Check Bats version` del job `Paralelo`.
3. El artifact que hemos subido en el job `Paralelo` queda en el workflow con un fichero .zip descargable.

Ficheros: 
- [color-test.yaml](../../_media/04_workflow/color-test.yaml)
- [test.bats](../../_media/04_workflow/test.bats)


!Enhorabuena! 🎉 Has llegado al final de este capítulo. Ahora puedes seguir prácticando con otros workflows que te interesen. Algunas ideas: https://github.com/sdras/awesome-actions/blob/main/ideas.md 

## Otros recursos interesantes

- [Actions Runners Controller (ARC)](https://github.com/actions/actions-runner-controller) - es un operador de Kubernetes que orquesta y escala ejecutores autoalojados para GitHub Actions. 
- [Dagger](https://dagger.io/) - es un lenguaje de programación de flujo de trabajo de código abierto que permite a los desarrolladores definir flujos de trabajo de CI/CD como código. Tenemos un [curso de Dagger](https://prefapp.github.io/formacion/cursos/dagger/#/) en Prefapp.
- [GitHub Actions con Docker](https://github.com/marketplace?type=actions&query=docker+) - Github Actions tiene soporte nativo en Docker, con lo cuál puedes probarlo en local o integrarlo con otras herramientas como Kubernetes o Jenkins.
- [Caracterísiticas avanzadas](https://docs.github.com/en/actions/using-workflows/about-workflows#advanced-workflow-features) - Explora la documentación de Github que merece mucho la pena: Almacenamiento de secretos, jobs dependientes, matrices de variables, caché, etc
