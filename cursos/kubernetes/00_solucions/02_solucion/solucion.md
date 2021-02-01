# Ejercicio Kubernetes 2

[link](https://prefapp.github.io/formacion/cursos/kubernetes/#/./00_actividades/02_modulo_2?id=correndo-a-nosa-primeira-aplicación-en-kubernetes) al ejercicio.


COMANDOS EJECUCION
- microk8s kubectl apply -f despregue-practica-1.yaml 

- microk8s kubectl apply -f servicio-despregue-practica-1.yaml 

- microk8s kubectl get service -o wide

- microk8s kubectl exec test-curl -ti sh
  -	/home # curl 10.152.183.146:8080  (ip do servicio que enseña o comando anterior)

- microk8s kubectl apply -f despregue-frontend-practica-1.yaml 
- microk8s kubectl apply -f servicio-despregue-frontend-practica-1.yaml 

- microk8s kubectl port-forward --address 0.0.0.0 service/servizo-frontend-practica-1 3141:8080
- (outra terminal ou navegador) curl localhost:3141