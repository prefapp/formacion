# Adaptándose ás demandas de carga: O HPA

Unha das vantaxes importantes que ofrece Kubernetes é a de permitir adaptar as capacidades de computación dos nosos servizos ás demandas e cargas de traballo solicitadas para os usuarios. Unha das medidas fundamentais para iso é o [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/): o Horizontal Pod Autoescaler. 

Trátase dun mecanismo que incorpora K8s que vai permitir que os nosos deployments aumenten o seu número de réplicas segundo unha serie de parámetros que nós podemos definir.

![hpa1](./../_media/03/hpa_1.png)

Como vemos no diagrama, un aumento da carga de traballo, leva parello un aumento do número de pods para absorbela. Consecuentemente, cando esa carga se reduce, tamén o fará o número de pods. Deste xeito, **podemos adaptarnos ás variacións da carga de traballo mediante o número de pods que a procesan**.


De ahí o nome de horizontal: non incrementamos os recursos asignados a un pod concreto, aumentamos o número de pods dese tipo puidendo superar as limitacións dun nodo de k8s e as propias dunha unidad simple de execución. 

## Xestionando a carga co HPA


O HPA constitúe un artefacto independente de kubernetes: pódemolo expresar nun arquivo de YAML e vai ter unhas especificacións. 

Conéctase directamente o ReplicaSet que implementa o Deployment para incrementar ou decrementar o **número de réplicas**.

Esta arquitectura presenta moitas vantaxes:

* O feito de ser un artefacto independiente permite xestional







