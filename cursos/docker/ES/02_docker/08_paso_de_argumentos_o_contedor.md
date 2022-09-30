# Paso de argumentos ó contedor

A estas alturas da lección, xa sabemos que o contedor é unha unidade illada dende o punto de vista dos recursos tradicionalmente compartidos nunha máquina: usuarios, pids, mounts, rede...

Este isolamento é unha das claves da creación de contedores. Nembargantes, a veces compre poder controlar dalgún xeito os procesos que corren dentro do contedor. Isto, é: controlar os programas mediante o paso de parámetros. 

Existen duas formas principais de paso de parámetros a un contedor:

- Mediante os argumentos que lle chegan ó programa que lanzamos mediante docker-run ou docker-create.
- Asignando ou mudando os valores que reciben as variables de entorno dentro do contedor. 
Imos centrarnos na segunda das posibilidades nesta sección. 

## Control das variables de entorno dun contedor

Antes de correr un contedor, Docker permite establecer cal será o valor do seu entorno mediante o paso de binomios clave=valor. 

Deste xeito, se temos unha aplicación que precisa un login/password de administrador e que os recolle de variables de entorno, por exemplo (ROOT_LOGIN, ROOT_PASSWORD), poderíamos facer o seguinte:

```shell
docker run -d -e ROOT_LOGIN=admin -e ROOT_PASSWORD=segredo imaxe-de-app-con-admin
```

Neste exemplo:

- Créase e lanzase un container en modo daemon (_**run -d**_)
- Cunha imaxe ficticia (_**imaxe-de-app-con-admin**_)
- Establécese que se cree ou mude (_**-e**_) o valor dunha variable de entorno (**ROOT_LOGIN** con valor admin)
- O mesmo (_**-e**_) para a variable **ROOT_PASSWORD** (valor segredo)
Docker, vai inxectar estas variables dentro do contedor antes de arrincalo de xeito que, se o programa está preparado para facelo, pode recolle-la súa configuración do ENV.

![Container contorno](./../_media/02_docker/contedor_contorno.png)

> ⚠️ Obviamente, se queremos mudar o valor das variables de entorno dun contedor en funcionamento, compre reinicialo o recrealo.
