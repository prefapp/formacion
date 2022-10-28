# ¿Qué es Terraform?

Terraform es una herramienta de software libre para el aprovisionamiento a través de código declarativo. Le permite automatizar y administrar la infraestructura necesaria para implementar plataformas y servicios en ella, incluso cuando la implementación ya se ha realizado.

**Para qué sirve**

Los principales casos de uso de Terraform son la creación de nueva infraestructura y la gestión de cambios en ella.

Por otro lado, Terraform facilita enormemente la replicación de infraestructura. Uno de los casos más comunes consiste en replicar las características de la infraestructura entre diferentes entornos, como desarrollo, preproducción y producción.

Imagine que necesita implementar 5 servidores para ejecutar su aplicación. Esta aplicación podría constar de una base de datos y varios componentes en contenedores Docker. Si quisiéramos desplegar esto en Azure, sería necesario preparar la infraestructura previamente. Para ello tendríamos que crear las redes, máquinas virtuales, asignar permisos, instalar software como Docker e instanciar los servicios de base de datos necesarios.

Todo este procedimiento podría ser realizado por un equipo de infraestructura y aquí es donde entra en juego Terraform. De esta forma, es posible automatizar todas estas operaciones de despliegue e incluso abstraer detalles como el orden en que se realizan.
