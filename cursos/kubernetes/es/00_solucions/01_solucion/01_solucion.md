# Ejercicio Kubernetes 2

[link](https://prefapp.github.io/formacion/cursos/kubernetes/#/./00_actividades/02_modulo_2?id=corredno-a-nosa-primeira-appliquén-en-kubernetes) al ejercicio.

Cuando implemento Deploy y el servicio, hago un curl en la dirección IP del servicio y no devuelve nada.


Si hago un curl a localhost de la conexión rechazada


Si hago un reenvío funciona perfectamente.


# SOLUCIÓN:

Creo que tienes el targetPort y el puerto al revés. El targetPort sería el puerto del pod donde se inicia el servicio, y el puerto el puerto que expondrá el servicio al exterior, puede ver más información aquí.


Esto debería funcionar para usted:


# servizo_test.yaml

``` yaml
kind: Service
apiVersion: v1
metadata:
  name: servicio-despregue1
spec:
  selector:
    app: practica1
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
```

Lanzamiento de curl desde cualquier pod en el clúster:

```
curl -vv servicio-despregue1.default.svc.cluster.local:8080
```
