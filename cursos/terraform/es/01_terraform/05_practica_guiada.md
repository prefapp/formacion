# Módulo 1: Primeros pasos, configuración e instalación
En esta tarea vamos a preparar nuestro sistema antes de iniciar nuestra infraestructura cloud, todo esto desde cero con [AWS](https://aws.amazon.com/) y [Terraform](https://www.terraform.io/).

Para poder trabajar con el proveedor [AWS](https://aws.amazon.com/) necesitamos la creación de una cuenta en la que utilizaremos el [free tier](https://aws.amazon.com/free) que tenemos en el Basic plan.

Con este [free tier](https://aws.amazon.com/free) tenemos un año de uso completamente gratuito de los servicios especificados siempre con ciertas limitaciones.

El Basic plan es más que suficiente para las prácticas y proyectos que diseñaremos en este curso.
### 1. Instalación de Terraform

Para la instalación de [Terraform](https://www.terraform.io/) podemos acceder a la página de [descargas](https://www.terraform.io/downloads) y allí tenemos todas las opciones para los diferentes SO. Aquí mostraremos un ejemplo de cada uno de los sistemas más utilizados

#### 1.1 Windows
1. Para Windows disponemos de un ejecutable que extraemos después de descargarlo en un directorio de nuestra elección (por ejemplo, c:\terraform).
2. Actualizamos el path de nuestro ejecutable en el path global del sistema:

`Control Panel` -> `System` -> `System settings` -> `Environment Variables` -> `PATH`

3. Abrimos una nueva terminal para que se haga efectivo el cambio
4. Verificamos la configuración de la variable global con el comando terraform:

```shell
terraform -version
```

#### 1.2 macOS
Con el package manager [brew](https://brew.sh/) podemos realizar la instalación en macOS con dos simples comandos:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
#### 1.3 Ubuntu/Debian
Al igual que en macOS tenemos el package manager [brew](https://brew.sh/) para instalarlo de forma idéntica:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

O tenemos, entre otras, la opción [curl](https://curl.se/) y la utilidad [apt](https://linuxize.com/post/how-to-use-apt-command/):

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

#### 1.4 VSCode extension (opcional)
[Visual Studio Code](https://code.visualstudio.com/) es un potente editor de texto que nos permite trabajar de forma muy cómoda y ágil por su versatilidad, facilidad y número de plugins, y que se integra en un muy simple con [Terraform](https://www.terraform.io/).

Para instalar la extensión de [Terraform](https://www.terraform.io/) en [Visual Studio Code](https://code.visualstudio.com/) es tan sencillo como ir a la sección de extensiones, escribimos ` terraform' en el cuadro de búsqueda e instalamos la extensión propia de [HashiCorp](https://www.hashicorp.com/), empresa de [Terraform](https://www.terraform.io/).

Podemos utilizar cualquier otro editor de texto de nuestra preferencia para realizar las actividades, pero por la facilidad de uso e integración con las herramientas que vamos a utilizar, recomendamos [Visual Studio Code](https://code.visualstudio.com/).

### 2. Creación de la cuenta en AWS

Para crear nuestra cuenta, vaya a [aws.amazon.com](https://aws.amazon.com) y cree nuestra cuenta de AWS haciendo clic en el botón en la esquina superior derecha.

![Crear conta](../../_media/crear_aws.png)

Requisitos:
- Cuenta de correo electrónico
- Número de teléfono
- Tarjeta de crédito débito

> ⚠️ El Basic plan de [AWS](https://aws.amazon.com/) tiene costo cero siempre dentro de los [límites de uso](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html), en el momento de crear la cuenta se genera un cargo de $1 USD/EUR en el proceso de verificación el cual queda pendiente. Dentro de 3 a 5 días esa carga desaparece. También recuerda cerrar los recursos ya que ya no los usamos.


Para esta actividad vamos a seleccionar el tipo de cuenta **Personal** e introducir nuestros datos personales, además de verificarnos con nuestro número de teléfono de contacto.

Una vez terminamos, logueamos como **ROOT user** y estará listo.

### Evaluación

**Evidencia de la adquisición de actuaciones**:
- Captura de pantalla de la versión instalada de Terraform
- Captura de pantalla de la cuenta de AWS creada

**Indicadores de logros**:
- Terraform correctamente instalado.
- Creó correctamente la cuenta de AWS e inició sesión con el perfil ROOT.

**Criterios de corrección**:
- 5 puntos si hay una captura de pantalla con la salida de la versión Terraform.
- 5 puntos si hay una captura de pantalla con la cuenta de AWS creada con éxito.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Peso en la calificación**:
- Peso de esta tarea en la calificación final ................................. 10 puntos
- Peso de esta tarea en su tema .................................................... 10%
---
# Módulo 2: Creando nuestros primeros recursos

Terraform está escrito en un lenguaje llamado **Hashicorp configuration language** y toda nuestra configuración de Terraform se encontrará en archivos con extensión **.tf** donde trabajaremos.

Para comenzar, crearemos nuestra carpeta de trabajo y nuestro fichero[Terraform](https://www.terraform.io/) **main.tf**, en el que definiremos la configuración.

Como primer paso definiremos nuestro [provider](https://registry.terraform.io/browse/providers), que es el plugin que permite a los usuarios controlar una [API](https://en.wikipedia.org/wiki/API) externa al cual es el responsable de entender las interacciones con la propia API y exponer nuestros recursos.

![Servicios como pizzas](../../_media/aas.png)

**Esquema comparativo** *- Servicios como pizzas*

En general, nuestros proveedores son [Saas](https://www.redhat.com/en/topics/cloud-computing/iaas-vs-paas-vs-saas#saas) (Terraform Cloud, DNSimple, Cloudfare), [PaaS](https://www.redhat.com/en/topics/cloud-computing/iaas-vs-paas-vs-saas#paas) (Heroku) o [IaaS](https://www.redhat.com/en/topics/cloud-computing/iaas-vs-paas-vs-saas#iaas) (Alibaba Cloud, OpenStack, Microsoft Azure, AWS), que es el caso que nos ocupa en esta práctica.

Tenemos toda la información relacionada con los proveedores en la propia página de los [providers de Terraform](https://registry.terraform.io/browse/providers).

A lo largo de la actividad estaremos haciendo referencia a la **documentación oficial** y estaremos trabajando por bloques, haciendo uso de las configuraciones de ejemplo que nos ofrece el propio documento. Esta es una forma de trabajar muy ágil, cómoda y eficaz, ya que nos ahorra escribir demasiado, facilita la tarea de definir los diferentes recursos y elimina gran parte de los errores de sintaxis.

### 1. Definición de la versión y provider

En nuestro caso, nuestro proveedor será AWS y trabajaremos con la cuenta creada anteriormente, por lo que nos dirigimos a la página de [providers de Terraform](https://registry.terraform.io/browse/providers), entramos en [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest), y en el apartado de [Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) buscamos la configuración de nuestro provider, que en este caso sería la siguiente:
```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```
Aquí vemos que definimos nuestro encabezado con el proveedor requerido y la versión. En este proveedor definimos la [region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/#Regions) que son las diferentes zonas físicas en las que nuestro proveedor clusteriza sus datacenter.

> ⚠️ Lo mejor es centrarse en los costos y la ubicación al elegir una región para trabajar, ya que estos varían entre sí. Para nuestra actividad elegiremos **us-east-1** para homogeneizar todos los pasos. Dejo aquí un interesante y breve análisis de cálculo de costos en la página [openupthecloud](https://openupthecloud.com/which-aws-region-cheapest/) entre las diferentes regiones y los principales servicios.

### 2. Asignando nuestras credenciales
En el siguiente paso configuraremos la autenticación usando [access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html): Las access keys son credenciais de acceso para users IAM o root. Podemos usarlas para identificarnos sin user/pass y generar acceso a los servicios AWS y APIs, como cuando usamos AWS CLI.

Por el momento [hardcodearemos](https://en.wikipedia.org/wiki/Hard_coding) nuestras keys para centrarnos en los aspectos más básicos. Este es un proceso delicado que trataremos más adelante en su propio apartado.

```terraform
# Definimos o noso provider AWS cas credenciais
provider "aws" {
  region = "us-east-1"
  access_key = "access_key_ID"
  secret_key = "secret_access_key"
}} 
```
Para obtener nuestras [credenciales](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) primero debemos crearlas, así que vamos a:

`AWS` -> `nombre_usuario` -> `Security Credentials` -> `Access keys (access key ID and secret access key)` -> `Create New Access Key`

Hacemos click y creamos nuestra **access key** con su **secret** que usaremos en la definición de nuestro proveedor para poder conectarnos. Tenemos la opción de descargar nuestras keys en formato [CSV](https://en.wikipedia.org/wiki/Comma-separated_values), lo que nos facilita tenerlas disponibles.

> ⚠️ **IMPORTANTE:** La práctica de [hardcodear](https://en.wikipedia.org/wiki/Hard_coding) las keys de acceso se considera muy peligrosa e insegura, porque exponemos nuestras credenciales creando un riesgo muy importante en nuestro código. Más adelante solucionaremos este problema con más profundidad. Recuerde también que las credenciales de acceso creadas deben guardarse siempre en un lugar de difícil acceso y seguro. A la hora de crearlas **SÓLO PODEMOS VERLAS UNA VEZ**, debemos ser cautelosos en este aspecto.

### 3. Nuestro primer recurso, la instancia
Una de las grandes ventajas de Terraform es que la estructura no varía independientemente del provider, lo que evita que tengamos que aprender distintas configuraciones.

#### 3.1. Creando una instancia
A continuación implementaremos una [instancia EC2](https://aws.amazon.com/ec2/features/) que no es más que un servidor virtual en la nube de Amazon. Amazon ofrece [diferentes opciones](https://aws.amazon.com/ec2/instance-types/) personalizables en términos de recursos y potencia. En nuestro caso, procederemos con el recurso EC2 disponible de forma gratuita en nuestro [free tier](https://aws.amazon.com/free).

Para saber cómo proceder volvemos a la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources), y en el apartado de recursos introducimos en el buscador el recurso que buscamos, en este caso una instancia en aws -> *aws_instance*

```terraform
# Creamos nuestra instancia EC2 de tipo t2.micro
resource "aws_instance" "meu_servidor" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
}
```
Las [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) son las imágenes proporcionadas por AWS para lanzar las instancias y tenemos Ubuntu, Windows, Red Hat, Fedora... Podemos consultar las AMI gratuitas, dentro del panel de AWS, y en la sección EC2, tenemos un botón en la esquina superior izquierda para lanzar instancias **Launch Instances**. Al hacer clic en él, se muestra una lista de AMI disponibles con su ID y si son elegibles para el [free tier](https://aws.amazon.com/free). Verifique la AMI y no use la especificada anteriormente si no es gratuita, ya que pueden cambiar.

En nuestro caso elegimos la AMI de Ubuntu Server 18.04 LTS, en la que vemos el id de la AMI indicado arriba y de tipo **t2.micro** lo que nos permite 750h de uso cada mes durante el primer año cuando nos registramos con AWS.

![AMI Ubuntu 18.04 LTS](../../_media/ami_ubuntu.png)

#### 3.2. Iniciando terraform
Para lanzar esta instancia tendremos que acceder a la consola de comandos o a la propia terminal de VSCode, y ubicándonos en la carpeta de nuestro proyecto lanzar un:

```terraform
# Iniciamos terraform en nuestra carpeta proyecto
terraform init
```
Si tenemos todo correcto nos aparecerá un mensaje por terminal:

`Terraform has been successfully initialized`

#### 3.3. Creando nuestra instancia
Luego si queremos ver nuestros cambios y ver que todo se actualiza sin aplicar directamente podemos hacer:

```terraform
# Leemos nuestro estado actual, comparamos y sugerimos cambios a realizar
terraform plan
```

Nos muestra todos los cambios con códigos de color según las acciones a realizar:

- <span style="color:green">+</span> create -> objetos a crear
- <span style="color:red">-</span> destroy -> objetos a borrar
- <span style="color:orange">~</span> update -> objetos a modificar

Una vez que estemos satisfechos, podemos iniciar la aplicación para confirmar los cambios

```terraform
# Confirmamos/denegamos os cambios á reposta de value: yes/no
terraform apply
```

Con la aplicación completa, podemos ir a nuestro panel de control, hacer clic en actualizar en la esquina superior derecha y tendremos nuestra instancia ejecutándose con la configuración realizada.

![Primer lanzamento](../../_media/primer_lanzamento_aws.png)

Aquí podemos ver todos los datos de nuestra instancia, desde el estado actual, el tipo `t2.micro` que especificamos, hasta la AMI de Ubuntu en ejecución. Con solo esto habremos desplegado nuestra primera instancia en AWS usando Terraform.

Importante tener en cuenta que si hacemos una segunda `terraform apply` **NO** desplegaremos una segunda instancia, ya que trabajamos con un [lenguaje declarativo](https://codeburst.io/declarative-vs-imperative-programming-a8a7c93d9ad2).

En lugar de volver a ejecutar todo el código, Terraform analiza la configuración y la compara con el estado actual para ver si hay cambios o modificaciones, y en base a eso intenta cumplir con nuestra declaración. Lo realmente importante es que declaramos un estado final deseado y Terraform se encarga de cumplirlo siempre que sea posible.

#### 3.4. Destruyendo nuestra instancia
Para destruir nuestra instancia creada usaremos el comando `destroy`:
```terraform
# Eliminamos nuestra instancia
terraform destroy
```
Antes de borrar nuestra instancia, como ocurre con el resto de comandos, se nos muestra una pantalla con los cambios a realizar y se nos pide confirmación. Esta información es muy útil ya que nos permite tener una visión rápida y directa de todas las modificaciones.

> ⚠️ Por defecto `terraform destroy` destruye toda nuestra infraestructura y no es una práctica que usaremos con frecuencia. Es más habitual hacer `terraform apply` modificando nuestra infraestructura en el fichero Terraform.

### Evaluación

**Evidencia de la adquisición de actuaciones**:
- Archivo Terraform con nuestras credenciales borrado/pixelado
- Captura de pantalla de nuestro panel de AWS con la instancia en ejecución
- Captura de pantalla de nuestro panel de AWS con la instancia terminada

**Indicadores de logros**:
- Nos hemos conectado con éxito a nuestro proveedor de AWS
- El archivo Terraform se inició correctamente y se ejecutó sin errores.
- Eliminación de la instancia en AWS mediante `terraform destroy`

**Criterios de corrección**:
- 5 puntos si hay una captura de pantalla o el código del archivo Terraform correctamente estructurado y funcional
- 5 puntos si hay una captura de pantalla de la instancia ejecutándose correctamente en el panel de AWS.
- 5 puntos si hay una captura de pantalla con la instancia terminada desde la terminal con `terraform destroy`

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Peso en calificación**:
- Peso de esta tarea en la calificación final .................................. 25 puntos
- Peso de esta tarea en su tema ..................................................... 25%
