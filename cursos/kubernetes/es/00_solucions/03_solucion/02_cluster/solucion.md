# Montar a nosa aplicación nun clúster de Kubernetes.
[link]( https://prefapp.github.io/formacion/cursos/kubernetes/#/./00_actividades/03_modulo_3?id=a-creando-a-nosa-infraestrutura) al ejercicio, neste caso seria o apartado "Mellorando a nosa aplicación."

**<u>Punto A:</u>**
Neste caso so temos que facer os comandos que nos indican.

```mkdir ~/bin
curl -s -L -o ~/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o ~/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x ~/bin/{cfssl,cfssljson}
export PATH=$PATH:~/bin

echo '{"CN":"<r_castrelo>","hosts":[""],"key":{"algo":"rsa","size":2048}}' \
| cfssl genkey  - | cfssljson -bare r.castrelo

# obteremos dous ficheiros
ls

r.castrelo.csr r.castrelo-key.pem

```
**<u>Punto B:</u>**
(os arquivos estan na carpeta onde esta esta solución cos nomes namespace.yaml, role.yaml e role_binding.yaml.

**<u>Punto C:</u>**
Esto seria o envío de arquivos a persoa que o esta a revisar. 

**<u>Punto D:</u>**
Neste caso dannos accesoa  consola de google, polo que non faria falla o certificado, para obter a configuración chegaria con executar o seguinte comando:

```
gcloud container clusters get-credentials my-first-cluster-1 --zone europe-west1-b --project formacion-303709
```

**<u>Punto E:</u>**
Para evitar pisar a los compañeros, creamos un contexto diferente, neste caso r-castrelo ainda que a unidade indicanos contexto-platega:

```
kubectl create namespace r-castrelo
kubectl config set-context --current --namespace=r-castrelo
```

E lanzamos o que nos indican da tarefa c:
```
kubectl apply -f config_practica_2.yaml
kubectl apply -f despregue_practica_2.yaml 
kubectl apply -f servizo_practica_2.yaml
```


