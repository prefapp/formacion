# Pasando argumentos al contenedor

A estas alturas de la lección, ya sabemos que el contenedor es una unidad aislada desde el punto de vista de los recursos tradicionalmente compartidos en una máquina: usuarios, pids, mounts, red...

Este aislamiento es una de las claves para crear contenedores. Sin embargo, a veces desea poder controlar de alguna manera los procesos que se ejecutan dentro del contenedor. Es decir: programas de control pasando parámetros.

Hay dos formas principales de pasar parámetros a un contenedor:

- A través de los argumentos que llegan al programa que lanzamos mediante `docker-run` o `docker-create`.
- Asignar o cambiar los valores recibidos por las variables de entorno dentro del contenedor.

Nos centraremos en la segunda posibilidad en esta sección.

## Control de las variables de entorno de un contenedor

Antes de ejecutar un contenedor, Docker le permite establecer cuál será el valor de su entorno pasando binomios clave=valor.

Por lo tanto, si tenemos una aplicación que necesita un nombre de usuario/contraseña de administrador y los recopila de las variables de entorno, por ejemplo (ROOT_LOGIN, ROOT_PASSWORD), podríamos hacer lo siguiente:

```shell
docker run -d -e ROOT_LOGIN=admin -e ROOT_PASSWORD=segredo imaxe-de-app-con-admin
```

En este ejemplo:

- Se crea un contenedor y se lanza en modo daemon (_**run -d**_)
- Con una imagen ficticia (_**app-image-with-admin**_)
- Establecer para crear o cambiar (_**-e**_) el valor de una variable de entorno (**ROOT_LOGIN** con valor admin)
- Lo mismo (_**-e**_) para la variable **ROOT_PASSWORD** (valor secreto)
Docker inyectará estas variables en el contenedor antes de iniciarlo para que, si el programa está listo para hacerlo, pueda recoger su configuración del ENV.

![Contorno del contenedor](./../_media/02_docker/contedor_contorno.png)

> ⚠️ Obviamente, si queremos cambiar el valor de las variables de entorno de un contenedor en ejecución, debemos reiniciarlo o recrearlo.