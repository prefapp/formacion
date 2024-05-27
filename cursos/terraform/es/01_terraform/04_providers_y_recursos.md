# Providers y recursos
## provider
Un [provider](https://www.terraform.io/language/providers) en Terraform es un plugin que permite a los usuarios manejar una API externa. Los plugins de proveedores funcionan como una capa de abstracción que permite que nuestro Terraform se comunique con diferentes nubes, proveedores, bases de datos y servicios.

![](../../_media/mermaid01.png)

Las configuraciones en Terraform requieren la declaración del proveedor que vamos a utilizar, para instalarlo. Podríamos decir que es la hoja de ruta de nuestro proveedor, que utilizaremos para montar la infraestructura según sus reglas.

Terraform utiliza proveedores para aprovisionar recursos, que describen uno o más objetos de infraestructura. Cada proveedor del [Terraform Registry](https://registry.terraform.io/) tiene su documentación de uso y podemos elegir la versión que queremos usar en cada momento.

Terraform tiene una amplia selección de proveedores, desarrollados por varias fuentes:
- HashiCorp
- Terraform Community
- Vendedores externos

Podemos ver la lista completa de proveedores con los filtros de búsqueda [en este enlace](https://registry.terraform.io/browse/providers), entre los que destacamos:
- [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Google Cloud](https://registry.terraform.io/providers/hashicorp/google/latest)
- [Kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
- [Alibaba Cloud](https://registry.terraform.io/providers/aliyun/alicloud/latest)

> ⚠️ **IMPORTANTE:** Sin un proveedor declarado, no se puede manejar ninguna configuración, por lo que es esencial en nuestro código.

## Los recursos
Cada recurso describe uno o más objetos en nuestra infraestructura. Podemos dividir la declaración de un recurso en los siguientes componentes:

- **Bloques de recursos**: documentar la sintaxis para declarar recursos.
- **Comportamiento de recurso**: explica con más detalle cómo Terraform maneja la declaración de recursos cuando se aplica una configuración.
- **Sección de meta-argumentos**: en esta sección definimos argumentos especiales que se pueden usar con cada tipo de recurso, como `depends_on`, `count`, `for_each`, `provider` e `lifecycle`.
- **Provisioners**: documentan la configuración de acciones tras la creación de un recurso utilizando el provisioner y los bloques de conexión.

```terraform
resource "aws_instance" "instancia_exemplo" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}
```

En este ejemplo tenemos un bloque de recursos en el que se definen. Tenemos varios puntos a considerar:
- **resource**: Es nuestro bloque de recursos que usamos para declarar nuestro recurso.
- **"aws_instance"**: El tipo de recurso a declarar. En este caso se trata de una instancia del proveedor de AWS como su nombre indica.
- **"instancia_exemplo"**: El nombre que le asignamos a nuestro recurso. El tipo de recurso y el nombre juntos sirven como un identificador para el recurso dado, por lo que deben ser únicos dentro del módulo.
- **{}**: El cuerpo del bloque es todo lo que está dentro de las llaves `{}` y contiene los argumentos para la configuración del recurso en sí. En el ejemplo, tenemos `ami` y `instance_type`, que son argumentos definidos específicamente para el tipo de recurso `aws_instance` y definen la imagen de la máquina de Amazon y el tipo de instancia que queremos, respectivamente.

> ⚠️ Los recursos son el elemento más importante en el lenguaje Terraform, ya que son la herramienta que utilizamos para declarar toda nuestra infraestructura.
