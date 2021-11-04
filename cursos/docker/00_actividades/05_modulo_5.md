# Módulo 4: Aplicacións e servizos multi-contedor

## Deseñar e implantar unha solución co docker-compose para docker-meiga

> Antes de realizar a tarefa le atentamente as **instrucións**, os **indicadores de logro** e os **criterios de corrección** que de seguido se detallan.

Imos mellorá-la nosa aplicación de docker-meiga (a do tema 3) engadíndolle estado. 

A versión 2 da nosa meiga ten varias características novas con respecto a v1:

- Conéctase a unha bbdd para ter estado.
- A aplicación agora reconta o número de visitas. 
- Tamén controla o tamaño da lúa que pode menguar ou crecer. 

### Nova infraestructura

Na nova infraestructura da nosa aplicación teremos que construir:

A) Servizo de bbdd

Terá:

- Imaxe de [mysql oficial](https://hub.docker.com/_/mysql/) (a de dockerhub) versión 5.7. 
- Esa imaxe contrólase por variables de entorno:
  - MYSQL_ROOT_PASSWORD: determina-lo password do root do Mysql.
  - MYSQL_DATABASE: crea esta bbdd se non existe ó arranca-lo contedor. 
- O servizo deberá arrancar cunha base de datos definida, de nome meiga. 

B) Servizo de Aplicación

