# ¿Cómo se ha construido está release?

Siguiendo el tutorial de [formación de Helm](https://prefapp.github.io/formacion/cursos/helm/#/) desde la plantilla de release creada en la [actividad 1](../actividade-1-charts-helm/) se han añadido [valores y su interpolación](https://prefapp.github.io/formacion/cursos/helm/#/./02_helm_charts/01_valores_y_su_interpolacion). 

Después se ha añadido el repo del microframework de [Prefapp Helm](https://github.com/prefapp/prefapp-helm) para implementar Charts modulares.

```shell
helm repo add prefapp-helm https://prefapp.github.io/prefapp-helm
helm repo update
```

Y se ha incluído la dependencia en el fichero Chart.yaml.

```yaml
# Chart.yaml

...
dependencies:
  # ... your other dependencies
  - name: prefapp-helm
    version: <your desired version>
    repository: https://prefapp.github.io/prefapp-helm
...
```
