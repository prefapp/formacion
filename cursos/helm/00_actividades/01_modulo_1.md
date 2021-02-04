# Módulo 1: Primeros Pasos con Helm
## Creando a nosa primera release

Tal y como vimos en la parte expositiva, helm permite la abstracción de los artefactos de una aplicación, en gran medida, gracias a el uso de **charts** y **releases**. Durante esta práctica, crearemos una release de una base de datos, en este caso **MariaDB**, modificando algunos de sus parámetros de configuración.

### a) Añadiendo un repositorio
Como sabemos los **charts** de las diferentes aplicaciones, se encuentran en repositorios. Entonces, para que podamos instalar alguno de ellos desde helm, necesitamos añadirlos previamente.

Para esta práctica, trabajaremos con el chart de [MariaDB](https://hub.helm.sh/charts/bitnami/mariadb) de bitnami.El comando necesario para añadir un repositorio a helm es:

```shell
helm repo add <Nombre del repositorio> <URL del repositorio>
```

Tras esto, podemos listar los repositorios que hayamos añadido para ver si todo salió bien.

### b) Estableciendo valores de configuración
En este caso, el chart de **MariaDB** puede recibir ciertos parámetros de configuración desde un [fichero de valores](https://helm.sh/docs/chart_template_guide/values_files/) en formato YAML. Para esta práctica, será necesario modificar los siguientes parámetros del chart, todos ellos se pueden ver desde [aquí](https://hub.helm.sh/charts/bitnami/mariadb).

- El puerto del que haga uso el servicio será 3500.
- La contraseña del usuario **root** será el nombre del tutor.
- En cuanto a la base de datos a crear:
  - Tendrá como nombre: datos-maria
  - Contará con un usuario, cuyo nombre y contraseña tengan el formato: <Inicial nombre>-<1º Apellido>
- Se deshabilitará la persistencia para el **master** y el **slave**.

### c) Creando la release
Una vez hemos establecido los valores correcto de configuración dentro del fichero correspondiente, procederemos a instalar una aplicación de MariaDB, aplicando los parámetros de los ficheros.
```shell
helm install <Nombre de la release> -f <Fichero YML> bitnami/mariadb
```

Con **microk8s** podemos ver el estado de los pods y servicios necesarios. Haciendo uso de un cliente de MySQL, podremos comprobar que la aplicación esta funcionando correctamente.
```shell
mysql -h 127.0.0.1 -u <Nombre del usuario> -p
```

> Para poder conectarse desde nuestro equipo, será necesario redireccionar (**port-forward**) el puerto 3500 (Puerto del Servicio) al puerto 3306 del equipo (Puerto en el que escucha MySQL).

---
### Evaluación

**Evidencias de adquisición de desempeños**
- Envío de un pdf con los contenidos necesarios para realizar las actividades propuestas.

**Indicadores de logro:** El pdf deberá contener
- Los comandos necesarios para añadir un repositorio
- El fichero YAML con los parámetros de configuración
- Los comandos para crear la release
- Los comandos de conexión con la base de datos.