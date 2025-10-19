# Interrupcións
Como xa sabemos, os `pod` son as unidades despregables máis pequenas de Kubernetes. Cada `pod` apunta a un único proceso de execución dentro do sistema e opera desde un nodo ou máquina virtual dentro de Kubernetes, que pode adoptar unha forma virtual ou física.

Ocasionalmente pódense producir interrupcións nos `pod` de Kubernetes dentro dun sistema. É máis probable que estas interrupcións se produzan en aplicacións de alta dispoñibilidade e son unha preocupación para os administradores do clúster.

## 1. Interrupcións voluntarias e involuntarias
Hai dous tipos de interrupcións de `pod` en Kubernetes: as interrupcións voluntarias causadas por accións deliberadas dos administradores e propietarios das aplicacións e as interrupcións involuntarias inevitables derivadas de fallos de hardware ou software.

Exemplos de interrupcións involuntarias son:
- Un fallo de hardware da máquina física que apoia o nodo
- O administrador do clúster elimina a VM por erro
- Un kernel panic

Exemplos de interrupcións voluntarias son:
- Iniciadas polo propietario:
  - Eliminar o `deployment` ou outro controlador que xestione o `pod`
  - Actualizar o template do `deployment` provocando un reinicio
  - Eliminar directamente un `pod` (por exemplo, por accidente)
