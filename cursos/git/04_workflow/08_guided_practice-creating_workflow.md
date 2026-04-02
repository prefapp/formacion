
# Práctica guiada - Crear un workflow

Xa vimos distintas opcións avanzadas nos anteriores exemplos de [Workflows utilizados en Prefapp](./04_workflow/03_used_in_prefapp). Agora imos facer unha práctica sinxela que nos servirá para repasar conceptos creando un workflow en GitHub Actions dende 0.

Para comezar, simplemente enviaremos un saúdo á consola que poderemos ver no panel de GitHub Actions. Estará coloreado e se executará en resposta a un evento "pull request". Con esta base, iremos engadindo complexidade.

⚠️ *Recordade que o workflow débese gardar na carpeta* `.github/workflows` *do voso repositorio.*

## Imos aló!

Comezamos co nome, que debe ser descritivo e fácil de identificar:

```yaml
name: saúdo-cor 🌈
```

Faremos que o trigger sexa a pull request, pero engadimos tamén a opción manual:

```yaml
on:
  pull_request:
  workflow_dispatch:
```

Precisamos dunhas variables de entorno para definir cores e unha mensaxe estándar. Estas **variables serán globais** para todo o workflow:

```yaml
  SAUDO: "Ola "
  RED: \033[31m
  GREEN: \033[32m
  YELLOW: \033[33m
  BLUE: \033[34m
  PINK: \033[35m
  CYAN: \033[36m
  WHITE: \033[37m
  NORMAL: \033[0;39m
```

