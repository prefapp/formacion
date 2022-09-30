# Emprego de comandos

No tema anterior falamos de que container sempre parte dunha **imaxe** e ten asociada unha capa de **container**, de tal xeito que, mediante o mecanismo de **copy-on-write** (COW) os cambios que faga no sistema de ficheiros quedan reflectidos nesa capa e non na imaxe que, dende o punto de vista do container, é algo **inmutable**.

Non obstante, as imaxes pódense evolucionar. Para facelo a clave está, precisamente, nesa capa de container.

Partamos dun container que fai cambios no seu sistema de ficheiros.

![Container](./../_media/01_creacion_de_imaxes/crear_container_de_imaxe.png)

Como sabemos, esos cambios quedan reflectidos no súa capa de container.

Se detemos agora o container, de tal xeito que non poida facer máis cambios:

![Container](./../_media/01_creacion_de_imaxes/crear_container_de_imaxe_detido.png)

Nótese que o container está **detido**, non **destruido**, polo tanto o container non está a correr pero está presente no motor de Docker, e polo tanto tamén a súa capa de datos.

Se agora collemos esa capa de datos propia do container e facemos un **commit**, o que estamos a facer e producir unha nova imaxe que sí que incorpora os cambios da capa de container á súa propia estrutura interna.

![Container](./../_media/01_creacion_de_imaxes/crear_container_de_imaxe_detido_commit.png)

En definitiva, **acabamos de evoluciona-la imaxe**. E os novos containers baseados nesa nova imaxe sí verán os cambios que fixeramos no container orixinal.

Este precisamente, é o ciclo de evolución das imaxes en Docker.

![Container](./../_media/01_creacion_de_imaxes/evolucion_da_imaxe.png)
