# Namespaces, usuarios y roles

En el Módulo 2 ya hablamos sobre namespaces como una forma de agrupar los artefactos existentes en Kubernetes para que no se produzcan colisiones de nombres.

Los namespaces tienen otro papel fundamental: el de limitar el acceso de los usuarios a determinados recursos. Pero para hacer esto, debe considerar dos elementos más: usuarios y roles.

Todo esto es el objeto de esta unidad.

Puede pensar en un namespaces como un clúster virtual dentro de su clúster de kubernetes. Puede tener varios namespaces dentro de un solo clúster de kubernetes y todos están aislados entre sí.

### Creación de namespaces

Con shell:

```shell
kubectl create namespace <nome namespace>
```

O también podemos crearlo con un archivo .yaml y aplicar
```yaml
#test.yaml
kind: Namespace
apiVersion: v1
metadata:
  name: test
  labels:
    name: test
```

## Usuarios

Kubernetes es un sistema diseñado para administrar grandes clústeres de máquinas y tratarlas como si fueran una sola.

Por lo tanto, necesita tener un sistema de usuarios.

### a) Tipos de usuarios en Kubernetes

En Kubernetes hay dos tipos de [usuarios](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#users-in-kubernetes):
- Usuarios regulares
- Cuentas de servicio
#### i) Usuarios regulares

Un usuario regular *no es un objeto o artefacto de Kubernetes*. En pocas palabras, un administrador de Kubernetes crea varias formas:

- Un par de claves SSH
- Un fichero con usuarios y contraseñas.
- Otros métodos como KeyStone de Google...

Es decir, la creación de usuarios no está automatizada en Kubernetes, ni se puede recurrir a llamadas a la API. Estos son servicios externos que de alguna manera configurarán un acceso e informarán (manualmente) a Kubernetes.

Por supuesto, los servicios gestionados de Kubernetes (como AKS) tienen sus propios sistemas que luego se integran en Kubernetes, pero, como ya hemos dicho, son elementos externos a K8s.

#### ii) Cuentas de servicio

Las cuentas de servicio son, de hecho, artefactos de Kubernetes. Su función es diferente: una cuenta de servicio (Service Account) permite que ciertos pods que se ejecutan dentro del clúster **puedan realizar llamadas al propio Kubernetes en el que se ejecutan**.

La razón de su existencia es clara: hay muchas herramientas y programas que pueden ejecutarse en Kubernetes y trabajar con la API de K8s para monitorear tareas, crear y administrar ayudantes e incluso respaldar el desarrollo de aplicaciones.

Algunas de estas herramientas serán el tema del próximo módulo.

### b) Usar credenciales de usuario normales para trabajar con Kubernetes

La mayoría de las veces, los usuarios normales usan kubectl para trabajar con K8.

El administrador suele pasar un certificado que debemos integrar en la configuración de nuestro K8s para poder funcionar.

La herramienta kubectl tiene una configuración que podemos ver, si hacemos esto:

```shell
kubectl config view --raw > $HOME/.kube/config
```

Ya tenemos exportada nuestra configuración de acceso:

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:34023
  name: kind-kind
contexts:
- context:
    cluster: kind-kind
    user: kind-kind
  name: kind-kind
current-context: kind-kind
kind: Config
preferences: {}
users:
- name: kind-kind
  user:
    client-certificate-data: [...]
    client-key-data: [...]
```

Vemos que nuestra configuración de kubectl se divide en varias partes:
- **clústers**: aquí habrá que configurar cada clúster al que queramos acceder.
- **contexts**: gestionan la información de acceso a cada clúster
- **current-context**: el contexto predeterminado con el que estamos trabajando (actualmente kind-kind)
- **users**: credenciales de acceso mediante user/password.

#### i) Agregar una nueva configuración para trabajar con un clúster de Kubernetes

Un administrador de Kubernetes nos da un certificado para trabajar con un nuevo clúster.

Lo primero que tendríamos que hacer es almacenar el archivo `crt` y la `key` en algún lugar de nuestra máquina, por ejemplo `~/.certs/`.

También necesitamos establecer la información básica del clúster:

```shell
kubectl config set-cluster <nombre> --server=<dirección-del-cluster> --certificate-authority=<si la hay> 
```

Ahora, tenemos que agregar la información a nuestro kubernetes (creando una nueva entrada en usuarios)

```shell
kubectl config set-credentials foo --client-certificate=<ruta-del-.crt> --client-key=<ruta-del-.key>
```

Si vemos nuestra config de kubectl, tendremos una nueva entrada en users para el usuario foo.

Hace falta que creemos un nuevo contexto para usar estas credenciales y acceder al clúster:

```shell
kubectl config set-context foo-context --cluster=<cluster> --namespace=<ns> --user=foo
```

Es decir, definimos un nuevo contexto que hace referencia al clúster y al usuario que queremos usar para ingresar a ese clúster.

Si queremos trabajar más cómodamente, podemos establecer el nuevo contexto como contexto predeterminado y todos nuestros comandos irán contra el nuevo clúster, sin tener que especificar el contexto en cada uno de ellos:

```shell
kubectl config use-context foo-context
```

## Roles y namespaces

[Kubernetes](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) utiliza un sistema [RBAC](https://en.wikipedia.org/wiki/Role-based_access_control) (Role-Based Access Control) que le permite administrar los permisos de la siguiente manera:

- Los accesos y permisos se configuran en reglas.
- Las reglas se agrupan en un rol.
- El rol está asociado a uno o más usuarios.

### a) Roles en Kubernetes

Un rol de K8s es un artefacto que contiene una serie de reglas que configuran permisos para acceder a los distintos recursos de Kubernetes.

Antes de comenzar con su definición, es necesario entender qué son los recursos de la API de Kubernetes.

#### i) Los recursos de la API de Kubernetes

El master de K8s exporta una [API RESTful](https://kubernetes.io/docs/reference/using-api/api-concepts/) como punto de entrada al sistema.

Esta API:

- Acepta verbos REST estándar (POST, GET, PUT, PATCH, DELETE)
- Cada recurso (sustantivo) en la API corresponde a un artefacto o conjunto de artefactos:
  - pod, namespaces, service...
  - o a una colección de artefactos.
  - todos los artefactos pertenecen a un Kind (tipo)
- Los puntos finales de API están en ramas:
  - api/v1
  - api/extensiones/v1beta1
  - ...

Desde nuestro clúster podemos consultar los extremos de esta API para recopilar el estado de nuestros artefactos.

Estos puntos finales tienen el siguiente formato: `/api/v1/namespaces/<nombre-del-namespace>/<tipo-de-recurso>/:<nombre-del-recurso>`

Como esto:

```shell
# listar los services en el namespace "default"
curl http://127.0.0.1:8080/api/v1/namespaces/default/services

# recoger la información de un pod llamado "sonda-http"
curl http://127.0.0.1:8080/api/v1/namespaces/default/pods/sonda-http

# ver logs del pod "sonda-http"
curl http://127.0.0.1:8080/api/v1/namespaces/default/pods/sonda-http/log
```

Vemos que los objetos devueltos por la API de K8s son estructuras JSON.

Podríamos, usando otros verbos, hacer otras cosas:

```shell
# Borrar un pod chamado "sonda-http"
curl -X DELETE http://127.0.0.1:8080/api/v1/namespaces/default/pods/sonda-http/
```

Una vez que entendemos la base de la API, podemos comenzar a hablar de los roles.

#### ii) Tipos de roles en Kubernetes

Hay dos tipos fundamentales de roles en Kubernetes:

- **Role**: es un artefacto que permite establecer permisos sobre los recursos a nivel de un namespace específico.
- **ClusterRole**: permite acceder a recursos globales (nodos) o artefactos (pods, services) en todos los namespaces del sistema.

Las reglas a dar para un rol se definen de acuerdo a dos dimensiones:
- **Recursos** afectados (pods, servicios, deployments...)
- **Acciones** que se pueden ejecutar sobre ellos (PUT, POST, GET, LIST)

Por lo tanto, un rol que le permita ver los pods pero no modificarlos, eliminarlos o crearlos se vería así (para el namespace "default"):

```yaml
apiVersion: rbac.authorization.k8s.io/v1 # la versión api es diferente de la vista hasta ahora
kind: Role
metadata:
  namespace: default
  name: pods-so-lectura
rules:
- apiGroups: [""] # establece la API base en el core
  resources: ["pods"] # recursos a los que da acceso
  verbs: ["get", "watch", "list"] # acciones o verbos sobre esos recursos
  ```

Vemos como en el artefacto establecemos las reglas de acceso a los recursos (pods) y las acciones (get, watch, list).

Sin embargo, no se dice nada sobre a qué usuarios afecta.

La razón es que el Rol define reglas y permisos pero no usuarios. Para que afecten a los usuarios, necesitas **vincular los roles** (RoleBinding).

### b) Vinculación de roles: RoleBinding

Un [RoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#default-roles-and-role-bindings) es un artefacto de Kubernetes que vincula a los usuarios con los roles.

Es la forma de aplicar los roles que hemos definido a los usuarios que queremos que se vean afectados por esos roles, y por sus reglas.

Es un artefacto de Kubernetes por lo que tiene su definición, es declarativo y se puede gestionar como cualquier otro de los elementos ya estudiados.

En un ejemplo, imaginemos que queremos que el Rol de la sección anterior afecte al usuario **"xan"**. 

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: vincular-role
  namespace: default
subjects: # aquí os usuarios ós que vai a afectar
- kind: User
  name: xan
  apiGroup: rbac.authorization.k8s.io
roleRef:  # aquí o role que aplicamos
  kind: Role
  name: pods-so-lectura
  apiGroup: rbac.authorization.k8s.io
```

Dado que hay dos tipos de roles (Role y ClusterRole) también hay dos tipos de RoleBinding:
- **RoleBinding**: para asociar un Rol a un namespaces.
- **ClusterRoleBinding**: para vincular un Rol o un ClusterRole a todo el clúster.
