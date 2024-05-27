# Módulo 3: Recursos de referencia
Seguimos con nuestro proyecto levantando más recursos y referenciando para saber comunicarnos entre todos.

Como hemos visto, todo lo que podemos hacer en la consola de AWS lo podemos hacer con Terraform, así que aprovecharemos esto y seguiremos creando más recursos desde nuestro Terraform.

### 1. VPC
> Lo primero que vamos a crear es la VPC por seguir un orden lógico, pero hay que tener en cuenta que Terraform no sigue un orden secuencial a la hora de leer el código, por lo que nos es indiferente el orden en el que colocamos los diferentes bloques de elementos. Eso no quita el hecho de que es extremadamente importante tener una estructura clara cuando se trabaja.

El acrónimo [VPC](https://aws.amazon.com/vpc/) proviene de Virtual Private Cloud, que es una red privada y aislada en nuestro entorno de AWS. Podemos crear tantos como queramos y estarán aislados unos de otros en todo momento. Para crear una VPC volvemos a hacer uso de la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) y buscamos el recurso de [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc).

La configuración es muy sencilla ya que solo necesitamos definir el cidr_block que es el rango de direcciones IP de nuestra VPC y podemos darle un nombre a nuestro recurso. Incluso podemos agregar una `tag` para hacer referencia al recurso en nuestro AWS, que se define con `Name`:

```terraform
# Creamos nuestra VPC
resource "aws_vpc" "primeira_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "production"
  }
}
```
### 2. subnet
A continuación, vamos a crear una subnet dentro de nuestra VPC que acabamos de crear para segmentar nuestra red. Como en los pasos anteriores en la [documentación de la subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) se especifica de forma muy sencilla.

```terraform
# Creamos nuestra subnet dentro de la VPC
resource "aws_subnet" "primeira_subnet" {
  vpc_id     = aws_vpc.primeira_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pro-subnet"
  }
}
```
Aquí hay varias cosas a tener en cuenta:
- Agregamos un nombre a nuestro recurso.
- El `cidr_block` está dentro del rango de direcciones especificado en la VPC que queremos usar.
- Nos referimos a VPC usando `vpc_id`.
- Agregamos una `tag` para diferenciar nuestra subnet.

Aquí vemos algo muy interesante, que Terraform nos permite referenciar recursos dentro de un mismo fichero de una forma muy rápida. En este caso nos referimos a nuestra VPC indicando el tipo de recurso, el nombre del recurso y la propiedad de este que nos pide separado por puntos. Como vemos en el ejemplo anterior, quedaría así:
```terraform
vpc_id = aws_vpc.primeira_vpc.id
```

Ahora solo nos falta realizar un `terraform apply` y lanzaríamos nuestra nueva configuración. Si todo es correcto, dentro de la consola de AWS, en nuestra sección de VPC, podremos ver como tenemos funcionando nuestra VPC, con el `cidr_block` y el `Name` especificados:

![VPC](../../_media/vpc.png)

De la misma manera si vamos a la sección de subnets en nuestra consola de AWS podríamos ver nuestra subnet:

![VPC](../../_media/subnet.png)

Vemos como nuestra subnet apunta a nuestra VPC que llamamos `production`, y que se le ha asignado correctamente un nombre y un bloque de dirección.

> ⚠️ Si entrando vemos más de una VPC y una subnet. No debemos preocuparnos, ya que AWS crea una VPC con una serie de subnets por defecto que vamos a ignorar.

### Evaluación

**Evidencia de la adquisición de actuaciones**:
- Captura de pantalla de la VPC.
- Captura de pantalla de la subnet dentro de la VPC creada.

**Indicadores de logros**:
- Creó correctamente los recursos.
- Uso de TAGS y referencias para vincular recursos.

**Criterios de corrección**:
- 5 puntos si hay una captura de pantalla de la VPC en la consola de AWS.
- 5 puntos si hay una captura de pantalla de la subnet que apunta a la VPC en la consola de AWS.
**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Peso en calificación**:
- Peso de esta tarea en la calificación final .................................. 25 puntos
- Peso de esta tarea en su tema ..................................................... 25%
---

# Módulo 4: Ficheros Terraform
Mientras practicábamos estos ejercicios, es posible que nos hayamos fijado en algunos ficheros que se han creado. Es fundamental saber qué son y qué hacen en nuestro trabajo con Terraform. Vamos con un poco de teoría:

### 1. Directorio Terraform

En nuestro primer comando `terraform init` pudimos comprobar cómo se creaban una serie de archivos y un directorio. Este directorio se crea cuando creamos nuevos complementos, por lo que cuando ejecutamos `terraform init` para iniciar nuestro Terraform, genera automáticamente este directorio e instala los plugins necesarios para que nuestro código pueda ejecutarse.

Como solo tenemos un proveedor, todo nuestro código se instalará en la misma carpeta. Incluso podríamos eliminar nuestra carpeta de demostración, y ejecutar `terraform init` la recrearía nuevamente de forma automática con los complementos necesarios.

### 2. El fichero terraform.tfstate

El fichero [terraform.tfstate](https://www.terraform.io/language/state) representa nuestro estado de terraform. Almacena el estado de nuestra infraestructura y configuración y sirve para registrar y verificar nuestro estado actual para que podamos compararlo con nuestro código.

El fichero está en formato [JSON](https://www.json.org/json-en.html), y aunque podemos editarlo no es recomendable, ya que se recomienda trabajar con CLI.

Si accedemos podremos ver toda nuestra configuración creada, que en este caso sería la definición de nuestro provider, el VPC y la subnet.

Este fichero es el **recurso principal** de Terraform para administrar nuestro código y, en caso de problemas o incoherencias, será nuestra principal fuente de credibilidad para recrear nuestra infraestructura.


### 3. El fichero terraform.tfstate.backup

Como su nombre indica, almacena una copia de seguridad de nuestro fichero de estado en caso de que nuestro tfstate se pierda o este corrupto.

### 4. El fichero terraform.tfvars

El tfvars es el fichero de [variables de entrada](https://www.terraform.io/language/values/variables) que nos permite personalizar diferentes aspectos de nuestros módulos de terraform sin necesidad de alterar el código fuente. Esto nos da mucha versatilidad a la hora de trabajar con diferentes configuraciones, haciendo así nuestro código más limpio, modular y reutilizable.

---

# Módulo 5: Metiendo las manos en la masa

En este módulo crearemos todo lo que hemos visto hasta ahora:
- Definimos el provider.
- Agregaremos nuestra VPC.
- Creamos un Internet Gateway.
- Creamos una Route Table.
- Asociamos nuestra subnet a la Route Table
- Creamos un Security Group para permitir los puertos 22 (SSH), 80 (HTTP) y 443 (HTTPS)
- Creamos una interfaz de red con una IP en la subnet creada previamente.
- Asignamos una Elastic IP a la interfaz de red.
- Creamos el par de claves de acceso.
- Creamos nuestro Ubuntu Server e instalamos/habilitamos apache2.

### 1. Creando la instancia EC2

El provider aprovechará la práctica guiada anterior:

```terraform
# Definimos nuestro provider AWS con las credenciales
provider "aws" {
  region = "us-east-1"
  access_key = "access_key_ID"
  secret_key = "secret_access_key"
}
```
Si no recordamos el procedimiento siempre podemos [volver a revisar la documentación](05_practica_guiada.md#2.-Asignando-as-nosas-credenciais).

### 2. Agregamos la VPC

De igual forma aprovechamos la práctica del [Módulo 3](#1.-O-VPC):

```terraform
# Creamos nuestra VPC
resource "aws_vpc" "primeira_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "production"
  }
}
```
### 3. Creamos un Internet Gateway

El [Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) nos permite conectar nuestra VPC e internet, tiene dos propósitos básicos:
- Proporcionar un objetivo en la Route Table de la VPC para el tráfico de Internet.
- Realiza la conversión NAT para las instancias a las que tiene asignadas direcciones IPv4 públicas.

Volver a la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway):

```terraform
# Creamos el Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.primeira_vpc.id
}
```
En `vpc_id = aws_vpc.primeira_vpc.id` indicamos la referencia al id de nuestro recurso VPC. 

De momento vamos a prescindir de TAGs porque no es necesario para esta actividad.

### 4. Creamos la Route Table

En AWS cada subnet debe estar asociada con una Route Table, que especifica las rutas permitidas para el tráfico saliente de la subnet. Sacamos la configuración de la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table):

```terraform
# Creamos la Route Table
resource "aws_route_table" "pro_route_table" {
  vpc_id = aws_vpc.primeira_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "pro"
  }
}
```
Cosas a considerar:
- Hacemos referencia a `vpc_id = aws_vpc.primeira_vpc.id`.
- Modificamos el `cidr_block = "0.0.0.0/0"` para que por defecto enrute todo el tráfico de IPv4.
- Hacemos referencia a `gateway_id = aws_internet_gateway.gw.id`.
- En IPv6 el `cidr_block` ya está provisionado por defecto.
- Apuntamos `egress_only_gateway_id = aws_internet_gateway.gw.id` con la misma Gateway.

### 5. Creamos nuestra subnet

Podemos tomar como ejemplo la subnet creada en el [Módulo 3](#2.-A-subnet) y adaptarla:

```terraform
# Creamos nuestra subnet dentro de la VPC
resource "aws_subnet" "primeira_subnet" {
  vpc_id     = aws_vpc.primeira_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pro_subnet"
  }
}
```

Agregamos a `availability_zone = "us-east-1a"` para tener unificados todos los puntos a la hora de realizar las tareas.

#### 6. Asociamos nuestra subnet con la Route Table

Para asociar nuestra subred con la Route Table en AWS tenemos otro recurso llamado [aws_route_table_association
](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) que usaremos:

```terraform
# Asociamos la subnet con la Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.primeira_subnet.id
  route_table_id = aws_route_table.pro_route_table.id
}
```
No vamos a hacer referencia a este recurso por lo que dejamos el nombre `a` tal como está, y hacemos referencia tanto a `subnet_id = aws_subnet.primeira_subnet.id` como a `route_table_id = aws_route_table.pro_route_table.id`.

### 7. Creamos un Security Group para permitir los puertos 22 (SSH), 80 (HTTP) y 443 (HTTPS)

Un security group actúa como un firewall virtual para instancias EC2 para controlar el tráfico entrante y saliente. Actúa en el ámbito de la instancia, no en la subnet. Usemos la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group):

```terraform
# Configuración de el security group
resource "aws_security_group" "permitir_web" {
  name        = "permitir_trafico_web"
  description = "Permitir trafico web entrante"
  vpc_id      = aws_vpc.primeira_vpc.id

  ingress {
    description      = "Trafico HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Trafico HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Trafico SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "permitir_web"
  }
}
```
Definimos los siguientes puntos:
- Asignamos nombre, descripción y hacemos referencia a la id de nuestra VPC.
- Diferenciamos entre las reglas de `ingress` (entrada) y de `egress` (salida).
- Creamos una regla para cada uno de los casos que queremos:
  - Tráfico SSH para poder conectarnos por SSH mediante el puerto 22.
  - Tráfico HTTP para poder conectarnos por protocolo web mediante el puerto 80.
  - Tráfico HTTPS para poder conectarnos por protocolo web seguro mediante el puerto 443.
- En el `cidr_blocks` y `ipv6_cidr_blocks` damos acceso a las direcciones que queramos, pero como estamos creando un servidor web damos acceso a todos.
- En `from_port` y `to_port` podemos especificar un rango de puertos si es necesario.
- Permitimos todos los puertos en el `egress`, cualquier ip de salida en el `cidr_blocks` y `ipv6_cidr_blocks` y todos los protocolos que indiquen `protocol = "-1"`.

> Es sumamente importante tener siempre muy bien definidas nuestras reglas de entrada para evitar errores en la seguridad de nuestra infraestructura.

### 8. Creamos la interfaz de red

A continuación, crearemos una interfaz de red, que son esencialmente tarjetas de red virtuales que podemos agregar a nuestras instancias EC2. Se utilizan para habilitar la conexión de red para nuestras instancias. Aquí está la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface):

```terraform
# Creamos la interfaz de red
resource "aws_network_interface" "nic_servidor_web" {
  subnet_id       = aws_subnet.primeira_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.permitir_web.id]
}
```
Creamos nuestra interfaz de red y la vinculamos a la subnet anterior. También asignamos una lista de IPs que tenemos disponibles dentro de nuestra subnet y hacemos referencia a nuestro Security group. Esto crea una IP privada para el host que nos permite realizar tareas como conexión por VPN o SSH para administración por ejemplo.

### 9. Asignamos una Elastic IP

La IP elástica es un recurso que genera una IP pública y nos permite que cualquier persona en Internet acceda a ella a través de esa dirección. Dejo aquí el [link a documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip):

```terraform
# Asignamos la EIP
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.nic_servidor_web.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}
```

En los valores dejamos `vpc=true` ya que el EIP está dentro de una VPC, referenciamos network_interface y lo asociamos a una IP privada de la lista que creamos en la interfaz de red (en este caso solo creamos una).

> Como discutimos antes, Terraform no necesita un orden específico en la declaración de recursos, ya que es lo suficientemente inteligente como para descubrir cómo implementar, **CON EXCEPCIONES**:
>
> En la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) se indica que el EIP requiere que se despliegue primero el IGW. Para solventar este problema, agregamos el indicador `depends_on` y hacemos referencia a una lista con el objeto, en este caso, el IGW.

### 11. Key pairs

Key pairs consisten en un par de claves (pública y privada) que forman un conjunto de credenciales de seguridad, y que se utilizan para autenticarnos cuando nos conectamos a una instancia EC2 de AWS. EC2 almacena la clave pública en su instancia y nosotros almacenamos la clave privada.

> ⚠️ Es sumamente importante tener nuestras claves privadas almacenadas en un lugar seguro.

Para la creación de las claves accedemos en `consola de AWS -> EC2 -> Network & Security -> Key Pairs`.

Una vez dentro en la esquina superior derecha pulsamos el botón de "Create key pair":

![Key pair](../../_media/key_pair.png)

> En el momento de la creación tenemos dos formatos diferentes:
>
> - **.pem** para MacOs o Linux ( [OpenSSH](https://www.openssh.com/) )
> - **.ppk** para usar con Windows ( [Putty](https://www.putty.org/) )

En el momento de la creación, se descargarán automáticamente. Esta clave nos permitirá conectarnos a nuestro servidor cuando lo implementemos.

### 12. Creamos nuestro Ubuntu Server e instalamos/habilitamos apache2

Para crear nuestro server vamos a reutilizar nuestra [instancia creada](05_practica_guiada.md#3.-O-noso-primer-recurso,-a-instancia) y agregamos las diferentes configuraciones tal como nos enseña la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) e instalamos un servidor web ( [apache2] ):

```terraform
# Creamos nuestra instancia EC2 de tipo t2.micro
resource "aws_instance" "meu_servidor" {
  ami               = "ami-0e472ba40eb589f49"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.nic_servidor_web.id
  }
  
  user_data = <<- EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo O meu primer server > /var/www/html/index.html'
              EOF
  tags = {
    Name = "meu-servidor"
  }
}
```
Declaramos los siguientes conceptos:
- A `availability_zone = "us-east-1a"` tal como definimos anteriormente
- Nuestra key recién creada con el nombre que le dimos.
- El bloque de nuestra interfaz de red en `network_interface`:
  - El `device_index = 0` se refiere a la primera interfaz de red, ya que empezamos a contar desde 0.
  - La id de nuestra interfaz de red.
- Para hacer nuestra prueba de un modo sencillo vamos a hacer uso de un pequeño script que pasaremos al flag `user_data` para que haga el despliegue de nuestro apache2 y comprobar el funcionamiento del mismo.

Con esto ya tendríamos que hacer un `terraform apply` y si todo está correcto estaríamos iniciando nuestra instancia con todos los recursos creados y con una IP pública para acceder al apache2.

### 13. Pruebas

Si accedemos a nuestra consola de AWS podemos ver como tenemos una instancia creada con el nombre y características que le hemos dado:

![Instancia creada](../../_media/proba1_aws.png)

Si ahora cogemos la IP pública que nos da y la introducimos en el buscador, tendremos nuestra web funcionando:

![Web funcionando](../../_media/proba2_web.png)

Ahora vamos a conectarnos a través de SSH. En la página de la instancia tenemos un botón superior llamado **Connect** con instrucciones para conectarse a través de SSH. En nuestro caso, como user de Linux, abrimos nuestro cliente y usamos la clave previamente descargada para conectarnos:

![SSH](../../_media/proba3_openssh.png)

Para Windows tendríamos que hacer uso del cliente [Putty](https://www.putty.org/)

> ⚠️ Una vez que tengamos toda la práctica hecha podemos derribar todo con `terraform destroy`. Hay que tener en cuenta que aunque estemos con la capa gratuita de AWS tenemos limitaciones. Siempre es mejor no tener activo lo que no vamos a usar o no necesitemos.
>
> Usaremos el fichero Terraform en los siguientes módulos de práctica.

### Evaluación

**Evidencia de la adquisición de actuaciones**:
- Captura de pantalla de la instancia que se ejecuta en AWS
- Captura de pantalla del servidor apache2 ejecutándose en una IP pública
- Captura de pantalla de acceso vía SSH

**Indicadores de logros**:
- Creó correctamente los recursos.
- Uso de TAGS y referencias para vincular recursos.
- Los grupos de seguridad están correctamente definidos.

**Criterios de corrección**:
- 5 puntos si hay una captura de la instancia en la consola de AWS.
- 5 puntos si hay una captura de pantalla de apache2 ejecutándose en el navegador.
- 5 puntos si hay acceso correcto vía SSH

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.
