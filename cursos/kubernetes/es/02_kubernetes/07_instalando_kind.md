# Uso de Kind como herramienta de desarrollo

A lo largo de este curso, necesitaremos el uso de una de las herramientas de desarrollo que mencionamos al comienzo del módulo, para poder crear clústeres donde se puedan implementar las prácticas. Recomendamos el uso de Kind, por la potencia y flexibilidad que proporciona.

## Instalación de kubectl

El primer paso será instalar kubectl, que es la herramienta de línea de comandos de kubernetes, y que nos permitirá comunicarnos con los clústeres que creemos. Para ello seguimos los pasos indicados en la [documentación oficial](https://kubernetes.io/docs/tasks/tools/). En Linux, lo haríamos así:

- Descargamos la última versión del binario:

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

- Ponemos en marcha tu instalación:

```shell
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

- Comprobamos que kubectl funciona, preguntando por la versión:

```shell
kubectl version --output=yaml

```

## Instalación de Kind

Una vez que kubectl esté funcionando, podemos instalar kind. En el siguiente enlace se puede acceder a la [guía de instalación de Kind](https://kind.sigs.k8s.io/docs/user/quick-start), donde se explican los pasos a seguir según el sistema operativo que se utilice. En el caso de Linux, lo más fácil será [instalar el binario](https://kind.sigs.k8s.io/docs/user/quick-start#installing-from-release-binaries).

Una vez que hayamos terminado la instalación, ya podemos crear un nuevo clúster. La forma más fácil de hacer esto es usando el siguiente comando:

```sh
kind create cluster
```

Esto creará un clúster llamado "Kind" con los valores predeterminados. Se le puede dar un nombre diferente usando el indicador `--name`.

Una de las ventajas de utilizar kind es su flexibilidad a la hora de crear los clústeres: podemos especificar el número de nodos, la imagen que utilizan (para poder utilizar diferentes versiones de kubernetes), su configuración de red, etc. Puedes consultar las diferentes posibilidades de configuración que ofrece en su [documentación](https://kind.sigs.k8s.io/docs/user/configuration/).

Para listar los clústeres que hemos levantado en un momento dado, podemos utilizar el siguiente comando, que nos devolverá una lista con los nombres de los clústeres que se han creado:

```sh
kind get clusters
```

Finalmente, cuando haya terminado de usar el clúster, puede eliminarlo con el siguiente comando:

```sh
kind delete cluster
```

Esto eliminará el clúster cuyo nombre es "Kind". En caso de que el clúster que queremos eliminar tenga un nombre diferente, podemos indicarlo mediante el flag `--name`.

Para crear nodos dentro del mismo clúster kind podemos utilizar un yaml declarando la estructura. Por ejemplo, un clúster con un nodo de control y 3 workers.

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4  
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
```

Lo podemos desplegar con el comando:

	create cluster --name multi-node –config=config.yaml

