
# build_and_dispatch

El workflow **Build and Dispatch** está diseñado para construir y publicar imágenes de contenedor automáticamente cuando se realiza un push a la rama principal o cuando se crea un release (prereleased o released) en el repositorio. Además, se encarga de despachar cambios para su despliegue en otros sistemas. 


## Evento Trigger: `release` y `push`

Este workflow se activa mediante dos eventos:
- `release`: Cuando se crea o actualiza un prerelease o release.
- `push`: Cuando se realiza un push a la rama `main`.


## Variables de Entorno Globales

- `REGISTRY`: Registro de contenedores (ghcr.io).
- `IMAGE_NAME`: Nombre de la imagen, basado en el repositorio de GitHub.
- `repo_state_name`: Nombre del repositorio de estado.


## Job 1: `calculate_matrix`

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


## Job 2: `build-image`

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


## Job 3: `make-dispatches`

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