- Iniciadas polo administrador:
  - [Drenar un nodo](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/) para reparar ou actualizar.
  - Drenar un nodo para reducir o tamaño do clúster ([Cluster Autoescaling](https://github.com/kubernetes/autoscaler/#readme)).
  - Eliminar un `pod` dun nodo para permitir que outra cousa caiba nese nodo.

### 1.1 Xestionar as interrupcións
Contra as interrupcións involuntarias soamente pódese facer un traballo de prevención. Aquí tes algunhas formas de mitigalas:
- Asegúrate de que os `pod` solicitan os [recursos que precisan](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/).
- Replica a túa aplicación se necesitas maior disponibilidade (Réplica de aplicacións [sen estado](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/) e [con estado](https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/))
- Para unha dispoñibilidade aínda maior ao executar aplicacións replicadas, espalla as aplicacións en racks (usando [anti-affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)) ou entre zonas (usando un [cluster multizona](https://kubernetes.io/docs/setup/best-practices/multiple-zones/)).

Contra as interrupcións voluntarias Kubernetes pon a nosa disposición un recurso, o `PodDisruptionBudget` (PDB) 

Atención:
Non todas as interrupcións voluntarias son restrinxidas polos `PodDisruptionBudget`. Por exemplo, a eliminación de deployments ou pods non os teñen en conta.

## 2. Pod disruption budgets (PDB)
O obxectivo principal dun `PodDisruptionBudget` é garantir que un número mínimo especificado de `pod` estea sempre dispoñible e mantendo a dispoñibilidade e fiabilidade xerais do servizo. Isto é especialmente crítico para aplicacións que requiren alta dispoñibilidade, xa que evita que o sistema non estea dispoñible ou reduza a súa capacidade por debaixo dun nivel que a empresa considere aceptable.

Isto significa que cando iniciamos unha interrupción voluntaria, Kubernetes comproba os nosos `PodDisruptionBudget` para garantir que a operación non fará que a dispoñibilidade da nosa aplicación caia por debaixo dos niveis especificados.
Así, se a operación infrinxe a nosa `PodDisruptionBudget`, Kubernetes espera ou axusta as súas accións en consecuencia, minimizando o tempo de inactividade potencial e mantendo a fiabilidade do noso servizo.

Vexamos a estrutura básica dun `PodDisruptionBudget` en formato YAML:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-pdb
spec:
  minAvailable: 2
  maxUnavailable: 1
  selector:
    matchLabels:
      app: myapp
```
Neste manifesto, definimos un `PodDisruptionBudget` con `name: my-pdb` que garante que nos `pod` con label `app: myapp` sempre haxa polo menos 2 dispoñibles e nunca máis de 1 non dispoñible
- `minAvailable`: especifica o número mínimo de `pod` que deben permanecer dispoñibles, expresable como un número absoluto ou unha porcentaxe do total de `pod`.
- `maxUnavailable`: define o número máximo de `pod` que poden non estar dispoñibles durante a interrupción, expresado tamén como un número absoluto ou unha porcentaxe.
- `selector`: determina a que `pod` se aplica o `PodDisruptionBudget`, usando etiquetas para seleccionar os `pod` relevantes.

## 3. Práctica guiada

Imos facer unha práctica guiada para ver como funciona un `PodDisruptionBudget`

Executamos o seguinte comando para crear un cluster formado por 4 nodos con kind
```shell
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: cluster-test-pdb
#name: kind1
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
EOF
```
Unha vez creado o cluster deberíamos poder listar os nosos nodos
```shell
kubectl get nodes
NAME                             STATUS   ROLES           AGE     VERSION
cluster-test-pdb-control-plane   Ready    control-plane   2m13s   v1.31.0
cluster-test-pdb-worker          Ready    <none>          2m2s    v1.31.0
cluster-test-pdb-worker2         Ready    <none>          2m2s    v1.31.0
cluster-test-pdb-worker3         Ready    <none>          2m2s    v1.31.0
```

Vamos a despregar un `deployment` dun nginx con 6 réplicas
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 6
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
```shell
kubectl apply -f deployment.yaml
```
Se enumeramos os `pod` veremos como seguramente despregou 2 por nodo worker do noso clúster
```shell
kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE                       NOMINATED NODE   READINESS GATES
nginx-deployment-7769f8f85b-45v8n   1/1     Running   0          67s   10.244.1.3   cluster-test-pdb-worker    <none>           <none>
nginx-deployment-7769f8f85b-8rfk2   1/1     Running   0          67s   10.244.1.2   cluster-test-pdb-worker    <none>           <none>
nginx-deployment-7769f8f85b-9dh6d   1/1     Running   0          67s   10.244.3.2   cluster-test-pdb-worker3   <none>           <none>
nginx-deployment-7769f8f85b-9zf2h   1/1     Running   0          67s   10.244.2.2   cluster-test-pdb-worker2   <none>           <none>
nginx-deployment-7769f8f85b-cz9db   1/1     Running   0          67s   10.244.2.3   cluster-test-pdb-worker2   <none>           <none>
nginx-deployment-7769f8f85b-szfzv   1/1     Running   0          67s   10.244.3.3   cluster-test-pdb-worker3   <none>           <none>
```
Agora engadimos o noso `PodDisruptionBudget`
```yaml
# pdb.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-pdb
spec:
  minAvailable: 5
  selector:
    matchLabels:
      app: nginx
```
```shell
kubectl apply -f pdb.yaml
```
Ao aplicar este `PodDisruptionBudget`, dirémoslle ao sistema que queremos un mínimo de 5 `pod` coa etiqueta `app: nginx`.
Se enumeramos o `PodDisruptionBudget`, comprobaremos se atopou os `pod` comprobando se o campo ALLOWED DISRUPTIONS non é cero
```shell
kubectl get pdb
NAME     MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
my-pdb   5               N/A               1                     104s
```
Se queremos información máis precisa sobre o `PodDisruptionBudget` podemos acadala cun `describe`
```shell
kubectl describe pdb my-pdb                               
Name:           my-pdb
Namespace:      default
Min available:  5
Selector:       app=nginx
Status:
    Allowed disruptions:  1
    Current:              6
    Desired:              5
    Total:                6
Events:                   <none>
```
Vemos como en `current` lista os 6 `pod` que temos actualmente despregados e cumpren as condicións do `PodDisruptionBudget`. En `desired` vemos as replicas mínimas que debe manter dispoñibles.
¿Cómo podemos provocar que actúe o noso `PodDisruptionBudget`? Ben, provocando unha interrupción voluntaria.

Tamén debemos lembrar que non todas as interrupcións voluntarias están restrinxidas polo `PodDisruptionBudget`. De feito, para comprobar isto podemos eliminar un dos nodos con `kubectl delete node <node-name>`
```shell
kubectl delete node cluster-test-pdb-worker3
node "cluster-test-pdb-worker3" deleted
```
Se enumeramos os `pod` vemos como a perda do nodo worker3 provocou que os 2 `pod` que alí estaban despregados, e prestando atención ao número de réplicas impostos polo `deployment`, agora se despregaron nos nodos worker1 e worker2.
```shell
kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE                       NOMINATED NODE   READINESS GATES
nginx-deployment-7769f8f85b-45v8n   1/1     Running   0          18h   10.244.1.3   cluster-test-pdb-worker    <none>           <none>
nginx-deployment-7769f8f85b-59wlh   1/1     Running   0          18s   10.244.2.4   cluster-test-pdb-worker2   <none>           <none>
nginx-deployment-7769f8f85b-8rfk2   1/1     Running   0          18h   10.244.1.2   cluster-test-pdb-worker    <none>           <none>
nginx-deployment-7769f8f85b-9zf2h   1/1     Running   0          18h   10.244.2.2   cluster-test-pdb-worker2   <none>           <none>
nginx-deployment-7769f8f85b-cz9db   1/1     Running   0          18h   10.244.2.3   cluster-test-pdb-worker2   <none>           <none>
nginx-deployment-7769f8f85b-tjn6d   1/1     Running   0          18s   10.244.1.4   cluster-test-pdb-worker    <none>           <none>
```
Agora temos 3 `pod` en worker e outros 3 en worker2
¿E o noso `PodDisruptionBudget`? Ben, nunca chegou a activarse e polo tanto non mantivemos a dispoñibilidade desexada.

Podemos usar `kubectl drain` para expulsar de forma segura todos os `pod` dun nodo. Os desafiuzamentos seguros permiten que os contedores do `pod` rematen ben e respectarán as condicións que especificaches no `PodDisruptionBudget`.
```shell
kubectl drain --ignore-daemonsets cluster-test-pdb-worker2                                                                                                                            1 ↵
node/cluster-test-pdb-worker2 cordoned
Warning: ignoring DaemonSet-managed Pods: kube-system/kindnet-26qr6, kube-system/kube-proxy-xxzds
evicting pod default/nginx-deployment-7769f8f85b-cz9db
evicting pod default/nginx-deployment-7769f8f85b-9zf2h
evicting pod default/nginx-deployment-7769f8f85b-59wlh
error when evicting pods/"nginx-deployment-7769f8f85b-cz9db" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
error when evicting pods/"nginx-deployment-7769f8f85b-9zf2h" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
pod/nginx-deployment-7769f8f85b-59wlh evicted
evicting pod default/nginx-deployment-7769f8f85b-cz9db
evicting pod default/nginx-deployment-7769f8f85b-9zf2h
error when evicting pods/"nginx-deployment-7769f8f85b-9zf2h" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
pod/nginx-deployment-7769f8f85b-cz9db evicted
evicting pod default/nginx-deployment-7769f8f85b-9zf2h
pod/nginx-deployment-7769f8f85b-9zf2h evicted
node/cluster-test-pdb-worker2 drained
```
Vemos como ao drenar o nodo worker2 inténtanse desafiuzar os 3 `pod`.
O primeiro de eles faino sen problema porque pasamos de 6 a 5 `pod` disponibles.
Os outros dos dan un error porque violaría as condicións do noso `PodDisruptionBudget` que dice que non pode haber nunca menos de 5 `pod` disponibles.
E así volve a intentalo cada 5 segundos hasta que poida desafiuzalos todos.
```shell
kubectl get nodes
NAME                             STATUS                     ROLES           AGE   VERSION
cluster-test-pdb-control-plane   Ready                      control-plane   19h   v1.31.0
cluster-test-pdb-worker          Ready                      <none>          19h   v1.31.0
cluster-test-pdb-worker2         Ready,SchedulingDisabled   <none>          19h   v1.31.0
```
O nodo está acordoado
```shell
kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE                      NOMINATED NODE   READINESS GATES
nginx-deployment-7769f8f85b-45v8n   1/1     Running   0          19h   10.244.1.3   cluster-test-pdb-worker   <none>           <none>
nginx-deployment-7769f8f85b-6fhkh   1/1     Running   0          21m   10.244.1.7   cluster-test-pdb-worker   <none>           <none>
nginx-deployment-7769f8f85b-8rfk2   1/1     Running   0          19h   10.244.1.2   cluster-test-pdb-worker   <none>           <none>
nginx-deployment-7769f8f85b-d88n4   1/1     Running   0          21m   10.244.1.6   cluster-test-pdb-worker   <none>           <none>
nginx-deployment-7769f8f85b-rhsj7   1/1     Running   0          21m   10.244.1.5   cluster-test-pdb-worker   <none>           <none>
nginx-deployment-7769f8f85b-tjn6d   1/1     Running   0          69m   10.244.1.4   cluster-test-pdb-worker   <none>           <none>
```
Agora os `pod` están todos despregados no nodo worker e conseguímolo sen perder a nosa dispoñibilidade desexada gracias ao `PodDisruptionBudget`
Se queremos desacordoar o noso nodo e que volva a recibir asignacións de `pod` debemos executar `kubectl uncordon`
```shell
kubectl uncordon cluster-test-pdb-worker2
node/cluster-test-pdb-worker2 uncordoned
```
```shell
kubectl get nodes                        
NAME                             STATUS   ROLES           AGE   VERSION
cluster-test-pdb-control-plane   Ready    control-plane   19h   v1.31.0
cluster-test-pdb-worker          Ready    <none>          19h   v1.31.0
cluster-test-pdb-worker2         Ready    <none>          19h   v1.31.0
```

