# Ejercicio Kubernetes 2

[link](https://formacion.4eixos.com/k8s/actividades/2/correndo_a_nosa_primeira_aplicacin_en_kubernetes.html) al ejercicio.

Despues de hacer un apply de todos los archivos hago un curl al servicio que se encarga del frontend dende dentro dun pod dame connection refused.
Se o fago o outro servizo funciona perfectamente.

```
curl -vv servicio-despregue-frontend-practica-1.default.svc.cluster.local:8080
```
