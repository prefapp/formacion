# Solución completa (2): los cgroups

Sabemos que el trabajo del Kernel de Linux es evitar que los procesos acaparen recursos básicos como:

- UPC
- Memoria
- Operaciones de E/S

> La pregunta que surge es: ¿permite un control fino del acceso y consumo de estos recursos?

La respuesta es que, antes de la versión 2.6.24, había mecanismos de control (principalmente el comando nice) pero eran muy limitados.

Todo esto cambia con la adopción en enero de 2008 por parte del kernel de Linux de [grupos de control](https://wiki.archlinux.org/index.php/cgroups) (cgroups para abreviar) impulsados ​​principalmente por ingenieros de Google.

cgroups puede verse como un árbol en el que los procesos se cuelgan de un poste de control de tal manera que se pueden establecer, para ese proceso y sus hijos:

- Limitaciones de recursos.
- Prioridades de acceso a los recursos.
- Seguimiento del uso de los recursos.
- Gestión de procesos a bajo nivel.

La flexibilidad que permiten es muy grande. Se pueden crear diferentes grupos de restricciones y controles y se puede asignar un proceso y sus hijos a diferentes grupos, haciendo combinaciones que permiten un alto grado de personalización.

![CGroups](./../_media/01_que_e_un_contedor_de_software/cgroups_1.png)

A partir de la versión 4.5 del kernel de Linux, aparece una nueva versión de cgroups. La principal diferencia que implementa cgroups v2 es la forma en que se establece la jerarquía.

La nueva versión deja de utilizar árboles diferentes para cada controlador (memoria, CPU, etc.), y funciona de tal forma que, cuando creas un nuevo grupo, este se convierte en la raíz, de la que cuelgan los diferentes controladores.

Gracias a este cambio, ya no es necesario crear el mismo grupo dentro de cada uno de los diferentes controladores, sino que la configuración de todos ellos está centralizada dentro de la carpeta del grupo.
