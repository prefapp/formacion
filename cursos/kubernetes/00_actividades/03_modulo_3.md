##  Módulo 3: Vogando por augas procelosas: Kubernetes avanzado
# Mellorando a nosa aplicación.

Para facer esta tarefa, primeiro compre ler a documentación sobre "[avanzando en Kubernetes](https://prefapp.github.io/formacion/cursos/kubernetes/#/./03_configuracion/01_Configuracions_en_Kubernetes)".

Imos mellorar o noso despregue de aplicación da tarefa [2.3](https://prefapp.github.io/formacion/cursos/kubernetes/#/./00_actividades/02_modulo_2?id=correndo-a-nosa-primeira-aplicación-en-kubernetes).

Polo tanto, é necesario ter rematada esa tarefa antes de acometer a de este módulo.

### a) Mellorando o noso pod

Unha vez lida a documentación, sacamos en conclusión que unha das melloras que podemos facer ós nosos pods é a de dotalos de sondas que nos permitan determinar:
* Cando está listo para recibir peticións (readinessProbe).
* O seu estado de "saúde" (livenessProbe).

Asemade, e para que o scheduler (o compoñente de K8s encargado de determinar o nodo do clúster no que van a correr os nosos pods) faga ben o seu traballo, compre introducir limits e requests.

Compre modificar o pod da tarefa 2.3 a) cos seguintes cambios:
* Mudarlle o nome ó pod, chamarase "pod-practica-2".
* Hay que lle meter a [política](https://kubernetes.io/docs/concepts/containers/images/) de "ImagePullPolicy: Always".
* Agregarlle unha sonda de ready e unha de live:
	* Faránse a través de peticións get a /servidor.
	* A sonda de ready iniciaráse ós 15 seg de vida do contedor e se repetirá ata cada 5 seg.
	* A sonda de live iniciarase ós 20 seg e se repetirá cada 10 seg.
* Por outra banda, imos crear uns limits e requests ós nosos pods:
	* Como limits, haberá 64Mi e 200m.
	* Como requests, teremos 48Mi e 150m.
* Por último imos cambiar a política de pullIimage e obligar a que Kubernetes intente buscar cambios na imaxe do pod cada vez que se arrinca ([imagePullPolicy](https://kubernetes.io/docs/concepts/containers/images/)).

Con todos istos cambios, hai que xerar un novo yaml que cumpra os requisitos do da tarefa 2.3.a) mais estes novos (o yaml chamaráse pod_mellorado.yaml).

Compre tamen arrancalo. 

Unha vez feito teríamos o seguinte:

![tpod1.png](../_media/03/tpod1.png)

### b) Agregando persistencia

Resulta que a nosa aplicación tiña logs!!

Eses logs de acceso estánse a perder por mor de que os nosos pods non teñen persistencia.

Imos darlle persistencia ó noso sistema:
* Borra o pod do apartado anterior.
* Baseándote en el, crea un novo ficheiro que se chame "pod_mellorado_volume.yaml".
* No pod hai que facer os seguintes cambios:
	* Agregar unha nova variable de contorna que estableza os logs RUTA_LOGS=/var/log (os teremos así en /var/log/k8s_access.log).
	* Compre tamén crear un volume:
		* Será de tipo __hostPath__.
		* Ten que apuntar a __/tmp/k8s_logs__.
		* Ten que chamarse __volume-logs__.

Cando o teñas listo:
* Arranca o pod.
* Comproba que na ruta __/tmp/k8s_logs__ hai un log __k8s_access.log__.
* Fai un port-forward do pod.
* Faille peticións a __/servidor__.
* Mostra o contido do log con un tail.

O sistema agora, quedaría como segue:

![tpod2.png](../_media/03/tpod2.png)

## C) Engandindo un deploy, un configmap e un servizo

Agora que temos o pod ben preparado, imos a metelo dentro dun deploy que o controle.

* Borra o pod do apartado anterior.
* Compre crear un deploy:
	* O seu nome será "despregue-practica-2".
	* Os pods serán do tipo do apartado anterior (cuidado co selector!!!).
	* Terá como labels:
		* "app=pod-practica-2".
		* "practica=modulo_3_1".
	* Os pods van empregar un ConfigMaps:
		* Terá de nome "config-practica-2".
		* Terá como labels:
			* "app=pod-practica-2".
			* "practica=modulo_3_1".
		* Terá a configuración do:
			* "PUERTO_APP=80".
			* "RUTA_LOGS=/var/log".
	* O despregue expórtase a través dun servizo:
		* terá de nome "servizo-practica-2".
		* as súas labels serán:
			* "app=pod-practica-2".
			* "practica=modulo_3_1".
		* Escoitará no porto 80 (port = 80).

Polo tanto, precisamos de tres artefactos:
* Deploy (despregue_practica_2.yaml).
* ConfigMap (config_practica_2.yaml).
* Service (servizo_practica_2.yaml).

O diagrama do que temos quedaría como este (non se mostran as sondas e os límites por falta de espazo):

![tpod3.png](../_media/03/tpod3.png)

Unha vez tes todo preparado:

1. Arranca os tres artefactos (pola orde correcta).
2. Comproba que están a funcionar os tres.
3. Averigua a ip do servizo.
4. Escala a 5 réplicas e agarda a que estén ready.
5. Fai curls ó <ip_servizo>/servidor.
6. Fai un tail do archivo de logs.
7. Borra os tres artefactos mediante o emprego de labels non de names.

---
## Evaluación


**Evidencias da adquición dos desempeños**:
* Envío dun pdf cos contidos necesarios para realizar os puntos do a) ó c) segundo estes.

