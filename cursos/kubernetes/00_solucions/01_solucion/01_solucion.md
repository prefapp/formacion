# Ejercicio Kubernetes 2

[link](https://prefapp.github.io/formacion/cursos/kubernetes/#/./00_actividades/02_modulo_2?id=correndo-a-nosa-primeira-aplicación-en-kubernetes) al ejercicio.

Cuando despliego el Deploy y el servicio hago un curl a la direccion ip del serivicio y no devuelve nada.


Si hago un curl a localhost da connection refused


Si hago un forward funciona perfectamente.


# SOLUCION:

Penso que tes ao reves o targetPort e o port. O targetPort sería o porto do pod donde está arrancado o servicio, e o porte o porto que vai a expoñer o servicio ao exterior, podes ver máis info aquí.


Con esto debería funcionarche:


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

Lanzando o curl dende calquer pod do cluster:

```
curl -vv servicio-despregue1.default.svc.cluster.local:8080
```
