# Uso de Kind coma ferramenta de desenvolvemento

Ó longo deste curso, necesitaremos o uso dunha das ferramentas para desenvolvemento que mencionamos ó principio do módulo, para poder crear clústeres onde despregar as prácticas. Recomendamos o uso de Kind, pola potencia e flexibilidade que nos aporta. 

## Instalación de kubectl

O primeiro paso será instalar kubectl, que é a ferramenta de liña de comandos de kubernetes, e que nos permitirá comunicarnos cos clústeres que creemos. Para isto, seguimos os pasos que nos indican na [documentación oficial](https://kubernetes.io/docs/tasks/tools/). En Linux, faríamolo do seguinte modo:

- Descargamos a última release do binario:

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

- Lanzamos a súa instalación:

```shell
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

- Comprobamos que kubectl está funcionando, solicitándolle a versión:

```shell
kubectl version --output=yaml

```

## Instalación de Kind

Unha vez kubectl esté funcionando, xa podemos instalar kind. No seguinte enlace podedes acceder á [guía de instalación de kind](https://kind.sigs.k8s.io/docs/user/quick-start), onde se explican os pasos a seguir segundo o sistema operativo que se esté utilizando. No caso de Linux, o máis sinxelo será facer a [instalación do binario](https://kind.sigs.k8s.io/docs/user/quick-start#installing-from-release-binaries).

Unha vez rematemos a instalación, xa podemos crear un novo clúster. O xeito máis sinxelo para facelo é mediante a seguinte orde:

```sh
kind create cluster
```

Isto creará un clúster chamado "kind" cos valores por defecto. Pódeselle dar un nome distinto utilizando a flag `--name`.

Unha das vantaxes do uso de kind é a súa flexibilidade na creación dos clústeres: podemos especificar o número de nodos, a imaxe que usan (para poder usar distintas versións de kubernetes), a súa configuración de rede, etc. Podes consultar as distintas posibilidades de configuración que ofrece na súa [documentación](https://kind.sigs.k8s.io/docs/user/configuration/).

Para listar os clústeres que teñamos levantados nun momento determinado, poderemos utilizar a seguinte orde, que devolverá unha lista cos nomes dos clústeres que hai creados:

```sh
kind get clusters
```

Por último, ó rematar de usar o clúster, pódese eliminar coa seguinte orde:

```sh
kind delete cluster
```

Isto eliminará o clúster cuxo nome sexa "kind". En caso de que o clúster que queremos borrar teña un nome diferente, podemos indicalo utilizando a flag `--name`.