**Indicadores de logro**: Deberías ter...
* Artefacto co yaml necesario para crear o pod cos requisitos do **punto a)** (pod_mellorado.yaml). Captura de pantalla dos comandos necesarios para:
	* Arrancar o yaml.
	* Comprobar que o pod está a correr (e a súa saída).
* Artefacto co yaml necesario para crear o pod cos requisitos do **punto b)** (pod_mellorado_volume.yaml). Captura de pantalla cos comandos necesarios para:
	* Arrancar o yaml.
	* Exportar o pod a un porto da máquina ou host.
	* Saída do log en /tmp/k8s_logs/k8s_access.log do host.
* 3 artefactos (ConfigMap, Deploy e Service) cos requisitos do **punto c)** (config_practica_2.yaml, despregue_practica_2.yaml e servizo_practica_2.yaml) Captura de pantalla coas salidas e comandos necesarios para:
	* Arrancar a estrutura e comprar que está a funcionar.
	* Escalar o despregue a 5 réplicas.
	* Saída do tail (en host) de "/tmp/k8s_logs/k8s_access.log".
	* Borrado dos artefactos (por labels).

**Criterios de corrección**:
* Ata 10 puntos do apartado a):
	* 8 puntos se o yaml de creación do pod está correcto.
	* 1 puntos por cada comando / captura de saída correcto.
* Ata 10 puntos do apartado b):
	* 7 puntos se o yaml de creación do pod mellorado e con volume está correcto.
	* 1 punto por cada comando/captura de saída correcto.
* Ata 20 puntos do apartado c):
	* 4 puntos se os yaml de deploy, configmap e servizo están correctos.
	* 2 punto por cada comando/captura de saída correcto.

**Autoavaliación**: Autoavalía esta tarefa aplicando os indicadores de logro anteriores.

**Peso na cualificación**:
* Peso desta tarefa na cualificación final ........................................ 40 puntos
* Peso desta tarefa no seu tema ...................................................... 40 %

___

# Montar a nosa aplicación nun clúster de Kubernetes

Imos correr a nosa aplicación nun clúster real de Kubernetes.

