# Artefactos en Kubernetes: o Pod

Para ser quen despregar e controlar as aplicacións en Kubernetes, póñense á disposición dos usuarios unha serie de elementos básicos que actúan de bloques de construcción mediante os cales pódese expresar unha topoloxía e estrutura moi flexible que se axuste ás necesidades de cada caso.  

O que segue é unha descrición dos principais elementos e da súa relación co resto do sistema.

## Pod

Un [pod](https://kubernetes.io/docs/concepts/workloads/pods/) é o elemento mínimo ou atómico dentro de Kubernetes.

Non podemos pensar nun pod coma nun contedor: o pod consiste en 1..n contedores **agrupados lóxicamente pola súa función.** 

Deste xeito, os contedores despregados dentro dun pod:

- Irán sempre despregados de forma conxunta nun só nodo ou servidor. 
- Comparten a configuración de rede.
- Comparten os volumes e o almacenamento. 

![Pod](./../_media/02/pod1.png)

Nun pod imos agrupar todos aqueles procesos (aillados en contedores) que teñan que traballar "ó carón dos outros": 

- poderán falar a través de localhost post 
- constitúen unha unidade de despregue polo que facilitan o escalado horizontal da aplicación. 
- poden compartir volumes que "sobreviven" ós reinicios  e ós que teñen acceso o resto dos procesos. 

### a) Definición do pod

Para definir un pod, Kubernetes pon á nosa disposición unha linguaxe potente e descritiva que emprega YAML coma sintaxe básica. 

No pod de exemplo que imos a crear:

- Só teremos un contedor que monta unha imaxe de ubuntu
- O contedor dentro do pod, realmente non fai nada, só espera

Nun ficheiro en branco introducimos o seguinte:

```yaml
# pod_1.yaml

kind: Pod # o artefacto é un Pod
apiVersion: v1  # a versión da api a empregar
metadata:
  name: primeiro-pod  # o nome do pod
spec:
  containers:
    - name: contedor  # o nome do contedor dentro do pod
      image: ubuntu
      command: ["/usr/bin/tail", "-f", "/dev/null"]
  restartPolicy: Never
```

Como podemos ver empregamos unha linguaxe declarativa para expresar o que queremos, agora, basta empregar a ferramenta kubectl para facer que este pod "apareza" na nosa instalación de Kubernetes. 

```shell
kubectl apply -f pod_1.yaml
```

A ferramenta kubectl comunícase coa api que se atopa no máster e unha nova estrutura dáse de alta. O sistema comproba que non hai tal pod dentro dos nodos e marca o pod como "necesita crearse". O scheduler elixe un nodo onde correr o pod e este iníciase a través do Kubelet. 

Se corremos este comando

```shell
kubectl get pods
```

Veremos a seguinte saída

```shell
primeiro-pod   0/1     Pending       0          0s
primeiro-pod   0/1     ContainerCreating   0          0s
primeiro-pod   1/1     Running             0          2s
```

O pod está a correr "nalgures" dentro do noso clúster.

Onde? en realidade non nos importa; e ese é precisamente un dos puntos clave de Kubernetes: facer transparente ó usuario a complexidade do clúster e crear unha "vista" do mesmo como se de unha soa máquina se tratase. 

### b) Interactuar co pod

Como viramos na sección anterior, Kubernetes emprega unha linguaxe declarativa que permite expresar un "deber ser". Despois, mediante a ferramenta kubectl podemos cargar ese "deber ser" no sistema que o aplicará para convertilo nunha realidade dentro do clúster. 

Xa vimos como listar os pods na sección anterior. 

Se quixeramos ter máis detalles do noso pod, poderíamos facer:

```shell
kubectl describe pod/primeiro-pod
```

E obteríamos unha morea de datos:

```shell
Name:               primeiro-pod
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               sutelinco/10.0.2.15
Start Time:         Thu, 11 Apr 2019 23:53:23 +0000
Labels:             <none>
Annotations:        kubectl.kubernetes.io/last-applied-configuration:
                      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"primeiro-pod","namespace":"default"},"spec":{"containers":[{"command"...
Status:             Running
IP:                 10.1.1.10
Containers:
  contedor:
    Container ID:  containerd://d5648ba53e23fd45e85f3ee52942694ea8ac51d98eaee453c0189d1fdc17935d
    Image:         ubuntu
    Image ID:      docker.io/library/ubuntu@sha256:017eef0b616011647b269b5c65826e2e2ebddbe5d1f8c1e56b3599fb14fabec8
    Port:          <none>
    Host Port:     <none>
    Command:
      /usr/bin/tail
      -f
      /dev/null
    State:          Running
      Started:      Thu, 11 Apr 2019 23:53:25 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-g42tp (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-g42tp:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-g42tp
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                Message
  ----    ------     ----  ----                -------
  Normal  Scheduled  15m   default-scheduler   Successfully assigned default/primeiro-pod to sutelinco
  Normal  Pulling    15m   kubelet, sutelinco  Pulling image "ubuntu"
  Normal  Pulled     15m   kubelet, sutelinco  Successfully pulled image "ubuntu"
  Normal  Created    15m   kubelet, sutelinco  Created container contedor
  Normal  Started    15m   kubelet, sutelinco  Started container contedor
```

Se quixeramos "entrar" no pod, podemos empregar exec:

```shell
# indicamos o pod e o contedor no que queremos "ingresar"
kubectl exec -ti primeiro-pod -c contedor -- bash
```

Nótese que a sintaxe do comando é moi parecida ó [exec de Docker](https://docs.docker.com/engine/reference/commandline/exec/). 

Unha vez executada, teríamos unha shell dentro do contedor e poderíamos interactuar co sistema de ubuntu que monta como imaxe. 

Para borralo, simplemente pasamos o noso ficheiro de yaml ó sistema:

```shell
kubectl delete -f pod_1.yaml
```

### c) Establecer variables de contorno no pod

Para aqueles familiarizados cos contedores de software non é descoñecido o feito de que a maior parte da configuración inxectase a través de variables de contorna para poder controlar o programa dende "fora". 

Kubernetes ten xeitos avanzados de crear variables de contorna, segredos, etc... 

Nembargantes, para o alcance módulo válenos a forma básica de establecer o entorno. 

Na sección de containers, en cada contedor pódese establecer unha entrada env, para introducir valores:

```yaml
kind: Pod # o artefacto é un Pod
apiVersion: v1  # a versión da api a empregar
metadata:
  name: primeiro-pod  # o nome do pod
spec:
  containers:
    - name: contedor  # o nome do contedor dentro do pod
      image: ubuntu:18.04
      command: ["/usr/bin/tail", "-f", "/dev/null"]
      env:
        - name: VAR   # estamos a establecer VAR=1 no env
          value: foo
        # poderíamos definir as variables de contorna que queramos
  restartPolicy: Never
```

En módulos posteriores veremos xeitos moito máis avanzados de controlar a contorna de execución dun pod e de incluir segredos e outras configuracións.









