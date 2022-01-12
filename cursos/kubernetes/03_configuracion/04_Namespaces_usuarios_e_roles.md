# Namespaces, usuarios e roles

No módulo 2 xa falamos dos namespaces como un xeito de agrupar os artefactos existentes no Kubernetes de xeito que non se produzan colisións de nomes. 

Os namespaces teñen outro papel fundamental: o de limitar o acceso dos usuarios a determinados recursos. Pero para facer isto, compre ter en conta dous elementos máis: usuarios e roles. 

Todo esto é o obxecto da presente unidade.

Podes pensar nun namespace como un cluster virtual dentro do teu cluster de kubernetes. Pódense ter varios namespaces dentro dun só cluster de kubernetes, e todos están aislados entre sí.

### Creando namespaces

Co shell:

```shell
kubectl create namespace <nome namespace>
```

Ou tamén podemos crealo cun archivo .yaml e aplicar
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

Kubernetes é un sistema pensado para xestionar grandes clúster de máquinas e facer un tratamento delas como si de unha soa se tratase. 

Compre, polo tanto, ter un sistema de usuarios. 

### a) Tipos de usuarios en Kubernetes

Existen en Kubernetes dous tipos de [usuarios](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#users-in-kubernetes):
- Contas de servizo
- Usuarios regulares

#### i) Usuarios regulares

Un usuario regular *non é un obxecto ou artefacto de Kubernetes*. Simplemente, un administrador de Kubernetes crea de diversos xeitos:

- un par de claves SSH 
- un ficheiro con usuarios e passwords. 
- Outros métodos como o KeyStone de Google...

É dicir, a creación de usuarios non está automatizada en Kubernetes nin se pode recorrer a chamadas á API. Trátase de servizos externos que configurarán dalgún xeito un acceso e darán conta (manualmente) a Kubernetes. 

Por suposto, os servizos administrados de Kubernetes (como AKS) teñen sistemas propios que despois integran dentro de Kubernetes pero, como xa dixemos son elementos externos ó K8s. 

#### ii) Contas de servizos

As contas de servizo sí son artefactos de Kubernetes. O seu papel é diferente: unha conta de servizo (Service Account) permite que determinados pods que están a correr dentro do clúster **poidan facer chamadas ó propio Kubernetes no que están a correr**.

A razón da súa existencia é clara: existen moitas ferramentas e programas que poden correr en Kubernetes e traballan contra a API de K8s para monitorizar tarefas, crear e xestionar elementos auxiliares, e mesmo apoiar ó desenvolvemento de aplicacións. 

Algunhas destas ferramentas serán obxecto do seguinte módulo. 

### b) Empregar as credencias de usuario normal para traballar contra un Kubernetes

A meirande parte do tempo, os usuarios normais utilizan o kubectl para traballar contra K8s. 

O administrador pasa, normalmente, un certificado que debemos integrar na nosa configuración de K8s para poder traballar. 

A ferramenta kubectl ten unha configuración que podemos ver, se facemos isto:

```shell
microk8s.kubectl config view --raw > $HOME/.kube/config
```

Agora temos exportada a nosa configuración de acceso:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    password: <password>
    username: admin
```

Vemos que a nosa configuración de kubectl está dividida en varias partes:
- **clústers**: cada clúster ó que queramos acceder terá que estar configurado aquí. 
- **contexts**: xestionan a información de acceso a cada clúster
- **current-context**: o contexto por defecto co que estamos a traballar (neste momento microk8s)
- **users**: credenciais de acceso mediante user/password. 

#### i) Agregar unha nova configuración para traballar contra un clúster de Kubernetes

Un administrador de Kubernetes danos un certificado para traballar contra un novo clúster. 

O primeiro que teríamos que facer é almacenar o ficheiro crt e a key nalgures na nosa máquina, por exemplo `~/.certs/`. 

Precisamos tamén establecer a información básica do cluster:

```shell
microk8s.kubectl config set-cluster <nome> --server=<dirección do cluster> --certificate-authority=<se o hai> 
```

Agora, temos que engadir a información ó noso kubernetes (creando unha nova entrada no users)

```shell
microk8s.kubect config set-credentials foo --client-certificate=<ruta do .crt> --client-key=<ruta do .key>
```

Se vemos a nosa config de kubectl teremos unha nova entrada en users para o usuario foo. 

Compre que creemos tamén un novo contexto para empregar estas credencias e acceder ó cluster:

```shell
kubectl config set-context foo-context --cluster=<cluster> --namespace=<ns> --user=foo
```

É dicir, definimos un novo contexto facendo referencia ó cluster e ó usuario que queremos empregar para entrar nese clúster. 

Se queremos traballar de xeito máis cómodo, podemos establecer como contexto por defecto o novo contexto e tódolos nosos comandos irán contra o novo clúster, sen ter que especificar o contexto en cada un deles:

```shell
microk8s.kubectl config use-context foo-context
```

## Roles e namespaces

[Kubernetes](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) emprega un sistema [RBAC](https://en.wikipedia.org/wiki/Role-based_access_control) (Role-Based Access Control) que permite xestionar os permisos do xeito seguinte:

- Os accesos e permisos se configuran en regras. 
- As regras agrúpanse nun rol. 
- O rol se asocia a un ou varios usuarios. 

### a) Roles en Kubernetes

Un rol de K8s é un artefacto que contén unha serie de regras que configuran permisos para acceder ós distintos recursos de Kubernetes. 

Antes de comezar coa súa definición, compre entender o que son os recursos da API de Kubernetes. 

#### i) Os recursos da API de Kubernetes

O máster de K8s exporta unha [API RESTful](https://kubernetes.io/docs/reference/using-api/api-concepts/) como punto de entrada ó sistema.

Esta API:

- Acepta os verbos estándar REST (POST, GET, PUT, PATCH, DELETE)
- Cada recurso (sustantivo) na API corresponde a un artefacto ou conxunto de artefactos:
  - pod, namespace, service...
  - ou a unha colección de artefactos
  - tódolos artefactos pertencen a un Kind (tipo)
- Os extremos da api están en ramas:
  - api/v1
  - api/extensions/v1beta1
  - ...

Dende o noso microk8s podemos consultar extremos de esta API para recoller o estado dos nosos artefactos. 

Estos extremos teñen o seguinte formato: `/api/v1/namespaces/<nome do namespace>/<tipo de recurso>/:<nome do recurso>`

Así:

```shell
# listar os services no namespace de "default"
curl http://127.0.0.1:8080/api/v1/namespaces/default/services

# recoller a información dun pod chamado "sonda-http"
curl http://127.0.0.1:8080/api/v1/namespaces/default/pods/sonda-http

# ver os logs do pod "sonda-http"
curl http://127.0.0.1:8080/api/v1/namespaces/default/pods/sonda-http/log
```

Vemos que os obxectos que devolve a API de K8s son estruturas en JSON. 
Poderíamos, empregando outros verbos, facer outras cousas:

```shell
# Borrar un pod chamado "sonda-http"
curl -X DELETE http://127.0.0.1:8080/api/v1/namespaces/default/pods/sonda-http/
```

Unha vez que entendemos a base da API podemos comezar a falar dos roles. 

#### ii) Tipos de roles en Kubernetes

Existen dous tipos fundamentais de roles en Kubernetes:

- **Role**: é un artefacto que permite establecer permisos sobre recursos a nivel dun namespace concreto. 
- **ClusterRole**: permite acceder a recursos globais (nodos) ou a artefactos (pods, services) en tódolos namespaces do sistema. 

As regras a dar para un rol, defínense conforme a dous dimensións:
- Recursos ós que afecta (pods, services, deploys...)
- Accións que se poden executar sobre eles (PUT, POST, GET, LIST)

Así, un Role que permite ver os pods pero non modificalos nin borralos ou crealos quedaría como sigue (para o namespace "default"):

```yaml
apiVersion: rbac.authorization.k8s.io/v1 # a api version é diferente da vista ata agora
kind: Role
metadata:
  namespace: default
  name: pods-so-lectura
rules:
- apiGroups: [""] # establece a API base ou core
  resources: ["pods"] # recursos ós que da acceso
  verbs: ["get", "watch", "list"] # accións ou verbos sobre eses recursos
  ```

Vemos como no artefacto establecemos as regras de acceso a recursos (pods) e as accións (get, watch, list). 

Nembargantes, non se dice nada de a qué usuarios afecta. 

A razón e que o Role define regras e permisos pero non usuarios. Para que afecten ós usuarios, compre **vincular os roles**. 

### b) A vinculación de roles: os RoleBinding

Un [RoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#default-roles-and-role-bindings) é un artefacto de Kubernetes que fai asociacións entre usuarios e Roles. 

É a forma de aplicar os roles que teñamos definidos ós usuarios que queremos que estén afectados por eses roles, e polas súas regras. 

Trátase dun artefacto de Kubernetes polo que ten a súa definición, é declarativo e pódese xestionar como calquer outro dos elementos xa estudiados. 

Nun exemplo, imaxinemos que queremos que o Role do apartado anterior afecte ó usuario **"xan"**. 

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

Dado que existen dous tipos de roles (Role e ClusterRole) tamén existen dous tipos de RoleBinding:
- **RoleBinding**: para asociar un Role a un namespace.
- **ClusterRoleBinding**: para asociar un Role ou ClusterRole a todo o clúster. 
