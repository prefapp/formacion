# Módulo 3: Xestión de Imaxes e Contedores

## Explorar e comprender os fundamentos das imaxes de contedores

> Unha imaxe é unha planiña de creación de contedores. Contén todo o software base, librarías e utilidades que requiren os procesos aloxados no contedor para funcionar.

\**Nota - Antes de realizar a tarefa le atentamente as **instrucións**, os **indicadores de logro** e os **criterios de corrección** que de seguido se detallan.

1. **Consultar** e **analizar** a documentación sobre  [imaxes e contedores](https://prefapp.github.io/formacion/cursos/docker/#/./03_xestion_de_imaxes_e_contedores/01_obxectivos).
2. **Crear** unha conta en [Dockerhub](https://hub.docker.com/). A pesares de que non é necesario estar rexistrado no Dockerhub para poder descargar imaxes, sí que imos precisar ter conta para poder subir as nosas imaxes.

Cree unha conta no dockerhub. É gratuito e a imos empregar para subir os nosos traballos e distribuilos.

- 1. Unha vez creada a conta, ingresar na páxina de dockerhub.
- 2. Ir á lapela de perfil (profile) e quitar unha captura de pantalla.
Enviar á captura ós coordinadores mediante unha mensaxe privada.

**Evidencias da adquisición dos desempeños**: Paso 2 e 3 correctamente realizados segundo estes...

**Indicadores de logro**: debes...

1. Ter feito o cuestionario do paso 2. 
2. Ter creada unha conta no dockerhub e enviada a captura ós coordinadores. 
Criterios de corrección:

- **4 puntos** se ten contestado ó cuestionario. 
- **6 puntos** se ten creado o perfil en Dockerhub e enviada a captura ós coordinadores.

**Autoavaliación**: Autoavalíate aplicando os indicadores de logro e mesmo os criterios de corrección.

**Heteroavaliación**: A titoría avaliará e cualificará a tarefa.

**Peso na cualificación**:

- Peso desta tarefa na cualificación final  .................... 4 puntos
- Peso desta tarefa no seu tema .................................. 16 %

## Traballar cos comandos de xestión de imaxes.

> Tal e como indicamos, as imaxes de Docker deben estar instaladas **localmente** para poder ser empregadas nos contedores que corran na máquina.

Docker ofrece un conxunto de comandos que nos permiten xestionar as imaxes, tanto a nivel local, como a nivel da súa relación cos repositorios de imaxes.

Para realizar esta tarefa, compre crear un documento onde iremos rexistrando os comandos e capturas que se precise enviar. Despois, se exportará un pdf a adxuntar.

Pasos:

1. **Consultar** e **analizar** a documentación sobre [imaxes e contedores](https://prefapp.github.io/formacion/cursos/docker/#/./03_xestion_de_imaxes_e_contedores/01_obxectivos).
2. **Investigar** e **compilar** as opcións do comando docker images
 1. O comando expón unha axuda (docker images --help) ou pódese consultar na [documentación oficial](https://docs.docker.com/engine/reference/commandline/images/).
 2. No pdf, crear unha sección "1" onde se expoñerán as opcións do comando docker images e un resumo sobre a súa función.
3. **Investigar** sobre os digests de imaxes.
 1. No pdf crea una sección "2" onde respostarás ás seguintes preguntas:
 - 1. Qué é un digest de imaxe?
 - 2. Cal é a súa relación cos tags de imaxe?
 - 3. Por qué son importantes para despregues en entornos "de producción"?
 2. Pódese atopar información neste [artigo](https://engineering.remind.com/docker-image-digests/), na documentación [oficial de docker](https://docs.docker.com/engine/reference/commandline/images/#list-the-full-length-image-ids) e neste [blogue](https://windsock.io/explaining-docker-image-ids/).
4. **Traballar** cos comandos de docker para imaxes:
 1. No pdf, crear unha sección "3" onde se farán capturas dos comandos necesarios para:
 - 1. Descargar a imaxe library/hello-world do DockerHub.
 - 2. Comprobar que está realmente almacenada na máquina.
 - 3. Lanzar un contedor que monte esta imaxe e comprobar que realmente imprime a mensaxe de benvida pola pantalla.
 - 4. Borrar a imaxe library/hello-world da máquina local.

Cando remates a tarefa:

1. Preme máis abaixo o botón "Engadir entrega" e adxunta o pdf.
2. Unha vez revisada pola titoría poderás ver o feedback entrando novamente na tarefa ou no libro de cualificacións.

---

**Evidencias da adquisición dos desempeños**: Paso 2, 3 e 4 correctamente realizados segundo estes...

**Indicadores de logro**: a teu pdf debe ter completadas...

1. A sección "1" onde se vexan:
 - O resumo das opcións do docker images.
2. A sección "2" onde se poida apreciar:
 - A túa resposta ás preguntas formuladas sobre os digest das imaxes.
3. A sección "3" que deberá contar:
 - Cos comandos correctamente configurados para realizar as accións descritas no punto 4.

**Criterios de corrección**:

- **8 puntos** se ten feito o resumo das opcións do comando docker images na sección "1" do pdf.
- **4 puntos** por cada pregunta correctamente respondida, ata un máximo de **12 puntos**, na sección "2" do pdf.
- **5 puntos** por cada resposta correcta, ata un máximo de **20 puntos**, na sección "3" do pdf.

**Autoavaliación**: Autoavalíate aplicando os indicadores de logro e mesmo os criterios de corrección.

**Heteroavaliación**: A titoría avaliará e cualificará a tarefa.

**Peso na cualificación**:

- Peso desta tarefa na cualificación final  ......................... 4 puntos
- Peso desta tarefa no seu tema .......................................... 16 %
