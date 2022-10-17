# Docker

> Docker, a pesar de su corta vida como proyecto de software de código abierto, está revolucionando el sector de las tecnologías de la información.

**De forma similar a la revolución que supone la adopción de contenedores de mercancías, al estandarizar las características de las cajas en las que se transportan y mueven todo tipo de materiales en todo el mundo, lo que permite adaptar y optimizar las infraestructuras en las que se almacenan y mover, Docker estandariza el proceso de transporte de software**.

Desde el punto de vista de un administrador de sistemas, nos permite cambiar la forma en que "transportamos" y desplegamos aplicaciones. En lugar de tener que recoger las especificaciones y dependencias que necesita una aplicación, y realizar la instalación de la misma en cada máquina y sistema operativo en el que vaya a estar alojada, Docker nos permite definir un "contrato", una interfaz estándar, que separa lo que va dentro de ese contenedor (la aplicación y sus dependencias) de lo que va fuera, el entorno donde estará alojado (el pc de otro desarrollador, el servidor físico de la organización, los clusters de servidores virtuales en la nube…)

Desde el punto de vista del desarrollador de aplicaciones, Docker le brinda el poder de controlar fácilmente el software que su aplicación necesita para ejecutarse. Solo debe preocuparse de brindar un artefacto, una caja negra que opere con total autonomía dentro de un sistema operativo definido, para que el administrador tome esa caja y la pruebe, monitoree y aloje dentro de su infraestructura.