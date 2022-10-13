# Módulo 2: Kubernetes: navegando nun océano de contedores

## Instalando Kubernetes na nosa máquina local

Como falaramos na parte [expositiva](https://prefapp.github.io/formacion/cursos/kubernetes/#/./02_kubernetes/01_que_e_kubernetes), Kubernetes pódese instalar de moitos xeitos e ten vocación de correr en diferentes contornas (cloud, on premise, bare-metal...) e, tamén, na nosa máquina local.

No curso, recomendamos a creación dos clústeres locais utilizando Kind. Para isto, debemos ter instalado tanto Kind coma kubectl tal e como se explicou no apartado de [instalación de Kind](https://prefapp.github.io/formacion/cursos/kubernetes/#/./02_kubernetes/07_instalando_kind).


### a) Creación de clústeres con kind

O primeiro paso será verificar que Kind está instalado correctamente. Para isto, lanzamos o seguinte comando:

```shell
kind version
```

Que devolverá unha resposta similar á seguinte:

```shell
kind v0.14.0 go1.18.2 linux/amd64
```

Agora, creamos un novo clúster en kind:

```shell
kind create cluster
```

Que debería producir algo coma isto:

![actividades2](./../_media/02/actividades11.png)

E podemos usar kubectl para ver o nodo que acabamos de crear:

```shell
~ > kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kind-control-plane   Ready    control-plane   3m53s   v1.24.0
```
### b) Habilitar o dashboard:

Kubernetes expón un dashboard para traballar de xeito gráfico e ver o estado do clúster.

Para despregalo cómpre executar:

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
```

Isto creará os artefactos precisos para facelo funcionar. 

A maiores, necesitaremos crear un usuario de test con permisos para acceder ó dashboard. Para isto, crearemos os seguintes artefactos:

```yaml
# dashboard_adminuser.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

```

```yaml
# dashboard_rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard

```

E os aplicamos:

```shell
kubectl apply -f dashboard_adminuser.yaml
kubectl apply -f dashboard_rolebinding.yaml
```

Lanzamos a seguinte orde para obter o token asociado ó usuario que acabamos de crear:

```shell
kubectl -n kubernetes-dashboard create token admin-user
```

E, para habilitar o acceso ó Dashboard, lanzamos:

```shell
kubectl proxy
```

Deste xeito, kubectl facilitaranos o acceso a través de: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Entramos neste enlace e introducimos na pantalla de login o token que creamos anteriormente, e xa poderemos ver o dashboard.

### c) Eliminar o clúster

Unha vez rematemos de traballar cun clúster, podemos eliminalo. Para isto faremos:


```shell
kind delete cluster
```

E o sistema eliminará o clúster local da nosa máquina.



### Evaluación

**Evidencias da adquisición dos desempeños**:
- Captura de pantalla da versión de Kind (ver parágrafo a).
- Captura de pantalla da versión dos nodos creados con Kind co dashboard (parágrafo e) habilitado.

**Indicadores de logro**: Deberías ter...
- Correctamente instalado o Kind.
- Habilitado o dashboard e feito o acceso dende o navegador.

**Criterios de corrección**:
- 15 puntos se hai unha captura da pantalla coa saída da versión de Kind.
- 5 puntos se hai unha captura de pantalla do navegador co dashboard de kubernetes funcionando.

**Autoavaliación**: Autoavalía esta tarefa aplicando os indicadores de logro anteriores.

**Peso na cualificación**:
- Peso desta tarefa na cualificación final ........................................ 30 puntos
- Peso desta tarefa no seu tema ...................................................... 30 %

---


## Correndo a nosa primeira aplicación en Kubernetes

Imos comezar a nosa andaina con Kubernetes.

Para poder completar esta práctica compre ter completada a tarefa onde puxemos a funcionar o noso entorno de Kind, cun clúster levantado.

Imos a montar unha sinxela aplicación escrita en nodejs que fai o seguinte:
- Corre un servidor web nun contedor.
- Cando recibe unha petición, amosa por pantalla a seguinte información:
  - Versión da aplicación.
  - O hostname.
  - O uptime da aplicación en horas : minutos : segundos.

### a) Despregue en pod

Para comezar, imos despregar a nosa aplicación nun [pod](https://prefapp.github.io/formacion/cursos/kubernetes/#/./02_kubernetes/03_arquitectura_kubernetes_pod):
- A imaxe a montar será "frmadem/catro-eixos-k8s-ej1", co tag "v1", esto é: "frmadem/catro-eixos-k8s-ej1:v1".
- O pod terá como nome "pod-practica-1".
- Executará como comando "npm" "run" "iniciar".
- Compre configurarlle unha variable de contorna:
  - "PUERTO_APP" co valor "80" para que escoite no porto 80.

Crearáse un ficheiro chamado "pod.yaml" e o correremos con kubectl apply.

Unha vez feito isto, deberíamos ter algo como o que segue:

![actividades6](./../_media/02/actividades6.png)

Precisamos, agora, probar a nosa aplicación para ver se da resposta. Para iso, imos exportar un porto conectado co pod a través de `kubectl port-forward`.

```shell
kubectl port-forward pod/pod-practica-1 --address 0.0.0.0 <porto_de_elección_do_vm>:80
```

Feito isto, deberíamos poder ver o resultado da execución no noso navegador:

![actividades7](./../_media/02/actividades7.png)

Vemos a **versión** da aplicación, o **hostname** (o nome do pod onde está a correr) e as **hh:mm:ss** que leva correndo.

### b) Montando un deploy

Se queremos correr a nosa aplicación con réplicas e control das mesmas compre que empreguemos un [deploy](https://prefapp.github.io/formacion/cursos/kubernetes/#/./02_kubernetes/04_arquitectura_kubernetes_deployment).

Para montar o noso despregue temos que cumprir unha serie de requisitos:
- O despregue terá como nome "**despregue-practica-1**".
- Comezará cunha réplica.
- Os pods escoitarán no porto 8080.

![actividades8](./../_media/02/actividades8.png)

Unha vez creado o artefacto, o lanzamos.

Comproba que realmente tes o deploy e o pod correndo correctamente.

Agora o imos a escalar a 5 réplicas. Que comando haberá que empregar?

Unha vez que o teñas feito, comproba que realmente hai cinco réplicas correndo.

Volve a establecer as réplicas a 1.

Lista os pods que quedan unha vez feita esta operación.

### c) Expoñendo a nosa aplicación a través dun servizo

Agora, temos un deploy que ten réplicas e queremos que poida dar resposta calquera delas.

Para iso, compre montar un servizo.

O [servizo](https://prefapp.github.io/formacion/cursos/kubernetes/#/./02_kubernetes/05_arquitectura_kubernetes_service) que expón o noso deploy ten que ter novamente unha serie de características:
- O servizo terá como nome "**servizo-practica-1**".
- O porto do servizo será o 80
- Conectará cos pods no porto 8080.
- Quedará o noso sistema como segue:

![actividades9](./../_media/02/actividades9.png)

Creamos o artefacto do servizo e o lanzamos.

Comprobamos que está realmente creado no noso clúster. Que comando empregaremos?

Facemos un curl ó clusterIp do noso servizo. Que saída teremos?

### d) Montando un frontend para a nosa aplicación

Agora que temos un deploy cos nosos pods e un servizo que os expón, solo nos resta montar un frontend que faga peticións ó mesmo.

Para montar este o frontend:
- Imos empregar a imaxe **frmadem/catro-eixos-k8s-proxy**.
- Esta imaxe a montaremos nun novo despregue.
- Este despregue terá:
  - Unha soa réplica.
  - O seu nome será "**frontend-practica-1**"./s/1.
  - Configuraremos como variable de contorna "SERVIZO_INTERNO" que resolverá ó servizo que creamos no punto c).
  - O pod expoñerá o porto 80.
- Ademáis do despregue, crearemos un servizo para o noso frontend. Coas seguintes características:
  - Terá de nome "servizo-frontend-practica-1".
  - Escoitará no porto 8080 (o porto do servizo será o 8080).
  - Comunicará cos pods no porto 80.

Crearemos os artefactos do deploy de frontend e do servizo de frontend. Quedando a nosa aplicación como segue:

![actividades10](./../_media/02/actividades10.png)

Despregamos os nosos artefactos de frontend. Comprobamos que están creados realmente.

### e) Comprobar que todo está en orde

Agora imos exportar (proxy-forward) o noso servizo de frontend. E enviamos unha petición dende o noso navegador, debería sair unha saída como a do punto a).

Imos, por último, escalar a 5 réplicas o deploy de prácticas (o de backend non o de frontend).

Se recargamos o noso navegador, veremos que o pod que nos responde é diferente en cada execución. (vese no hostname).

### Evaluación

**Evidencias da adquisición dos desempeños**:
- Envío dun pdf cos contidos necesarios para realizar os puntos do a) ó e) segundo estes.

**Indicadores de logro**: Deberías ter...
- Artefacto co yaml necesario para crear o pod cos requisitos do **punto a**) (pod.yaml). Captura de pantalla dos comandos necesarios para:
  - Arrancar o yaml.
  - Comprobar que o pod está a correr (e a súa saída).
  - Exportar o pod.
  - Captura do navegador coa saída do pod.
- Artefacto do yaml necesario para crear o deploy cos requisitos do **punto b**) (deploy.yaml) Captura de pantalla cos comandos necesarios para:
  - Arrancar o yaml.
  - Comprobar que o deploy e o pod están a correr (a as súas saídas).
  - Escalar a cinco réplicas o deploy.
  - Comprobar que hai cinco réplicas (e a súa saída).
  - Reducir a unha réplica.
  - Comprobar que volve a haber unha réplica (e a súa saída).
- Artefacto co yaml necesario para crear o servizo cos requisitos do **punto c**) (servizo.yaml) Captura da pantalla cos comandos necesarios para:
  - Arrancar o yaml.
  - Comprobar que o servizo se creou (e a súa saída).
  - Curl á ipcluster do servizo (e a súa saída).
- Artefactos co yaml necesario para crear o deploy e servizo de frontend coas características do **punto d**) Capturas de pantalla dos comandos necesarios para:
  - Arrancar os yaml.
  - Comprobar que servizo, deploy e pods están creados (e as súas saídas).
- Comprobar que todo está en orde segundo o **punto e**):
  - Comando de exportar o porto do "servizo-frontend-practica-1".
  - Captura de pantalla do navegador coa saída do ```localhost:<porto forwarded escollido>```.
  - Comando para escalar a cinco réplicas.
  - Tres capturas de navegador con respostas de distintos pods.

**Criterios de corrección**:
- ata 15 puntos do apartado a):
  - 7 puntos se o yaml de creación do pod está correcto.
  - 2 puntos por cada comando / captura de saída correcto.
- ata 10 puntos do apartado b):
  - 4 puntos se o yaml de creación do deploy está correcto.
  - 1 punto por cada comando/captura de saída correcto.
- ata 7 puntos do apartado c):
  - 3 puntos se o yaml de creación do servizo está correcto.
  - 1 punto por cada comando/captura de saída correcto.
- ata 10 puntos do apartado d):
  - 2 puntos por cada artefacto correcto (deploy e service).
  - 1 punto por cada comando/captura de saída correcto.
- ata 8 puntos do apartado e):
  - 2 puntos por cada comando/captura de saída correcto.

**Autoavaliación**: Autoavalía esta tarefa aplicando os indicadores de logro anteriores.

**Peso na cualificación**:
Peso desta tarefa na cualificación final ...................................... 50 puntos
Peso desta tarefa no seu tema .................................................... 50 %
