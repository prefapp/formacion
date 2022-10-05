# Que es una imagen

> La imagen es uno de los conceptos fundamentales en el mundo de la contenerización.

Como hemos visto, la contenerización es una técnica de virtualización que permite aislar un proceso dentro de un SO de tal manera que este último "piensa" que tiene toda la máquina para sí mismo, pudiendo ejecutar versiones específicas de software, establece su pila de red o crear una serie de usuarios sin afectar al resto de procesos del sistema.

Una imagen cubre el conjunto específico de software que utilizará el contenedor una vez que se inicie. Intuitivamente podemos entender que es algo **estático** e **inmutable**, como ocurre por ejemplo con una ISO, que tenemos que tener almacenada en la máquina host para poder lanzar contenedores basados ​​en esa imagen.

La gestión de imágenes es uno de los puntos fuertes de Docker.