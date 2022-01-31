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

apiVersion: autoscaling/v2 # hai varias versións en funcionamento a día de hoxe
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
    name: cpu
    target:
      type: Utilization
      averageUtilization: 50  

```

Como podemos comprobar un HPA ten tres seccións fundamentais nas súas especificacións:

1. Unha sección de **Selección**
2. Unha sección de **Límites**
3. Unha sección de **Criterios ou Métricas**










