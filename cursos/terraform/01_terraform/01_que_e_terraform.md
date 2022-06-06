# Qué é Terraform?

Terraform é unha ferramenta de software libre para o aprovisionamiento mediante código declarativo. Permite automatizar e xestionar a infraestructura necesaria para desplegar plataformas e servicios sobre ela, incluso cando xa está o despregamento feito.

**Para qué sirve**

Os casos de uso principais de Terraform son a creación de nova infraestructura e a xestión de cambios na mesma.

Por outra parte, Terraform facilita enormemente a replicación de infraestructura. Un dos casos máis comunes consiste en replicar as características da infraestructura entre diferentes contornos, como pode ser desarrollo, preproducción e producción.

Imaxina que necesitas despregar 5 servidores para executar a túa aplicación. Esta aplicación podería estar formada por unha base de datos e varios componentes en contedores Docker. Se este despliegue o quixeramos facer en Azure, sería necesario preparar a infraestructura previamente. Para isto teríamos que crear as redes, máquinas virtuales, asignar permisos, instalar software como Docker e instanciar os servizos de bases de datos que se precisen.

Todo este procedimiento podería facelo un equipo de infraestructura e é aquí onde entra en xogo Terraform. De esta maneira, é posible automatizar todas estas operaciones de despregamento e incluso abstraer detalles como no orden no que se realiza.

