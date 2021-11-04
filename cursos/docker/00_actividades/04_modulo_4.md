# Actividades: Familiarizarse e traballar cos Dockerfiles


Nesta tarefa, imos adicar o noso tempo a traballar co sistema de Dockerfiles e crear as nosas imaxes de contedores. 

Para poder traballar coas nosas imaxes imos comezar por construir o noso propio registry de imaxes. Neste senso, empregaremos o software de [registry](https://hub.docker.com/_/registry/) de Docker. Podedes atopar información de despregue [aquí](https://docs.docker.com/registry/deploying/).

Logo de ter creado o noso registry propio, imos almacenar nel as imaxes que produciremos para o proxecto de docker-meiga.

## O proxecto docker-meiga

Temos un proxecto que se chama [docker-meiga](https://github.com/prefapp/docker-meiga), trátase dunha web en html5 cun motor en PHP. 

O proxecto vaise despregar nun contedor, e hai que construi-lo Dockerfile da imaxe. 

### Requisitos
- A imaxe para a versión 1 (a que temos agora) precisa de PHP.
- Pódemos emprega-la imaxe oficial de [php](https://hub.docker.com/_/php/) que hai en dockerhub (php:7.2).
- Como servidor web usarémo-lo [interno de PHP](http://php.net/manual/es/features.commandline.webserver.php).
- A aplicación precisa de dúas variables de entorno definidas (CURSO e DOCENTE).

### Procedemento de construcción

Partindo da imaxe fonte:
- Hai que instala-lo software necesario para clona-lo [repo](https://github.com/prefapp/docker-meiga).
- Establece-lo como ruta de traballo.
- Defini-lo entorno que sexa preciso (docente co seu nome, nome de este curso...).
- Lanzar o servidor web.

### Pasos a realizar: 

1. Consultar e analizar a documentación sobre [imaxes e contedores](https://prefapp.github.io/formacion/cursos/docker-images/#/./01_creacion_de_imaxes/01_revisando_as_imaxes_o_overlayfs).
1. Nun pdf, os capturas de pantalla de todo o necesario para:
  1. Crear unha imaxe a partir da oficial de registry co seguinte nome: #nome-registry, sendo #nome o nome de pila do alumno.
  1. Lanzar unha instancia do registry coa imaxe creada, esta instancia ten que reuni-los seguintes requisitos:
    -  O nome do contedor será #nome-registry-formacion, sendo #nome o nome de pila do alumno. 
    -  O registry ten que correr no porto 5050.
    - Precisamos que teña almacenamento persistente, nun directorio da máquina anfitrión.
  1. Crear unha imaxe para o docker-meiga:
    - Dockerfile de construcción da imaxe de docker meiga segundo os requisitos establecidos. 
    - O comando de construcción da imaxe (a imaxe ténse que chamar docker-meiga).
    - O comando de subida da imaxe ó rexistro privado de imaxes do punto anterior. 
  1. O comando de lanzamento dun contedor baseado na imaxe de docker-meiga:
    - Ten que correr como un demonio.
    - O porto de conexión ten que ser o 8000.
    - O nome do contedor será meiga-v1.
    - Aportar unha captura do navegador coa aplicación web funcionando.
1. Mellorando o Dockerfile:
  - No pdf aportar un dockerfile que reduza o tamaño da imaxe final.
1. Permitir varias ramas no Dockerfile:
  - Aportar un novo Dockerfile onde se poidan establecer distintas ramas do repo coincidindo con distintas versión da aplicación. A versión a construir pasaráse como un argumento no momento de construí-la imaxe. O nome do argumento será a rama.  

### Avaliación

**Evidencias da adquisición dos desempeños:** Pasos 2, 3 e 4 correctamente realizado segundo estes...

**Indicadores de logro:** debes...
- Entregar un pdf cos
  1. Comandos para montar o registry privado. 
  1. O Dockerfile de creación da imaxe.
  1. Os comandos para correr un contedor coa imaxe.
  1. O Dockerfile de mellora.
  1. O Dockerfile con ramas.

**Criterios de corrección:**
- Registry privado (máx 10 puntos):
  - 2 puntos de ter creada a imaxe do registry
  - 4 puntos se o comando de arranque do registry privado é correcto
  - 4 puntos se a configuración da persistencia é correcta
- Imaxe e contedor de docker-meiga (max de 20 puntos):
  - 6 puntos se o Dockerfile de construcción da imaxe de meiga é correcto
  - 2 puntos se o comando de construcción da imaxe é correcto
  - 2 puntos se os comandos de subida da imaxe ó registry privado son correctos.
  - 8 puntos se o comando de arranque do contedor é correcto.
  - 2 puntos se hai adxunta unha imaxe do navegador coa aplicación correndo
- Imaxe mellorada:
  - 5 puntos se a imaxe do Dockerfile reduce o tamaño da imaxe do punto anterior
- Imaxe con ramas:
  - 5 puntos se o Dockerfile acepta rama.

**Autoavaliación:** Autoavalíate aplicando os indicadores de logro e mesmo os criterios de corrección. 

**Heteroavaliación:** A titoría avaliará e cualificará a tarefa.

**Peso na cualificación:**
- Peso desta tarefa na cualificación final  ........................................ 40 puntos
- Peso desta tarefa no seu tema ...................................................... 40 %