A aplicación de docker-meiga é a versión [v2](https://github.com/prefapp/docker-meiga.git).

As súas características:

- A imaxe a empregar será a do [v2](https://hub.docker.com/r/prefapp/docker-meiga/) (en dockerhub)  prefapp/docker-meiga:v2
- Ten tódalas variables de entorno da v1 (ver tarefa 3.4 do módulo anterior)
- Presenta, ademáis, novas variables:
  - MYSQL_HOST: o host onde realiza-la conexión.
  - MYSQL_USER: o usuario da bbdd. 
  - MYSQL_PASSWORD: o contrasinal de acceso.
  - MYSQL_DATABASE: o nome da bbdd de traballo. 
- A aplicación, ó iniciarse, realizará a creación das táboas que precise, de non existir, de xeito idempotente. 

### O docker-compose

No docker-compose terán que existir estes dous servizos. Ademáis, compre definir as variables de entorno que controlen a bbdd e establecer tamén esas credencias de acceso no servizo de app (o de php). 

Existirán dúas redes, unha privada (**rede-meiga**) na que estarán conectados o contedor de bbdd e o de aplicación, e unha público (**rede-publica**) onde estará únicamente o contedor de php. 

Compre establecer un volume (**datos-meiga**) para darlle persistencia ós datos do mysql.

Pasos:

1. **Planificar e crear** un docker-compose.yaml que cumpla coas especificacións referidas.
- Nun pdf entregar o docker-compose.yaml creado ou adxuntar na tarefa o ficheiro do docker-compose.yaml.
2. **Lanzar** unha instancia do docker-meiga v2. 
- No pdf amosar os comandos necesarios para arrincar a instancia ou o asciinema do mesmo. 
- No pdf ou adxuntar á tarefa unha captura do navegador coa web funcionando.
  - A lúa ten que estar chea (pista: sucesivos clicks na lúa a fan avanzar no seu ciclo)
  - Ten que verse o nome do docente (contrólase mediante variable de entorno)
3. **Mostrar** nunha sección do pdf ou en asciinema os comandos necesarios para:
- Reiniciar tódolos servizos sen pérdida de datos. 
- Poder ver os logs .
- Reiniciar só o servizo da aplicación e non o de bbdd. 
- Destruir completamente a aplicación, os seus contedores e o volume de datos. 
4. **Revisar** a creación de imaxes, nunha sección do pdf ou en ficheiro aparte, remitir o Dockerfile necesario para:
- Crear a imaxe de docker-meiga v2
  - partir da imaxe de php.
  - hai que instalar git e clona-lo proxecto de [docker-meiga](https://github.com/prefapp/docker-meiga.git) na rama v2
  - compre instalar o módulo mysqli (pista: ver os [comandos auxiliares](https://hub.docker.com/_/php/) que ofrece a imaxe para extensións).
5. **Modificar** o docker-compose orixinal para permitir o [build](https://docs.docker.com/compose/compose-file/#build) da imaxe dende o mesmo. Adxuntar mellora en ficheiro ou nunha nova sección do pdf.

**Evidencias de adquisición dos desempeños**: pasos 1 a 5.

**Indicadores de logro**: deberás ter:

- PDF ou zip con:
  - docker-compose de aplicación docker-meiga v2 segundo as especificacións fornecidas.
  - capturas ou asciinema dos comandos necesarios para:
    - lanzar unha nova instancia.
  - captura do navegador coa web funcionando:
    - a lúa ten que estar chea.
    - o nome do docente tense que ver.
 - capturas ou asciinema dos comandos necesarios para:
   - reiniciar tódolos servizos sen pérdida de datos. 

**Autoavaliación**: Revisa e autoavalia o teu traballo aplicando os indicadores de logro.

**Criterios de corrección**:

1. Paso 1
- Docker compose correcto segundo as especificacións (max. 10 puntos)
2. Paso 2
- Comandos para lanzar a instancia segundo as especificacións (max. 5 puntos)
- Captura da web funcionando (max. 5 puntos)
3. Paso 3
- Comandos de control da instancia (2.5 puntos cada un ata un máx de 10 puntos)
4. Paso 4
- Dockerfile de creación da v2 de meiga correcto (max. 15 puntos)
5. Paso 5
- Build dentro do dockerfile (max. 5 puntos)

**Peso na cualificación**:

Peso desta tarefa no seu tema............................................... 50%

## Empregar a ferramenta docker-compose para a orquestación de contedores

> Antes de realizar a tarefa le atentamente as **instrucións**, os **indicadores de logro** e os **criterios de corrección** que de seguido se detallan.

### Web do "gatinho do día"

Para esta tarefa compre ter construida a imaxe dos "[gatinhos do día](https://prefapp.github.io/formacion/cursos/docker-images/#/./01_creacion_de_imaxes/05_o_dockerfile_construindo_a_imaxe_do_gatinho_do_dia)". Tarefa do módulo 3.

Pasos:

1. **Instala** o docker-compose na túa máquina seguindo estas [instruccións](https://docs.docker.com/compose/install/#install-compose):
 - Nun pdf amosa a captura do comando "docker-compose version".
2. **Experimenta** co docker-compose. No pdf, amosa as capturas dos comandos para que:
 - Arrancar a web-gatinhos en primeiro plano e demonizada. 
 - Os comandos para deter e rearrancar a web **sen borrar os contedores**. 
 - Cómo borrarías os contedores creados unha vez lanzado o compose?
3. **Investiga** as opcións de construcción de imaxe do compose.
 - Poderíase solicitar o build da imaxe dende o docker-compose? De ser o caso, adxunta un docker-compose no que se constrúa a imaxe. 
 - Como se borrarían as imaxes creadas localmente a partir do compose?

**Evidencias da adquisición dos desempeños**: Paso 1 a 3.

**Indicadores de logro**: deberás ter.

- Instalado o docker-compose.
- PDF adxunto con:
  - Captura de version do docker-compose.
  - Sección cos:
    - Comandos para arrancar a web en primeiro plano e demonizado.
    - Deter a web sen borrar os contedores e rearrancala.
    - Deter a web e borrar os contedores asociados.
  - Sección cos comandos e compose para:
    - Facer un build da imaxe .
    - Comando para borrar as imaxes locais.

**Autoavaliación**: Revisa e autoavalia o teu traballo aplicando os indicadores de logro.

**Criterios de corrección**:

- Paso 1
  - Ter instalado correctamente o docker-compose (**max. 10 puntos**).
- Paso 2
  - Sección no pdf coas capturas dos comandos para (**max. 15 puntos**).
    - Arrancar o compose en primeiro plano e demonizado (5 puntos).
    - Deter o compose sen borrar contedores e rearrancalo (5 puntos).
    - Deter o compose e borrar os contedores (5 puntos).
- Paso 3
  - Sección no pdf coas capturas dos comandos e o compose necesario para (**max 15 puntos**).
    - Construir a imaxe de "o gatinho do día dende o compose" (10 puntos).
    - Borrar as imaxes locales construidas polo compose (5 puntos).

**Peso na cualificación**:
- Peso desta tarefa no seu tema .............................40%

