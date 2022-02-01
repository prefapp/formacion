# Adaptándose ás demandas de carga: O HPA

Unha das vantaxes importantes que ofrece Kubernetes é a de permitir adaptar as capacidades de computación dos nosos servizos ás demandas e cargas de traballo solicitadas para os usuarios. Unha das medidas fundamentais para iso é o [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/): o Horizontal Pod Autoescaler. 

Trátase dun mecanismo que incorpora K8s que vai permitir que os nosos deployments aumenten o seu número de réplicas segundo unha serie de parámetros que nós podemos definir.

![hpa1](./../_media/03/hpa_1.png)

Como vemos no diagrama, un aumento da carga de traballo, leva parello un aumento do número de pods para absorbela. Consecuentemente, cando esa carga se reduce, tamén o fará o número de pods. Deste xeito, **podemos adaptarnos ás variacións da carga de traballo mediante o número de pods que a procesan**.


De ahí o nome de horizontal: non incrementamos os recursos asignados a un pod concreto, aumentamos o número de pods dese tipo puidendo superar as limitacións dun nodo de k8s e as propias dunha unidad simple de execución. 

## Xestionando a carga co HPA


O HPA constitúe un artefacto independente de kubernetes: pódemolo expresar nun arquivo de YAML e vai ter unhas especificacións. 

Conéctase directamente o ReplicaSet que implementa o Deployment para incrementar ou decrementar o **número de réplicas**.

Esta arquitectura presenta importantes vantaxes:

* O feito de ser un artefacto independiente permite a súa xestión como os demáis elementos da maquinaria de k8s. 
* Pódese despregar/modificar/borrar de xeito independente ó resto da definición dos nosos servizos. 

Polo tanto, a definición dun HPA, implica a creación dun novo artefacto de kubernetes:

```yaml

# Definición completa en: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#horizontalpodautoscaler-v2beta2-autoscaling

apiVersion: autoscaling/v2beta2 # hai varias versións en funcionamento a día de hoxe
kind: HorizontalPodAutoscaler

metadata:
  name: o-meu-hpa  
  # podería levar as súas annotations e labels

spec: 

  #-------------------------------------------------
  # Esta é a parte de selección de pods a escalar
  #-------------------------------------------------
  scaleTargetRef: 
    kind: Deployment
    name: o-meu-deployment


  #-------------------------------------------------
  # Nesta parte establecemos os límites do escalado
  #-------------------------------------------------
  minReplicas: 1
  maxReplicas: 10

  
  #---------------------------------------------------
  # Nesta sección definimos os criterios (métricas)
  # segundo as que escalar
  #---------------------------------------------------
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50  

```

Como podemos comprobar un HPA ten tres seccións fundamentais nas súas especificacións:

1. Unha sección de **Selección**
2. Unha sección de **Límites**
3. Unha sección de **Criterios ou Métricas**

### O emprego de métricas no HPA

As métricas nas que o noso HPA pode basear o seu traballo son de [tres tipos fundamentais](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-metrics-apis):

1. Tipo Recurso (Fundamentalmente CPU/memoria) que podense expoñer normalmente a través do [metrics-server](https://github.com/kubernetes-sigs/metrics-server).
2. Tipo Custom, que toman valores de servicios de métricas aportados polo vendor (Cloud Monitoring, Cloud Watch...) Serven para que os pods poidan escalar segundo métricas distintas das súas propias. 
3. Tipo External: para escalar os nosos pods segundo o estado se servizos externos ó noso (por exemplo unha cola de mensaxes)

Estos tres grupos de métricas expóñense a través de APIs específicas:

1. Para métricas de tipo Recurso: metrics.k8s.io. 
2. Para métricas de tipo Custom: custom.metrics.k8s.io. 
3. Para métricas de tipo Externo: external.metrics.k8s.io. 

Polo tanto, e segundo o resultado desexado, basearemos o noso HPA nun tipo de métricas ou outras. 

### A interpretación das métricas por parte do HPA

O algoritmo que emprega o HPA para interpretar as métricas funciona segundo o que está explicado nesta [sección da documentación oficial](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details). 

A idea básica é a de determinar o número de replicas mediante unha sinxela operación matemática:

```

Número de Rèplicas de Pods = Redondeo (valorActualMetrica / valorIdealMetrica )

```

Isto quere decir que:

1. O algoritmo calcula o valor actual da métrica (se é unha porcentaxe fai a media de ese valor entre tódolos pods existentes)
  1.a Se a métrica e de tipo **resource** (CPU ou Memoria) o valor individual de cada pod áchase partindo da utilización actual con respecto ós requests especificados no pod. 
2. Toma o valor ideal (tal e como está declarado no manifesto do artefacto)
3. O producto do número actual de réplicas polo cociente entre a métrica actual e a ideal resultará no número de réplicas a manter. 

En exemplos:

* Utilización de cpu 400, ideal 100 implica un incremento do pods = 400 / 100 == 4.0
* Ítems en cola 500, ideal de 300, implica un incremento de pods = 500 / 300 = 2.0 (1.6 redondeado) 

#### O problema do emprego de memoria como criterio de escalado/desescalado co HPA

A memoria pódese empregar como métrica nun HPA, sen embargo resulta problemática:

1. Moitas linguaxes de programación e runtimes liberan a memoria mou pouco a pouco (ou non liberan, directamente)
2. A utilización de memoria non é en moitos casos unha medida do nivel de "carga" dun proceso por culpa das reservas que fan algúns frameworks ó iniciarse.

Por estas razóns non asemella aconsellable na maioría dos casos empregar a memoria como criterio de escalado / desescalado de pods. 

### A sección behavior: a xestión "polo míudo" do noso HPA. 














