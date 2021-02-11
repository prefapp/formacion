# Servizos en detalle

> # Este capítulo atópase en estado WIP

Imos  despregar o seguinte deploy e expoñelo empregando diferentes servizos para ver as diferencias entre cada *service kind* : 
```yaml
#deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: despregue-web
spec:
  selector:
    matchLabels:
      app: pod-web
  replicas: 5 
  template:
    metadata:
      labels:
        app: pod-web
    spec:
      containers:
      - name: pod-web
        image: frmadem/catro-eixos-k8s-ej1:v1
        env:
          - name: PUERTO_APP
            value: "80"
        command: ["npm", "run", "iniciar"]
        ports:
          - containerPort: 80
```

Non é mais que un servidor web que mostra unha pequena mensaxe co nome do servidor e a máquina que sirve os datos.

Se facemos un apply do noso `deploy.yaml`. Teremos 5 pods correndo o servidor web.

Para expoñer o noso deploy imos empregar primeiramente un servicio de tipo `ClusterIp` que é o tipo por defecto nos *services* de kubernetes:
```yaml
# clusterip-service.yaml
kind: Service
apiVersion: v1
metadata:  # esta é a parte de identificación do servizo
  name: servizo-clusterip
spec:
  selector:   # esta é a parte de selección
    app: pod-web
  ports:  # esta é a parte de especificación propia
  - port: 80
    targetPort: 80
```

Se facemos un curl desde dentro veremos que van rotando os pods que devolvena peticion, sin embargo si facemos un port-forward do noso servizo para acceder desde o exterior podemos comprobar que sempre nos devolve o mesmo pod.

** IMAXE DUN CURL INTERNO
** IMAXE DUN PORT-FORWARD

Sin embargo si utilizamos un servizo do tipo `Nodeport`:
```yaml
# nodeport-service.yaml
kind: Service
apiVersion: v1
metadata:  
  name: servizo-nodeport
spec:
  type: NodePort # tipo de servizo
  selector:   
    app: pod-web
  ports:  
  - port: 80
    targetPort: 80
    nodePort: 31415   
```
Podemos expoñer a IP dun dos nodos do cluster que nos conectará a traves do porto `nodePort`co noso servizo.
 
** IMAXE OBTENDO A IP DO NODO E O PORTO DO SERVIZO
** IMAXE DO SERVICIO ROTANDO OS PODS

Esta opcion ten varios problemas:
- Solo podes ter un servizo por porto
- Solo se poden empregar os portos 30000–32767
- Debemos ter un mecanismo de axuste por se cambia a IP do nodo 

Aparece enton un servizo máis avanzado para solventar o noso problema:
```yaml
# loadbalancer-service.yaml
kind: Service
apiVersion: v1
metadata:  # esta é a parte de identificación do servizo
  name: servizo-loadbalancer
spec:
  type: LoadBalancer
  selector:  # esta é a parte de selección
    app: pod-web
  ports:  # esta é a parte de especificación propia
  - port: 6000
    targetPort: 80
```
Para empregar este servicio necesitas un proveedor de Kubernetes, pois o seu despregue proporcionache unha IP externa desde a que acceder ao teu servizo.

Se desexa expoñer directamente un servizo, este é o método predeterminado. Todo o tráfico do porto que especifique será reenviado ao servizo. Non hai filtrado, nin enrutamento, etc. Isto significa que pode enviarche case calquera tipo de tráfico, como HTTP, TCP, UDP, Websockets, gRPC ou calquera outra cousa.
A gran desvantaxe é que cada servizo que expón cun LoadBalancer recibirá o seu propio enderezo IP e terá que pagar un LoadBalancer por un servizo exposto, o que pode resultar caro.

Se estas a empregar tráfico HTTP, un Ingress permitirache facer routing por path e subdominio, como veremos no seguinte capítulo do tema.