Agora imos definir algúns aspectos do job que afectarán dentro deste ámbito ós steps que anidemos nel:
- Nome. [Más info](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#name)
- Sistema operativo. Asignamos unha Ubuntu latest. [Más info](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on)
- Variables de entorno. Imos especificar unha **variable específica para o job**. [Más info](https://docs.github.com/en/actions/learn-github-actions/variables)

```yaml
jobs:
  probas:
    name: Probas 🏗️
    runs-on: ubuntu-latest
    env:
      NOMBRE: "Mundo"
```

Neste punto xa podemos especificar un step dentro do job. Podemos comezar polo checkout para poder acceder ós arquivos do repositorio:

```yaml
    steps:
      - name: Checkout repository 🛎️
        uses: actions/checkout@v3
```

E o segundo step será o encargado de enviar o saúdo. Ademais engadimos a data mediante unha **variable que actuará só a nivel de step**:

```yaml
    steps:
      - name: Dicir ola 👋
        run: |
          echo -e "$RED $SAUDO$NOMBRE. Hoxe é $DIA! red"
          echo -e "$GREEN $SAUDO$NOMBRE. Hoxe é $DIA! green"
          echo -e "$YELLOW $SAUDO$NOMBRE. Hoxe é $DIA! yellow"
          echo -e "$BLUE $SAUDO$NOMBRE. Hoxe é $DIA! blue"
          echo -e "$PINK $SAUDO$NOMBRE. Hoxe é $DIA! pink"
          echo -e "$CYAN $SAUDO$NOMBRE. Hoxe é $DIA! cyan"
          echo -e "$WHITE $SAUDO$NOMBRE. Hoxe é $DIA! white"
          echo -e "$NORMAL $SAUDO$NOMBRE. Hoxe é $DIA! normal"
          echo -e "$NORMAL $SAUDO$RED$NOMBRE. $GREEN Hoxe é $YELLOW$DIA! varios $NORMAL"

        env:
          DIA: "Luns"
```

Con isto xa vimos cada unha das partes dun workflow básico. Ademais, definimos variables en distintos `scopes` para ver como se comportan.

Se engadimos estes cambios a unha rama e os subimos, poderemos ver que ó crear a pull request dispararase o workflow. Cada cambio que efectuemos na rama, reflectirase na pull request e provocará que se dispare o trigger de novo. Na interface de GitHub Actions vese así:

![](../_media/04_workflow/workflow-example01.webp)

Xenial! Imos modificar o workflow para ver algo máis complexo.

## Engadimos complexidade

Imos engadir un step que se execute nun novo runner, en concreto, nun contedor ubuntu 20.04 ([Máis info de standard hosted](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners)). Este runner executarase de xeito paralelo. Simplemente, envía un novo saúdo en cor.

```yaml
      - name: Executar en paralelo 🐳
        uses: ubuntu-20.04
        with:
          entrypoint: /bin/sh
        run: echo -e "$GREEN Ola dende un contedor! $NORMAL"
```

Ademais, imos recoller información do contedor cos comandos  `whoami`, `free -h` e `ps aux` para gardalo no ficheiro `info.txt` (gárdase dentro do runner) e o amosaremos.

```yaml
      - name: Recoller información do contedor 📝
        with:
          entrypoint: /bin/sh
        run: |
          whoami > info.txt
          free -h >> info.txt
          ps aux >> info.txt
          cat info.txt
```

![](../_media/04_workflow/workflow-example02.webp)

Para poder recuperar o documento info.txt creado debemos engadir un step coa action [upload-artifact@](https://github.com/actions/upload-artifact) que o subirá coma un artefacto que poderemos utilizar dende outros runners.

```yaml
      - name: Upload info.txt 📤
        uses: actions/upload-artifact@v4
        with:
          name: info
          path: ./info.txt
```

Agora imos engadir un novo job que dependa do job `paralelo` para ver como se comporta. Neste caso imos instalar [Bats](https://bats-core.readthedocs.io/en/stable/installation.html), un framework de testing para Bash. Utilizaremos Node.js para instalalo e comprobar a versión.

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

Necesitaremos crear un arquivo `test.bats` na raíz. Para comprobar que temos o ficheiro `info.txt` no novo runner, tan só imos comprobar que existe:

```bash
@test "Check if the file exists" {
  run ls info.txt
  [ "$status" -eq 0 ]
}
```

Agora xa podemos incluír no noso workflow outro step para executar o test de Bats.

```yaml
      - name: Executar test de Bats 🦇
        run: bats test.bats
```

E, para finalizar, engadimos un step neste job para descargar o artefacto coa action [download-artifact](https://github.com/actions/download-artifact).

```yaml
      - name: Download info.txt 📥
        uses: actions/download-artifact@v4
        with:
          name: info
          path: ./info.txt
```

![](../_media/04_workflow/workflow-example03.webp)

## Visión xeral do workflow

![](../_media/04_workflow/workflow-example04.webp)

1. Pódese ver como os jobs `Probas` e `Paralelo` execútanse en paralelo.
2. Pódese ver a dependencia do job `Check Bats version` do job `Paralelo`.
3. O artifact que subimos o job `Paralelo` queda no workflow cun ficheiro .zip descargable.

Arquivos: 
- [color-test.yaml](../_media/04_workflow/color-test.yaml)
- [test.bats](../_media/04_workflow/test.bats)


Parabéns! 🎉 Chegaches ó final deste capítulo. Agora podes seguir practicando con outros workflows que che interesen. Algunhas ideas: https://github.com/sdras/awesome-actions/blob/main/ideas.md 

## Outros recursos interesantes

- [Actions Runners Controller (ARC)](https://github.com/actions/actions-runner-controller) - operador de Kubernetes que orquestra e escala executores autoaloxados para GitHub Actions.
- [Dagger](https://dagger.io/) - linguaxe de programación de fluxo de traballo de código aberto que permite ós desarrolladores definir fluxos de traballo de CI/CD coma código. Temos un [curso de Dagger](https://prefapp.github.io/formacion/cursos/dagger/#/) en Prefapp.
- [GitHub Actions con Docker](https://github.com/marketplace?type=actions&query=docker+) - GitHub Actions ten soporte nativo en Docker, co cal podes probalo en local ou integralo con outras ferramentas como Kubernetes ou Jenkins.
- [Características avanzadas](https://docs.github.com/en/actions/using-workflows/about-workflows#advanced-workflow-features) - Explora a documentación de Github, que paga moito a pena: almacenamento de segredos, jobs dependentes, matrices de variables, caché, etc
