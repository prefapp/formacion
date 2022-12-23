# Montar nuestra aplicación en un clúster de Kubernetes.
[link]( https://prefapp.github.io/formacion/cursos/kubernetes/#/./00_actividades/03_modulo_3?id=a-creando-a-nosa-infraestrutura) al ejercicio, en este caso sería el apartado "Mejorando nuestra aplicación".

**<u>Punto A:</u>**
En este caso solo tenemos que hacer los comandos que se nos indiquen.

```mkdir ~/bin
curl -s -L -o ~/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o ~/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x ~/bin/{cfssl,cfssljson}
export PATH=$PATH:~/bin

echo '{"CN":"<r_castrelo>","hosts":[""],"key":{"algo":"rsa","size":2048}}' \
| cfssl genkey  - | cfssljson -bare r.castrelo

# obtendremos dos archivos
ls

r.castrelo.csr r.castrelo-key.pem

```
**<u>Punto B:</u>**
(los archivos están en la carpeta donde se encuentra esta solución con los nombres namespace.yaml, role.yaml y role_binding.yaml.

**<u>Punto C:</u>**
Esto sería el envío de archivos a la persona que lo está revisando.

**<u>Punto D:</u>**
En este caso nos dan acceso a la consola de google, por lo que el certificado no fallaría, para obtener la configuración bastaría con ejecutar el siguiente comando:
```
gcloud container clusters get-credentials my-first-cluster-1 --zone europe-west1-b --project formacion-303709
```

**<u>Punto E:</u>**
Para no pisar a nuestros compañeros, creamos un contexto diferente, en este caso r-castrelo aunque la unidad nos dice context-platega:

```
kubectl create namespace r-castrelo
kubectl config set-context --current --namespace=r-castrelo
```

Y lanzamos lo que nos dicen de la tarea c:
```
kubectl apply -f config_practica_2.yaml
kubectl apply -f despregue_practica_2.yaml 
kubectl apply -f servizo_practica_2.yaml
```


