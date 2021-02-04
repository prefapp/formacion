<<<<<<< HEAD
# Chapter 1

## Section 3
=======
# De la instalación de releases

Como sabemos, Helm crea instalaciones (releases) de aplicaciones mediante la interpolación de la configuración que deseemos en un conjunto de plantillas que reciben el nombre de charts. 

Esta sección está dedicada al estudio de los pormenores del empleo de charts predefinidas para su instalación en un clúster de k8s. 

## Búsqueda de charts

Como ya vimos en secciones anteriores, existe un repositorio oficial de charts de Helm en: [helm hub](https://hub.helm.sh/).

El código de estas charts se puede encontrar normalmente en un repositorio público alojado en esta [dirección](https://github.com/helm/charts).

### Tarea
Prueba a entrar en helm hub y busca las siguientes charts:
- MariaDB de bitnami.
- Wordpress de bitnami. 
- La versión 7.7.1 del elastic stack. 

## Empleo de charts: los repos
Existen, como hemos visto, repositorios públicos de charts de Helm que podemos usar. 

No obstante, y al igual que ocurre con las imágenes de docker, Helm necesita descargar la chart al sistema para poder emplearla. 
>>>>>>> feature/tema1-helm