Para facer isto compre revisar a documentación [sobre usuarios e roles](https://prefapp.github.io/formacion/cursos/kubernetes/#/./03_configuracion/01_Configuracions_en_Kubernetes).

O administrador do clúster vainos pedir unha serie de elementos:
* Un certificado xerado por nós para poder traballar contra a API do clúster.
* Un artefacto que cree o noso namespace, onde imos traballar:
	* O namespace terá o seguinte formato: "<inicial_nome_pila>-<primer_apelido>".
	* Exemplo: (Francisco Maseda) __f-maseda__.
* Un artefacto que cree un Role:
	* Ten que dar permisos sobre os seguintes recursos:
		* ConfigMaps.
		* Services.
		* Pods.
		* Deploys.
	* Os permisos serán de lectura e escritura (verbos POST, PUT, PATCH, GET, WATCH, LIST).
* Un RoleBinding para linkar o Role ó usuario no namespace noso.

Esos obxectos e o certificado **deberán ir nun tar** que remitiremos ó administrador mediante email (para Francisco Maseda ou Javier Gómez).

## A) Xerar as nosas credenciais

Para xerar as nosas credenciais compre seguir esta [guía](https://prefapp.github.io/formacion/cursos/kubernetes/#/./03_configuracion/00_Guia_cert).

Copiamos á nosa ruta de tar o certificado .csr (por exemplo f.maseda.csr).

## B) Crear os artefactos de namespace, Role e RoleBinding

O administrador tamén nos pide que declaremos os artefactos necesarios para crear:
* Namespace:
	* O nome do namespace terá o formato do que falamos enriba.
	* Terá como label: tipo=platega-alumno.
* Role:
	* Terá como nome "role-alumno".
	* Compre que teña o label: "tipo=platega-alumno".
	* Ten que dar permisos sobre os seguintes recursos:
		* Pods.
		* Servizos.
		* Deploys.
		* ConfigMaps.
	* Os permisos serán de lectura-escritura (GET, POST, PUT, WATCH, LIST, PATCH).
* RoleBinding:
	* Tera como nome binding-alumno.
	* Aplicaráse ó usuario nomeado co formato que establecemos ( <inicial_nome_pila>-<primer_apelido>).
	* Compre que teña o label: "tipo=platega-alumno".
	* Será sobre o namespace creado.

Os tres yaml (namespace.yaml, role.yaml, role_binding.yaml) introduciránse no tar a enviar.

## C) Envío ós administradores do clúster

O tar enviarase ó administrador (Francisco Maseda ou Javier Gómez) mediante email. Responderán cun certificado.

## D) Instalación do certificado no microk8s.kubectl

Unha vez obtemos o certificado dos administradores:
* Agregamos unha nova configuración para o clúster.
* Chamaráse "platega".
* O server ten como dirección: "https://35.205.163.207".
* Hai que facer o "insecure-skip-tls-verify=true".
* Agregamos un novo usuario (co nome tal e como o temos no RoleBinding).
* Hai que lle meter o certificado que nos devolveu o administrador (opción --embed-certs=true).
* A key xerada no **apartado a)**.
* Agregamos un novo contexto.
* Co nome "contexto-platega".
* Asociará o clúster "platega" ó noso usuario.

Listamos os contexts que temos. 

## E) Creación do noso despliegue da tarefa 3.1 no clúster

Poñemos o current-context a "contexto-platega".

Lanzamos o configmap, deploy e service do **apartado c)** da tarefa anterior.

Avisamos por mensaxe privada ó administrador de que temos o sistema instalado no clúster.

---
## Evaluación

**Evidencias da adquición dos desempeños**:
* Envío dun tar por email cos contidos necesarios para realizar os puntos do **a)** e **b)** segundo estes.

**Indicadores de logro**: Deberías ter:
* Xerado correctamente un certificado según se indica no apartado a).
* Yaml correctos para:
	* Crear un namespace coas especificacións do apartado b).
	* Crear un Role segundo as especificación do apartado b).
	* Crear un RoleBinding segundos as especificación do apartado b).
* Lanzar a nosa aplicación no clúster (despois de facer os pasos do apartado c) ) e avisar ós administradores por mensaxe privada.

**Criterios de corrección**:
* Ata 20 puntos do apartado a) e b):
	* 5 puntos se o certificado está correcto.
	* 5 puntos se o artefacto de creación do namespace é correcto.
	* 5 puntos se o Role está correcto.
	* 5 puntos se o RoleBinding está correcto.
	* 1 puntos por cada comando / captura de saída correcto.
* Ata 20 puntos do apartado d):
	* 20 puntos se o desplegue, configmaps e o servizo están a correr no clúster.

**Autoavaliación**: Autoavalía esta tarefa aplicando os indicadores de logro anteriores.

