# Módulo 1: El problema de la gestión de recursos en un sistema operativo

## Comprender y utilizar la tecnología de namespace

> Los [namespaces](https://prefapp.github.io/formacion/cursos/docker/#/./01_que_e_un_contedor_de_software/08_namespaces_en_profundidade) son uno de los pilares básicos para construir contenedores, la posibilidad de crear "vistas" privadas en SO para un proceso o conjunto de procesos proporciona una gran flexibilidad para la ejecución del proceso.

Antes de realizar la tarea, lea atentamente las **instrucciones**, los **indicadores de logro** y los **criterios de corrección** que siguen.

Pasos:

1. **Consulta** y **analiza** la documentación sobre namespaces en profundidad.

2. **Trabaje** con comandos de administración de namespace:
En un pdf, ponga las capturas de pantalla de los comandos necesarios para:
   - Lanzar un bash con pid, proc y red aislados.
   - Lanzar un bash una fiesta con uts aislados.       
   - Lanzar un bash que ingrese al namespace del paso 2 y cambie el nombre de host a "tarefa-namespaces de tareas".

3. **Explore** el namespace de la red.
El namespace de la red permite, entre otras cosas, conectar procesos que están en diferentes namespaces a través de elementos virtuales como veth. En un pdf, coloque capturas de pantalla de los comandos necesarios para:
   - Inicie un bash con namespaces de redes privadas, pid, proc.
   - Crear un par de interfaces virtuales.
   - Asigne una de las interfaces al namespace privado.
   - Comunicarse a través de veth (un ping, por ejemplo)
   - Puede encontrar ayuda en este [artículo](https://blog.scottlowe.org/2013/09/04/introducing-linux-network-namespaces/).

---

**Evidencia de adquisición de desempeño**: Pasos 1 a 4 completados correctamente de acuerdo con estos...

**Indicadores de logros**:

- Se contesta el cuestionario.
- En los pdfs a entregar:
 - Se enumerarán los comandos bash para iniciar procesos con namespaces aislados.
 - Se verán los comandos de inserción de un proceso en un namespace de otro proceso.
 - veth se puede crear y comunicar dos namespaces diferentes a través de la red.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección** / **Niveles de logro de desempeño**:

- Paso 2
 - **5 puntos** si se completa el cuestionario

- Paso 3 (máximo 12 puntos)
 - **4 puntos** si el comando bash boot aislado es correcto.
 - **4 puntos** si el comando para iniciar bash aislado de uts global es correcto.
 - **4 puntos** si el comando para iniciar un proceso en el namespace privado de uts y modificar el nombre de host es correcto.

- Paso 4 (máximo 8 puntos)
 - **4 puntos** si los comandos de inicio de bash con los namespaces privados y el comando de creación de veth son correctos.
 - **4 puntos** si los comandos de asociación veth a los namespaces globales y privados y los de prueba son correctos.

**Peso en calificación**:

- Peso de esta tarea en su tema ........................................... .......... 25%

## Limitar y controlar procesos a través de cgroups

> cgroups es una de las funcionalidades básicas para la creación y gestión de contenedores de software. Introducidos en el Kernel de Linux por los ingenieros de Google a finales de 2007, permiten crear jerarquías de control, gestión y seguimiento de procesos aplicables a usuarios y programas individuales. Su flexibilidad y poder hacen que sean utilizados por otras herramientas básicas del sistema como systemd.

Antes de realizar la tarea, lea atentamente las **instrucciones**, los **indicadores de logro** y los **criterios de corrección** que siguen.

Pasos:

1. **Consulta** y **analiza** la documentación en [cgroups: grupos de control de procesos](https://prefapp.github.io/formacion/cursos/docker/#/./01_que_e_un_contedor_de_software/09_cgroups_xestion_e_utilidades) .

2. **Trabaje** con los comandos de administración de cgroups:
- Los pasos a seguir serán diferentes dependiendo de si el sistema utiliza cgroups v1 o cgroups v2. Puede verificar la versión ejecutando el siguiente comando:

```bash
grep cgroup /proc/filesystems
```

El sistema admitirá cgroups v2 si el resultado es:

```bash
nodev    cgroup
nodev    cgroup2
```

En cambio, solo admitirá cgroups v1 si el resultado es:

```bash
nodev    cgroup
```


- Como script de prueba puedes usar esto:

```bash
#!/bin/sh
mientras [ 1 ]; de
        echo "hola mundo"
        dormir 20
done
```

- En un pdf, poner las capturas de pantalla de los comandos necesarios para:
 - Crear un grupo de control de memoria con el nombre grouptest.
 - Limite la ejecución de la memoria a 50 MB
 - Introducir una ejecución de script de prueba en el grupo de control grupotest.
 - Ver el consumo de memoria del script a través de cgroups.
 - Limite la ejecución de la memoria a 4 KB.
 - Mostrar los registros del sistema cuando se ejecuta el script de prueba con esta limitación. Clave:

```bash
/var/log/messages
```

O, si este archivo no existe:

```bash
/var/log/syslog
```
3. **Explore** el control de la CPU en cgroups.
- Hay excelente información en esta [documentación](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/sec-cpu). También tenemos un buen ejemplo [en este enlace](https://scoutapm.com/blog/restricting-process-cpu-usage-using-nice-cpulimit-and-cgroups) usando las herramientas libcgroup.
- En el caso de cgroups v2, puede guiarnos a través de la siguiente [documentación](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/using-cgroups-v2-to-control-distribution-of-cpu-time-for-applications_managing-monitoring-and-updating-the-kernel).
- Para probar una aplicación con un uso intensivo de la CPU, recomendamos matho-primes:
 - Descarga el paquete https://launchpad.net/ubuntu/+source/mathomatic/16.0.5-1.
 - Descomprimir.
 - Ir a carpeta primes/
 - Ejecutar `make && make install`
 - Ejecutando esto, tenemos una tarea intensiva de cpu que podemos cancelar sin problema en este momento.

```bash
/usr/local/bin/matho-primes 0 9999999999 > /dev/null &
```

- En un pdf, mostrar las frases necesarias para:
 1. Crear un grupo de control de trabajos de CPU.
 2. Introducir limitaciones de `cpu_shares` en caso de usar cgroups v1, o de `cpu.weight` en caso de usar cgroups v2.
 3. Establecer una relación de limitación de 2:1
 4. Inicie 3 instancias del programa de prueba y muestre las limitaciones de la CPU.

---

**Evidencia de adquisición de rendimiento**: Pasos 1 a 4 realizados correctamente de acuerdo con estos...

**Indicadores de logros**:

- El interrogador concursos.
- En los pdfs a entregar:
 - mostrando los comandos necesarios para crear los cgroups con limitaciones de memoria y los scripts que se ejecutan dentro de los grupos.
 - ver comandos bash de creación de recursos compartidos de cpu en cgroups y pruebas de comando.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección** / **Niveles de logro de desempeño**:

- Paso 2
 - **5 puntos** si se completa el cuestionario
- Paso 3 (12 puntos máximo)
 - **4 puntos** si el grupo de memoria se crea correctamente y la limitación se establece en 50 MB.
 - **4 puntos** si se introduce correctamente el guión en el grupo y se comprueba correctamente la limitación efectiva de memoria.
 - **4 puntos** si la memoria está limitada a 4 KB y los registros muestran lo que sucede cuando se ejecuta el script.
- Paso 4 (8 puntos máximo)
 - **4 puntos** si el grupo de control de CPU se crea correctamente y la limitación de recursos compartidos de CPU se configura correctamente.
 - **4 puntos** si hay tres instancias del script de prueba iniciado y las limitaciones en la parte superior aparecen correctamente.

## Crear los primeros contenedores de software

> Montando un contenedor - Usando [las tecnologías que vimos en este tema (unshare, mount...)](https://prefapp.github.io/formacion/cursos/docker/#/./01_que_e_un_contedor_de_software/08_namespaces_en_profundidaded) van a crear un contenedor de software "artesanal"

El contenedor debe reunir las siguientes características:

**Especificaciones**.

- El contenedor debe montar este [sistema de archivos](https://github.com/ericchiang/containers-from-scratch/releases/download/v0.1.0/rootfs.tar.gz).

- Asegúrate de estar en los siguientes [namespaces](https://prefapp.github.io/formacion/cursos/docker/#/./01_que_e_un_contedor_de_software/08_namespaces_en_profundidade): (pids, mounts, UTS, network, ipc)

- Debe haber montado un /proc propio

**Pasos**:

1 Repase lo que aprendió sobre los contenedores.

- En pdf, muestra capturas de pantalla de todo lo necesario para:
 - Crear un contenedor según las especificaciones establecidas.
 - ¿Cómo probar que la UTS está realmente enferma?
 - ¿Cómo podemos saber que cal es el proceso de inicio del contenedor?
 - ¿Cómo daríamos conectividad al exterior o al contenedor? Pista ([veth](http://man7.org/linux/man-pages/man4/veth.4.html)).
 - Sabiendo que son los [cgroups](https://prefapp.github.io/formacion/cursos/docker/#/./01_que_e_un_contedor_de_software/09_cgroups_xestion_e_utilidades), limita la memoria del contenedor a ```512 MB```.

---

**Evidencia de adquisición de rendimiento**: Pasos 1 realizados correctamente de acuerdo con estos...

**Indicadores de falla**: Su contenedor debe...

- Estar aillado en los namespaces establecidos.
- Podrás comprobar que tienes tu propia UTS.
- Podrá saber si cal es su proceso de inicio.
- Dispondrá de conectividad con el exterior.
- Su memoria estará limitada a 512 MB a través de cgroups.

**Autoevaluación**: Revisa y autoevalúa tu trabajo aplicando los indicadores de logro.

**Criterios de corrección** / **Niveles de logro de desempeño**:

- Paso 1 (máximo de **40 puntos**)
 - **10 puntos** si el contenedor está en riesgo con sus propios namespaces.
 - **5 puntos** si la verificación UTS es correcta.
 - **5 puntos** si la verificación del proceso init es correcta.
 - **10 puntos** si el contenedor tiene conectividad externa.
 - **10 puntos** si el contenedor está en un cgroup que lo limita a 512 MB de memoria.

**Peso en calificación:**

- Peso de esta tarea en su asignatura ........................................... .......... 40%