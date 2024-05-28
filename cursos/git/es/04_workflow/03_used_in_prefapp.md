
# Workflows utilizados en Prefapp

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../../_media/04_workflow/prefapp_wf.webp)

  </div>
</div>

Antes de comenzar, es importante tener en cuenta las buenas prácticas para crear workflows en GitHub Actions:

- Fortalecer la seguridad en Github Actions: https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions

Veamos los workflows más usados por partes para poder entenderlos mejor.

- [PR-verify](#pr-verify)
- [release-please](#release-please)
- [build_and_dispatch](#build_and_dispatch)
- [publish-chart](#publish-chart)


## PR-verify

El workflow PR-verify se encarga de verificar los cambios introducidos en un Pull Request (PR) en un repositorio de GitHub. Este workflow automatiza una serie de tareas esenciales para asegurar la calidad y la coherencia de los cambios antes de integrarlos en la base de código principal. 

Vamos a ver cada sección y cada paso del workflow de GitHub Actions [PR-verify]():


### Workflow

```yaml
name: PR-verify
```
- **name**: Este es el nombre del workflow.


### Evento que activa el workflow

```yaml
on:
  pull_request:
```
- **on**: Especifica el evento que activa el workflow. Aquí, se activará cada vez que se cree una pull request.


### Variables de entorno globales

```yaml
env:
  VERSION: 2.0.0
```
- **env**: Define variables de entorno globales para el workflow. La `VERSION` está establecida en `2.0.0`.


### Job 1: check-changes

```yaml
jobs:
  check-changes:
    runs-on: ubuntu-latest
    outputs:
      changed: ${{ steps.calculate_changes.outputs.changed }}
      changed_files: ${{ steps.calculate_changes.outputs.changed_files }}
    steps:
      - name: Calculate changes
        id: calculate_changes
        uses: dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50 # v2.11.1
        with:
          list-files: json
          filters: |
            changed:
              - '**.yaml'
              - '**.yml'
              - '!.github/**'
```
- **runs-on**: Especifica el sistema operativo en el que se ejecutará el job, aquí `ubuntu-latest`.
- **outputs**: Define las salidas del job, que se calcularán en uno de los pasos.
- **steps**: Lista de pasos a ejecutar en el job.
  - **Calculate changes**: 
    - **id**: Identificador del paso, `calculate_changes`.
    - **uses**: Utiliza una acción externa `dorny/paths-filter` para calcular los archivos cambiados.
    - **with**: Parámetros para la acción, listando los tipos de archivos a verificar (`**.yaml`, `**.yml`, excluyendo `.github/**`).


### Job 2: determine-target

```yaml
  determine-target:
    runs-on: ubuntu-latest
    needs: check-changes
    if: needs.check-changes.outputs.changed == 'true'
    outputs:
      TENANT: ${{ env.TENANT }}
      APP: ${{ env.APP }}
      ENV: ${{ env.ENV }}
    env:
      FILES: ${{ needs.check-changes.outputs.changed_files }}
    steps:
      - uses: actions/checkout@v4
      - name: Eval changes
        uses: actions/github-script@v6.4.1
        with:
          script: |
            const script = require('./.github/evaluate_changes.js')
            script({core, context})
      - name: Check target (tenant, app and env) exist
        run: |
          target=${{ env.TENANT }}/${{ env.APP }}/${{ env.ENV }}
          [ -d "$target" ] || (echo "target $target path doesn't exists" && exit 1)
```

- **needs**: Este job depende de la finalización del job `check-changes`.
- **if**: Condicional que determina si el job se ejecuta basado en la salida del job `check-changes`.
- **outputs**: Define salidas del job, usando variables de entorno.
- **steps**: Lista de pasos a ejecutar en el job.
  - **Eval changes**:
    - **uses**: Utiliza la acción `actions/github-script` para ejecutar un script de Node.js.
    - **script**: El script está definido en `./.github/evaluate_changes.js`.
  - **Check target (tenant, app and env) exist**:
    - **run**: Verifica si la ruta del objetivo existe.


### Job 3: linter

```yaml
  linter:
    runs-on: ubuntu-latest
    needs: determine-target
    if: needs.determine-target.outputs.TENANT != ''
    env:
      TENANT: ${{ needs.determine-target.outputs.TENANT }}
      APP: ${{ needs.determine-target.outputs.APP }}
      ENV: ${{ needs.determine-target.outputs.ENV }}
    steps:
      - uses: actions/checkout@v4
      - name: Linter yaml principal
        uses: ibiqlik/action-yamllint@81e214fd484713882ce4237cb7cd264d550856cf # v3.1.0
        with:
          file_or_dir: ${{ env.TENANT }}/${{ env.APP }}/${{ env.ENV }}
          format: github
          config_data: |
            extends: default
            ignore: |
              secrets.yaml
            rules:
              document-start: enable
              line-length:
                max: 1000
              trailing-spaces:
                level: warning
```
- **needs**: Este job depende de la finalización del job `determine-target`.
- **if**: Condicional que determina si el job se ejecuta basado en la salida del job `determine-target`.
- **env**: Define variables de entorno para el job.
- **steps**: Lista de pasos a ejecutar en el job.
  - **Linter yaml principal**:
    - **uses**: Utiliza la acción `ibiqlik/action-yamllint` para realizar linting en archivos YAML. Es buena práctica utilizar un SHA específicando el commit cuando la action es de terceros.
    - **with**: Parámetros para la acción, especificando el archivo o directorio a revisar y la configuración del linter.


### Job 4: validate-release

```yaml
  validate-release:
    runs-on: ubuntu-latest
    needs: determine-target
    if: needs.determine-target.outputs.TENANT != ''
    env:
      TENANT: ${{ needs.determine-target.outputs.TENANT }}
      APP: ${{ needs.determine-target.outputs.APP }}
      ENV: ${{ needs.determine-target.outputs.ENV }}
    steps:
      - uses: actions/checkout@v4
      - name: Edit cloud_providers.json
        shell: bash
        run: |
          update_json() {
            local secret_json="$1"
            local secret_value="$2"
            local json_path=".github/cloud_providers.json" 
            echo $(jq --arg a "$secret_value" "$secret_json = \$a" "$json_path") > "$json_path"
          }
          update_json '.dev.aws_config.aws_access_key_id' "${{ secrets.AWS_ACCESS_KEY_DEV }}"
          update_json '.dev.aws_config.aws_secret_access_key' "${{ secrets.AWS_SECRET_ACCESS_KEY_DEV }}"
          update_json '.pre.aws_config.aws_access_key_id' "${{ secrets.AWS_ACCESS_KEY_PRE }}"
          update_json '.pre.aws_config.aws_secret_access_key' "${{ secrets.AWS_SECRET_ACCESS_KEY_PRE }}"
          update_json '.pro.aws_config.aws_access_key_id' "${{ secrets.AWS_ACCESS_KEY_PRO }}"
          update_json '.pro.aws_config.aws_secret_access_key' "${{ secrets.AWS_SECRET_ACCESS_KEY_PRO }}"

      - name: Set provider
        id: set-cloud-info
        uses: actions/github-script@v6.4.0
        with:
          result-encoding: string
          script: |
            const cloud_config = require('.github/cloud_providers.json');
            const {ENV} = process.env;
            const provider = cloud_config[ENV].provider;
            core.exportVariable('CLUSTER_NAME', cloud_config[ENV].cluster_name);
            core.exportVariable('IMAGE_REPOSITORY_NAME', cloud_config[ENV].image_repository_name);
            console.log("PROVIDER=" + provider);
            if (provider == "azure"){
              core.exportVariable('AKS_RESOURCE_GROUP', cloud_config[ENV].azure_config.aks_resource_group);
              core.exportVariable('AZURE_CREDENTIALS', cloud_config[ENV].azure_config.az_credentials);
            } else if (provider == "aws"){
              core.exportVariable('AWS_KEYS', cloud_config[ENV].aws_config);
              core.exportVariable('AWS_REGION', cloud_config[ENV].aws_config.aws_region);
            } else if (provider == "do"){
              core.exportVariable('DO_TOKEN', cloud_config[ENV].do_config.do_personal_access_token);
              core.setSecret(cloud_config[ENV].do_config.do_personal_access_token);
            }
            return provider

      - name: Setup / Install helm, helmfile y helm-secrets
        uses: mamezou-tech/setup-helmfile@03233e1cd9b19b2ba320e431f7bcc061

8db4248d # v2.0.0
        with:
          helmfile-version: v0.161.0
          helm-version: v3.13.3
          additional-helm-plugins: https://github.com/jkroepke/helm-secrets --version v4.5.1

      - name: Install sops
        run: |
          wget -O /home/runner/bin/sops https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux
          chmod +x /home/runner/bin/sops

      - id: azure-login
        if: ${{ steps.set-cloud-info.outputs.result == 'azure' }}
        uses: prefapp/composite-action-login-azure@v1
        with:
          creds: ${{ env.AZURE_CREDENTIALS }}
          resource-group: ${{ env.AKS_RESOURCE_GROUP }}
          cluster-name: ${{ env.CLUSTER_NAME }}
          repository-name: ${{ env.IMAGE_REPOSITORY_NAME }}

      - id: aws-login
        if: ${{ steps.set-cloud-info.outputs.result == 'aws' }}
        uses: prefapp/composite-action-login-aws@v1
        with:
            awskeys: ${{ env.AWS_KEYS }}
            cluster-name: ${{ env.CLUSTER_NAME }}
            aws-region: ${{ env.AWS_REGION }}

      - id: digital-ocean-login
        if: ${{ steps.set-cloud-info.outputs.result == 'do' }}
        uses: prefapp/composite-action-login-digitalocean@v1
        with:
            cluster-name: ${{ env.CLUSTER_NAME }}
            auth-token: ${{ env.DO_TOKEN }}

      - name: Set helmfile env var
        run: |
          str=${{ env.IMAGE_REPOSITORY_NAME }}
          upperStr="${str^^}"
          helmfilevar="${upperStr}_PASSWORD"
          echo "HELMFILE_VAR_NAME=$helmfilevar" >> "$GITHUB_ENV"

      - name: Validate release coherence
        run: |
          echo "Validating chart..."
          cd ${{ env.TENANT }}/${{ env.APP }}
          export ${{ env.HELMFILE_VAR_NAME }}=${{ steps.azure-login.outputs.helmfile-creds }}${{ steps.aws-login.outputs.helmfile-creds }}
          helm version
          helmfile -v
          helmfile -e ${{ env.ENV }} template | kubectl create -f - --dry-run

      - name: Download Pluto
        uses: FairwindsOps/pluto/github-action@d8a976c87f8db0c41048dc5450fabbb2a0603c82 # v5.18.4

      - name: Run pluto
        run: |
          echo "Running pluto..."
          cd ${{ env.TENANT }}/${{ env.APP }}
          export ${{ env.HELMFILE_VAR_NAME }}=${{ steps.azure-login.outputs.helmfile-creds }}${{ steps.aws-login.outputs.helmfile-creds }}
          helmfile -e ${{ env.ENV }} template | pluto detect -

      - name: Set up python
        uses: actions/setup-python@65d7f2d534ac1bc67fcd62888c5f4f3d2cb2b236 # v4.7.1
        with:
          python-version: 3.7

      - name: Run Trivy vulnerability scanner in IaC mode
        uses: aquasecurity/trivy-action@fbd16365eb88e12433951383f5e99bd901fc618f # v0.12.0
        with:
          scan-type: 'config'
          hide-progress: false
          scan-ref: '.'
          exit-code: '0'
          ignore-unfixed: true
```

- **needs**: Este job depende de la finalización del job `determine-target`.
- **if**: Condicional que determina si el job se ejecuta basado en la salida del job `determine-target`.
- **env**: Define variables de entorno para el job.
- **steps**: Lista de pasos a ejecutar en el job.
  - **Edit cloud_providers.json**: Actualiza el archivo `cloud_providers.json` con credenciales secretas.
  - **Set provider**: Establece variables de entorno según el proveedor de nube.
  - **Setup / Install helm, helmfile y helm-secrets**: Instala herramientas necesarias.
  - **Install sops**: Instala `sops` para manejar secretos.
  - **azure-login**, **aws-login**, **digital-ocean-login**: Inicia sesión en el proveedor de nube correspondiente.
  - **Set helmfile env var**: Establece una variable de entorno para `helmfile`.
  - **Validate release coherence**: Valida la coherencia del release usando `helmfile` y `kubectl`.
  - **Download Pluto** y **Run pluto**: Descarga y ejecuta `pluto` para detectar recursos Kubernetes en desuso.
  - **Set up python**: Configura Python.
  - **Run Trivy vulnerability scanner in IaC mode**: Ejecuta Trivy para escanear vulnerabilidades en la infraestructura como código.


## release-please

El workflow release-please está diseñado para automatizar la gestión de versiones y lanzamientos en un repositorio de GitHub. Este workflow utiliza la acción [release-please](https://github.com/googleapis/release-please) de Google para gestionar las versiones y lanzamientos del proyecto basado en [semver](https://prefapp.github.io/formacion/cursos/git/es/#/./03_prefapp_methodology/01_forking_strategy?id=versionado-sem%c3%a1ntico).

Vamos a ver cada sección y cada paso del workflow de GitHub Actions [release-please]():


### Evento que activa el workflow

```yaml
on:
  push:
    branches:
      - main
```
- **on**: Especifica el evento que activa el workflow.
- **push**: El workflow se activará cuando haya un push.
- **branches**: Lista de ramas en las que debe ocurrir el push para activar el workflow, aquí `main`.


### Nombre del workflow

```yaml
name: Run Release Please
```
- **name**: Este es el nombre del workflow, en este caso `Run Release Please`.


### Job: release-please

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


#### Pasos del job

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


## build_and_dispatch

El workflow **Build and Dispatch** está diseñado para construir y publicar imágenes de contenedor automáticamente cuando se realiza un push a la rama principal o cuando se crea un release (prereleased o released) en el repositorio. Además, se encarga de despachar cambios para su despliegue en otros sistemas. 


### Evento Trigger: `release` y `push`

Este workflow se activa mediante dos eventos:
- `release`: Cuando se crea o actualiza un prerelease o release.
- `push`: Cuando se realiza un push a la rama `main`.


### Variables de Entorno Globales

- `REGISTRY`: Registro de contenedores (ghcr.io).
- `IMAGE_NAME`: Nombre de la imagen, basado en el repositorio de GitHub.
- `repo_state_name`: Nombre del repositorio de estado.


### Job 1: `calculate_matrix`

Este job calcula la matriz de imágenes que se construirán.

1. **Checkout del Código**
   ```yaml
   - uses: actions/checkout@v4
   ```
   Clona el repositorio en el runner.

2. **Calcular la Matriz**
   ```yaml
   - name: calculate_matrix
     id: calculate_matrix
     uses: prefapp/action-flavour-images-matrix-generator@v3
     with:
       repository: ${{ env.REGISTRY }}/${{ github.repository }}
   ```
   Usa la acción `action-flavour-images-matrix-generator` para calcular y generar la matriz de imágenes.


### Job 2: `build-image`

Este job construye y publica las imágenes de contenedor.

1. **Configuración de Permisos**
   ```yaml
   permissions:
     contents: read
     packages: write
   ```
   Configura los permisos necesarios para leer contenidos y escribir paquetes.

2. **Estrategia de Matriz**
   ```yaml
   strategy:
     matrix: ${{fromJson(needs.calculate_matrix.outputs.matrix)}}
   ```
   Define la estrategia para ejecutar las tareas basadas en la matriz calculada.

3. **Pasos del Job**

   - **Datos de la Matriz**
     ```yaml
     - name: Matrix data
       run: |
           echo ${{ matrix.tags }}
           echo ${{ matrix.build_args }}
           echo ${{ matrix.dockerfile }}
     ```
     Imprime los datos de la matriz.

   - **Clonar el Repositorio**
     ```yaml
     - name: Clone repository
       uses: actions/checkout@v3
     ```
     Clona el repositorio en el runner.

   - **Iniciar Sesión en el Registro de Contenedores**
     ```yaml
     - name: Log in to the Container registry
       uses: docker/login-action@65b78e6e13532edd9afa3aa52ac7964289d1a9c1
       with:
         registry: ${{ env.REGISTRY }}
         username: ${{ github.actor }}
         password: ${{ secrets.GITHUB_TOKEN }}
     ```
     Inicia sesión en el registro de contenedores con las credenciales proporcionadas.

   - **Construir y Publicar la Imagen Completa**
     ```yaml
     - name: Build and push full
       uses: docker/build-push-action@v5
       if: ${{ matrix.dockerfile == 'Dockerfile.full' }} 
       with:
         context: .
         push: true
         file: ${{ matrix.dockerfile }}
         build-args: |
           ${{ matrix.build_args }}
         tags: |
           ${{ matrix.tags }}
           ghcr.io/prefapp/gitops-k8s:latest
     ```
     Construye y publica la imagen completa (Dockerfile.full) si corresponde.

   - **Construir y Publicar la Imagen Slim**
     ```yaml
     - name: Build and push slim
       uses: docker/build-push-action@v5
       if: ${{ matrix.dockerfile == 'Dockerfile.slim' }} 
       with:
         context: .
         push: true
         file: ${{ matrix.dockerfile }}
         build-args: |
           ${{ matrix.build_args }}
         tags: |
           ${{ matrix.tags }}
           ghcr.io/prefapp/gitops-k8s:latest-slim
     ```
     Construye y publica la imagen slim (Dockerfile.slim) si corresponde.


### Job 3: `make-dispatches`

Este job despacha los cambios para su despliegue.

1. **Configurar Variables de Entorno**
   ```yaml
   - name: Set env
     run: echo "state_repo=$GITHUB_REPOSITORY_OWNER/$repo_state_name" >> $GITHUB_ENV
   ```
   Configura las variables de entorno necesarias para el despacho.

2. **Clonar el Repositorio**
   ```yaml
   - name: Clone Repository
     uses: actions/checkout@v2
   ```
   Clona el repositorio en el runner.

3. **Despachar Cambios**
   ```yaml
   - name: Dispatch changes
     uses: prefapp/action-deployment-dispatch@v2
     with:
       state_repo: ${{ env.repo_state_name }}
       image_repository: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
       token: ${{ secrets.PAT_DEPLOY }}
   ```
   Utiliza la acción `action-deployment-dispatch` para despachar los cambios utilizando el repositorio de estado y el token de despliegue.


## publish-chart

El workflow **release-pipeline** está diseñado para facilitar la publicación de nuevos paquetes mediante la automatización de la creación de ramas, la actualización de índices de repositorios Helm, y la generación de Pull Requests (PR) en GitHub. 


### Evento Trigger: `workflow_dispatch`

Este workflow se activa manualmente mediante el evento `workflow_dispatch`, lo cual permite a los usuarios iniciar el proceso proporcionando los siguientes inputs:

- `package`: Nombre del paquete que se va a publicar.
- `version`: Versión del paquete que se va a publicar.

### Variables de Entorno Globales

- `proyecto`: Nombre del proyecto, en este caso, `prefapp`.
- `git_user`: Usuario de Git configurado para las acciones de GitHub (`github-actions`).
- `git_email`: Correo electrónico configurado para las acciones de GitHub (`github-actions@github.com`).

### Definición del Job: `pipeline`

Este único job se encarga de todo el proceso de publicación.

#### Pasos del Job

1. **Checkout del Código**
   ```yaml
   - uses: actions/checkout@v3
   ```
   Este paso clona el repositorio en el runner de GitHub Actions.

2. **Calcular el Nombre de la Rama**
   ```yaml
   - name: Calculating branch name
     id: step-branch
     run: echo "::set-output name=branch::$(echo new-release/${{ inputs.package }}-${{ inputs.version }})"
   ```
   Calcula el nombre de la nueva rama basada en el nombre y la versión del paquete proporcionados.

3. **Mensaje del Commit**
   ```yaml
   - name: Commit Message
     id: step-commit_message
     run: echo "::set-output name=commit_message::$(echo New Chart Release '${{ inputs.package }}-${{ inputs.version }}')"
   ```
   Genera el mensaje del commit utilizando los inputs proporcionados.

4. **Crear Rama con Cambios**
   ```yaml
   - name: Create branch with changes
     run: |
       git config --global user.name ${{ env.git_user }}
       git config --global user.email ${{ env.git_email }}
       git checkout -b ${{ steps.step-branch.outputs.branch }}
       cd charts/${{ inputs.package }} && helm package . -d ../../docs/${{ inputs.package }}
       cd ../../docs/${{ inputs.package }} && helm repo index .
       git add .
       git commit -m "${{steps.step-commit_message.outputs.commit_message}}"
       git push origin ${{ steps.step-branch.outputs.branch }}
   ```
   - Configura el usuario y correo electrónico de Git.
   - Crea una nueva rama basada en el nombre calculado.
   - Genera el paquete Helm y actualiza el índice del repositorio.
   - Añade y commitea los cambios, luego empuja la nueva rama al repositorio remoto.

5. **Crear Pull Request**
   ```yaml
   - name: Create Pull Request
     run: |
       prName="Bump release ${{ inputs.package }}-${{ inputs.version }}"
       docker run -v $(pwd):/repo prefapp/prefapp-cicdpy:sleep-test github.pr_auto_merge \
          token=${{ secrets.GITHUB_TOKEN }} \
          titulo="${prName}" \
          rama_origen=${{ steps.step-branch.outputs.branch }} \
          repo=charts \
          proyecto=${{ env.proyecto }} \
          reviewers='${{ github.actor }}'
   ```
   - Usa un contenedor Docker para ejecutar un script que crea un Pull Request automáticamente.
   - Configura el título del PR, la rama de origen, el repositorio, el proyecto, y asigna el revisor basado en el actor de GitHub que inició el workflow.

---

Repositorio demo para utilizar "[Build and dispatch](https://github.com/prefapp/hello-k8s/blob/main/.github/workflows/build_and_dispatch.yaml)" y "[PR verify](https://github.com/prefapp/hello-k8s/blob/main/.github/workflows/pr_verify.yaml)": [hello-k8s](https://github.com/prefapp/hello-k8s/tree/main/.github).