Se tes algunha dúbida ou consulta sobre como realizar a tarefa formúlaa no [Foro de consultas](https://www.edu.xunta.gal/platega/mod/forum/view.php?id=110051) deste tema.

**Peso na cualificación**:
* Peso desta tarefa na cualificación final ........................................ 40 puntos
* Peso desta tarefa no seu tema ...................................................... 40 %

----

# Conectando a nosa aplicación con ingress

Para poder facer esta práctica compre:
- Revisar o tema que deixamos neste módulo, sobre todo a sección sobre ingress.
- Compre ter activado o ingress no microk8s. 

Para activar ingress:
`microk8s.enable ingress`

Lembrade que o ingress está conectado ó porto 80. Polo que é necesario ter ese porto libre na máquina virtual para que todo funcione correctamente. Podemos comprobalo facilmente:
![actividades31](./../_media/01/actividades31.png)

Agora que coñecemos [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/), imos empregalo para montar dúas versións da aplicación do curso e redirixir o tráfico segundo a ruta de acceso. 

Deste xeito:
- En /v1 imos ter a versión 1 da nosa aplicación (a que empregamos nas tarefas dos dous módulos anteriores)
- En /v2 imos ter a versión 2 da mesma. 


## a) Creando a nosa infraestrutura
Partiremos do estrutura básica do módulo 2:
 - Imos ter un deploy
   - Empregará a imaxe frmadem/catro-eixos-k8s-ej1
   - A tag será v1
   - O nome do deploy será practica-4-v1
   - Non fan falla nin sondas nin limits
   - O comando a executar e npm run iniciar
   - Estará nun ficheiro deploy_practica_4_v1.yaml
- Exporemos un servizo
  - Conectará cos pods do deploy no porto 8080
  - O seu porto será o 80
  - Terá de nome practica-4-v1
  - Estará nun ficheiro servizo_practica4_v1.yaml
- Teremos outro deploy
  - Empregará a imaxe frmadem/catro-eixos-k8s-ej1
  - A tag será v2
  - O nome do deploy será practica-4-v2
  - Estará nun ficheiro deploy_practica_4_v2.yaml
  - Non fan falla nin sondas nin limits
  - O comando a executar é npm run iniciar
- Teremos outro servizo
  - Conectará cos pods nos porto 8080
  - O seu porto será tamén o 80
  - O seu nome será practica-4-v2
  - Estará nun ficheiro servizo_practica4_v2.yam

Quedaría unha estrutura como a que segue:
![actividades32](./../_media/01/actividades32.png)

Agora desplegamos esta estrutura. 

## b) Aplicando regras de ingress para conectar todo

Imos crear unha regra de ingress de tal xeito que:

- A artefacto terá de nome practica-4-ingress
- Definirá dous paths:
  - /v1 => que levará ó servizo practica-4-v1
  - /v2 => que levará ó servizo practica-4-v2

Creada esta configuración (nun ficheiro chamado ingress.yaml) lanzaráse no clúster de microk8s. 

Agora, e dende un porto redirixido da vm ó noso host (que apunte ó porto 80 da vm) faremos no navegador

`localhost:<porto redirixido>/v1`
![actividades33](./../_media/01/actividades33.png)

`localhost:<porto redirixido>/v2`
![actividades34](./../_media/01/actividades34.png)


## Evaluación

**Evidencias da adquición dos desempeños**:
- Envío dun pdf cos contidos necesarios para realizar os puntos do a) e b) segundo estes.

**Indicadores de logro**: Deberías ter...
- Artefactos cos yaml para crear os deploys e os servizos v1 e v2 segundo os requisitos do **punto a)** e captura dos comandos necesarios para:
  - Arrancar os yaml 
  - Comprobar que os pods están a correr (e a súa saída)
  - Comprobar que os services e deploys están creados no k8s.
- Artefacto co ingress segundo os requisitos do **punto b)** e os comandos necesarios para
  - Arrancar a estrutura
  - Comprobar que está creada no sistema (e a súa saída)
- Capturas do navegador coa saída das rutas v1 e v2


 

**Criterios de corrección**:
- ata 20 puntos do apartado a)
  - 5 puntos se os yaml de creación do deploy e service v1 están correctos
  - 5 puntos se os yaml de creación do deploy e service v2 están correctos
  - 2 puntos por cada comando ou grupo de comandos para arrancar e listar os artefactos. 
- ata 10 puntos do apartado b)
  - 8 puntos se o yaml de creación do ingress é correcto
  - 1 punto  polo comando de creación e listado do artefacto de ingress
- ata 10 puntos
  - 5 puntos por cada unha das capturas de pantalla do navegador para v1 e v2


**Autoavaliación**: Autoavalía esta tarefa aplicando os indicadores de logro anteriores.

**Peso na cualificación**:
Peso desta tarefa na cualificación final ...................................... 40 puntos
Peso desta tarefa no seu tema .................................................... 40 %