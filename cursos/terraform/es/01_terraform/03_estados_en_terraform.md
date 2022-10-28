# Estados en terraform

O estado é a peza que usamos no noso Terraform para mapear os nosos recursos "reais" ca nosa configuración, seguir a pista da metadata e mellorar o rendimiento da nosa infraestructura.

Terraform debe almacenar o estado da súa infraestructura e configuración administradas. Éste estado utilízase para asignar recursos do mundo real e a súa configuración.

O estado almacénase de forma predeterminada nun archivo local chamado "terraform.tfstate", pero tamén pódese almacenar de forma remota, o cal é ideal nun entorno formado por varias persoas.

Terraform utiliza este estado local para crear plans e realizar cambios na infraestructura. Antes de calquer operación, Terraform realiza un chequeo para actualizar este estado co da infraestructura real.

![Estado en terraform](./../_media/terraform.drawio.png)

Como podemos ver neste exemplo, temos declarados unha serie de artefactos que pertenecen a infraestructura que nos proporciona AWS (Amazon Web Services). Neste caso temos un Amazon S3 (Amazon Simple Storage Service) que é un servicio de almacenamiento de obxetos deste proveedor. Con Terraform podemos declarar que queremos isto na nosa infraestructura. O mesmo ocorre co EKS (Elastic Kubernetes Service), que é outro servicio de Amazon, neste caso é un servicio para executar e escalar kubernetes na nube.

Pódese observar que temos máis ficheiros, como o de variables.tf e o main.tf, os cales son propios de terraform e que iremos analizando según avancemos no curso.

## Reconciliación de estados 🤝

Diríamos que o estado en Terraform é como un snapshot da nosa infraestructura actual, a cal facemos uso dela para manter, comparar e todas as operación [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) da nosa infraestructura. É o noso primer punto de apoio ou inicio á hora de traballar con Terraform.

Temos que ter moi en claro, que o noso **"estado desexado"** non é o mesmo que o noso **"estado actual"**. O noso estado desexado son as distintas configuracións que imos a definir para aplicar á nosa infraestructura, mentres que o estado actual é a nosa configuración actual.

Terraform á hora de aplicar o noso estado desexado seguirá os seguintes pasos:

1. Análise dos ficheiros HCL.
2. Usando a información dos nosos ficheiros HCL, constrúese un esquema dos recursos que queremos aprovisionar (**_estado desexado_**), e resólvense as dependencias entre eles para decidir unha orde lóxica na que crealos.
3. Inspeccionamos o noso **estado actual** (se é que o temos) para comprobar que é o que temos e o que non temos despregado. Este é o **estado percibido** xa que non hai conexión entre o que Terraform cré que existe e o que realmente existe.
4. A continuación realízase unha análise lóxica entre o noso **estado desexado** e o noso **estado percibido**, para posteriormente decidir que accións [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) son necesarias e a orde das mesmas para alinear o noso **estado percibido** co noso **estado desexado**.
5. Agora realízanse as accións necesarias para acadar o noso **estado desexado**. Como resultado comezaranse a crear os nosos recursos e pasaremos a ter o noso **estado desexado** como o o noso **estado actual**.
6. Terraform actualiza o noso estado para reflectir os cambios feitos.

![Creación dun recurso](./../_media/diagrama_update_state.png)

Neste diagrama vemos que á hora de crear un recurso Terraform debe revisar primeiro se o recurso existe no State, e posteriormente verificar con noso provedor Cloud para asegurarse que o estado actual coincide con que se espera atopar.

> ⚠️ Coñécese como **reconciliación** ó conxunto de operacions que se realizar para alinear o estado desexado co estado actual. Dise que Terraform reconcilia o estado desexado ó estado actual.

## Estados non reconciliados

A pregunta agora sería: ¿qué sucedería se co paso do tempo alguén borra o noso grupo de recursos declarado?, ¿qué sucedería se relanzamos o noso Terarform?

Vamos a ver os pasos que realizaría Terraform:

1. Análise dos ficheiros HCL.
2. Comprobamos que no noso **estado desexado** teríamos ese grupo de recursos.
3. Revisamos no noso estado se temos o grupo de recursos.
4. Terraform identifica que o noso **estado percibido** temos esa entrada, así que imos ó noso provedor Cloud para consultar o **estado actual**.
5. Azure nos reporta un 404, indicándonos que non existe.
6. Terraform realiza unha análise e alineación entre o noso **estado desexado** e o noso **estado actual** e determina as accións necesarias para crear o noso grupo de recursos.
7. Terraform realiza as accións necesarias para crear o noso grupo de recursos.
8. Terraform actualiza o noso estado para reflectir os cambios feitos.

![Reconciliacón do estado](./../_media/diagrama_update_state_2.png)

Neste diagrama vemos como o estado cambia a forma na que Terraform funciona. Ó comprobar o noso estado co provider vemos que o noso grupo de recursos está eliminado, polo que temos que recrealo.

Isto non significa que ante un cambio nos recursos Terraform vai crear o recurso eliminado ou modificado, por exemplo, no caso de cambiar o nome do recurso, Terraform realizaría un update para reconciliar o noso estado.

> ⚠️ **IMPORTANTE:** O estado pode xogar na nosa contra se non traballamos con él de manera acorde. O idóneo sería sempre manexar a administración dos nosos recursos sempre dende un punto, Terraform no noso caso. Se facemos uso de diferentes vías de administración, como pode ser o portal do noso provedor web, vainos xerar desaliñamento entre o noso estado e a situación real da infraestructura.
