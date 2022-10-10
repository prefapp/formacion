#Xeración de certificado

Para xerar un certificado imos empregar [cfssl](https://cfssl.org/).

```shell
# Baixamos o software

mkdir ~/bin
curl -s -L -o ~/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o ~/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x ~/bin/{cfssl,cfssljson}
export PATH=$PATH:~/bin
```

 Imos empregar un json para xerar o certificado, nunha ruta:
```shell
echo '{"CN":"<inicial_nome.apelido>","hosts":[""],"key":{"algo":"rsa","size":2048}}' \
| cfssl genkey  - | cfssljson -bare <inicial_nome.apelido>

# obteremos dous ficheiros
ls

<inicial_nome.apelido>.csr <inicial_nome.apelido>-key.pem
```
