
# Workflows utilizados en Prefapp: release-please

El workflow release-please está diseñado para automatizar la gestión de versiones y lanzamientos en un repositorio de GitHub. Este workflow utiliza la acción [release-please](https://github.com/googleapis/release-please) de Google para gestionar las versiones y lanzamientos del proyecto basado en [semver](https://prefapp.github.io/formacion/cursos/git/es/#/./03_prefapp_methodology/01_forking_strategy?id=versionado-sem%c3%a1ntico).

![](https://raw.githubusercontent.com/googleapis/release-please/main/screen.png)

Vamos a ver cada sección y cada paso del workflow de GitHub Actions [release-please]():


## Evento que activa el workflow

```yaml
on:
  push:
    branches:
      - main
```
- **on**: Especifica el evento que activa el workflow.
- **push**: El workflow se activará cuando haya un push.
- **branches**: Lista de ramas en las que debe ocurrir el push para activar el workflow, aquí `main`.


## Nombre del workflow

```yaml
name: Run Release Please
```
- **name**: Este es el nombre del workflow, en este caso `Run Release Please`.


## Job: release-please

```yaml
jobs:
  release-please:
    name: Release Please Manifest
    runs-on: ubuntu-latest
    steps:
      - uses: google-github-actions/release-please-action@v3
        id: release
        with:
          command: manifest
          token: ${{secrets.GITHUB_TOKEN}}
          default-branch: main
```
- **release-please**: Nombre del job.
- **name**: Nombre descriptivo del job, `Release Please Manifest`.
- **runs-on**: Especifica el sistema operativo en el que se ejecutará el job, aquí `ubuntu-latest`.


### Pasos del job

```yaml
    steps:
      - uses: google-github-actions/release-please-action@v3
        id: release
        with:
          command: manifest
          token: ${{secrets.GITHUB_TOKEN}}
          default-branch: main
```
- **steps**: Lista de pasos a ejecutar en el job.
  - **uses**: Utiliza una acción externa, en este caso `google-github-actions/release-please-action@v3`.
  - **id**: Identificador del paso, `release`.
  - **with**: Parámetros para la acción.
    - **command**: Comando a ejecutar, aquí `manifest`.
    - **token**: Token de autenticación de GitHub, obtenido de los secretos del repositorio (`secrets.GITHUB_TOKEN`).
    - **default-branch**: Rama principal del repositorio, aquí `main`.

