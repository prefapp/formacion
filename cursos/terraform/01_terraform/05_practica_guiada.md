# Módulo 1: Primeiros pasos, configuración e instalación
Nesta tarefa imos a preparar o noso sistema antes de empezar ca nosa infraestructura cloud, todo isto dende cero con [AWS](https://aws.amazon.com/) e [Terraform](https://www.terraform.io/).

Para poder traballar co provider [AWS](https://aws.amazon.com/) precisamos da creación dunha conta na que faremos uso de [free tier](https://aws.amazon.com/free) do que dispoñemos no Basic plan.
Con este [free tier](https://aws.amazon.com/free) temos un ano de uso completamente gratuito nos servicios especificados sempre con certas limitacións.

O Basic plan é máis que suficiente para as prácticas e proxectos que vaiamos a deseñar neste curso.
### 1. Instalación Terraform

Para a instalación de [Terraform](https://www.terraform.io/) podemos acceder á páxina de [descargas](https://www.terraform.io/downloads) e ahí temos tódalas opcións dos diferentes SOs. Aquí mostraremos un exemplo de cada un dos sistemas máis empregados

#### 1.1 Windows
1. Para Windows dispoñemos dun executable o cal extraemos trala descarga nun directorio da nosa elección (por exemplo, c:\terraform).
2. Actualizamos a path do noso executable na path global do sistema:

`Control Panel` -> `System` -> `System settings` -> `Environment Variables` -> `PATH`

3. Abrimos unha nova terminal para que tome efecto o cambio
4. Verificamos a configuración da variable global co comando de terraform:
```shell
terraform -version
```
#### 1.2 macOS
Co package manager [brew](https://brew.sh/) podemos realizar a instalación en macOS con dos simples comandos:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
#### 1.3 Ubuntu/Debian
Ó igual que en macOS temos o package manager [brew](https://brew.sh/) para instalar de manera idéntica:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
Ou temos entre outras a opción mediante [curl](https://curl.se/) e a utilidade [apt](https://linuxize.com/post/how-to-use-apt-command/):
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
#### 1.4 VSCode extension (opcional)
[Visual Studio Code](https://code.visualstudio.com/) é un poderoso editor de texto que nos permite traballar dunha maneira moi cómoda e áxil debido á súa versatilidade, facilidade e cantidade de plugins, e que se integra dunha maneira moi sinxela con [Terraform](https://www.terraform.io/).

Para instalar a extensión de [Terraform](https://www.terraform.io/) en [Visual Studio Code](https://code.visualstudio.com/) e tan sinxelo como ir ó apartado das extensións, escribimos `terraform` no recadro de búsqueda e instalamos a extensión propia de [HashiCorp](https://www.hashicorp.com/), empresa de [Terraform](https://www.terraform.io/).

Podemos facer uso de calquer outro editor de texto de preferencia para a realización das actividades, pero debido á facilidade de uso e integración coas ferramentas que imos a usar recomendamos [Visual Studio Code](https://code.visualstudio.com/).

### 2. Creación da conta en AWS

Para a creación da nosa conta accedemos a [aws.amazon.com](https://aws.amazon.com) e vamos a crear a nosa conta AWS, premendo no botón da esquina superior dereita.

![Crear conta](./media/crear_aws.png)

Requisitos:
- Conta de correo
- Número de teléfono
- Tarxeta de débito crédito

> ⚠️ Aínda que o Basic plan de [AWS](https://aws.amazon.com/) ten custo cero sempre dentro dos [límites de uso](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html), ó momento de crear a conta xérase un cargo de $1 USD/EUR no proceso de verificación o cal queda pendente. Nun prazo de 3 a 5 días ese cargo desaparece. Lembrar tamén de ir cerrando os recursos a medida que xa non os usemos.


Para esta actividade imos a seleccionar o tipo de conta **Personal** e iremos introducindo os nosos datos persoais, así como verificándonos mediante o noso teléfono de contacto.

Unha vez terminado logueamos como **ROOT user** e xa estaría listo.

### Evaluación

**Evidencias da adquisición dos desempeños**:
- Captura de pantalla da versión de Terraform instalada
- Captura de pantalla da conta en AWS creada

**Indicadores de logro**: 
- Correctamente instalado o Terraform.
- Correctametne creada a conta de AWS e logueado co perfil ROOT.

**Criterios de corrección**:
- 5 puntos se hai unha captura da pantalla coa saída da versión de Terraform.
- 5 puntos se hai unha captura da pantalla coa conta de AWS correctamente creada.

**Autoavaliación**: Revisa e autoavalia o teu traballo aplicando os indicadores de logro.

**Peso na cualificación**:
- Peso desta tarefa na cualificación final ........................................ 10 puntos
- Peso desta tarefa no seu tema ...................................................... 10 %
---