<<<<<<< HEAD
# Chapter 1

## Section 2
=======
# Empleo básico de Helm

## De la instalación de Helm

Helm funciona como un cli que podemos instalar en nuestro PC local (al igual que [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)). De hecho, vamos a necesitar que kubectl esté instalado en el sistema donde queramos correr Helm. 

Para instalar Helm basta con seguir alguno de los métodos que se describen en esta [guía](https://helm.sh/docs/intro/install/). 

Una vez que lo tengamos instalado podremos ver su versión:
```shell
~ helm version --short
v3.0.0-rc.3+g2ed2067
```
## De la interacción con las releases

Como sabemos, mediante Helm vemos las entidades residentes en nuestro clúster en forma de releases. 

En esta sección veremos las formas básicas de controlarlas. 

### a) Listado de releases
Parar obtener un listado de las releases de nuestro clúster, podemos recurrir a [helm list](https://helm.sh/docs/helm/helm_list/). 

Helm aisla las releases mediante [namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) de kubernetes, así que, normalmente listamos las releases de un namespace concreto:

```shell
~ helm ls -n curso-helm

NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
mi-bbdd curso-helm      1               2020-07-19 17:45:19.944032634 +0000 UTC deployed        mariadb-7.6.1   10.3.23
```

Como podemos ver, el listado de releases del namespace "curso-helm" nos da los siguientes resultados:
- Una release llamada mi-bbdd.
- El namespace al que pertenece.
- El número de revisión (sobre esto hablaremos más adelante).
- La fecha del último cambio. 
- Su estado (en este caso, desplegada). 
- El nombre y versión de la chart. 
- La versión de la aplicación (sobre las diferencias entre versión de chart y aplicación hablaremos en otra sección).

Si queremos ver todas las releases de todos los namespaces de un clúster, podemos recurrir al flag `--all-namespaces`:

```shell
~ helm list --all-namespaces
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
mi-bbdd curso-helm      1               2020-07-19 17:45:19.944032634 +0000 UTC deployed        mariadb-7.6.1   10.3.23
```

> Helm distingue entre namespaces a la hora de interactuar con las **releases**. Por lo tanto, pueden existir dos releases con el mismo nombre en distintos namespaces.

### b) Obtención de información de una release
Además de su listado, Helm nos ofrece otros métodos para obtener información de las releases existentes en un clúster. 

Mediante el comando [helm get](https://helm.sh/docs/helm/helm_get/) se pueden obtener distintas facetas relativas a una release:

```shell
# obtener toda la información disponible relativa a una release
~ helm get all mi-bbdd -n curso-helm

# obtener el manifiesto de una release
~ helm get manifest mi-bbdd -n curso-helm

# obtener los valores de una release
~ helm get values mi-bbdd -n curso-helm
```

Existen varias facetas recuperables de la información relativa a una release, por ahora nos basta con conocer:
- **all**: toda la información disponible. 
- **manifest**: el renderizado completo en yaml de la release (un fichero único con todos los artefactos y sus valores tal y como está instalado en el clúster)
- **values**: la configuración (la parte de datos) de la release, tanto la que aportamos nosotros a la hora de crearla como la que está establecida por defecto por parte de los desarrolladores de la chart. 

> Mediante el comando helm get se pueden obtener distintas facetas de la información existente sobre una release determinada.

### c) Borrado de releases
Para eliminar una release de nuestro clúster, basta con emplear [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/). 

```shell
~ helm uninstall mi-bbdd -n curso-helm
release "mi-bbdd" uninstalled
```

Como se puede apreciar en el ejemplo, es necesario enviar como parámetros el nombre de la release y el namespace en el que está instalada. 

El comando elimina completamente la presencia de la release (borra todos los artefactos y su configuración del clúster) aunque esto se puede parametrizar como veremos más adelante. 

### d) Instalación de releases
A esta parte dedicaremos la sección siguiente de la presente lección. 

>>>>>>> feature/tema1-helm
