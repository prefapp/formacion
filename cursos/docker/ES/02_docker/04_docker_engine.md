# Docker Engine

> Docker Engine, o core de docker, e o compoñente fundamental da plataforma e se compón dunha serie de elementos:

![Docker](./../_media/02_docker/plataforma_docker.png)

Como podemos ver, existen tres compoñentes básicas:

- O [docker-cli](https://docs.docker.com/engine/reference/commandline/cli/): intérprete de comandos que permite interactuar con todo o ecosistema do Docker.
Unha api REST: que permite dar resposta ós clientes: tanto o docker-cli como calqueira outra libraría ou cliente de terceiros. - A API está ben [documentada](https://docs.docker.com/engine/api/v1.40/).
- O [dockerd](https://docs.docker.com/engine/reference/commandline/dockerd/): un demonio que corre no host (pode sé-la nosa propia máquina) e que xestiona tódolos contedores, volumes e imaxes do host.

Estas tres compoñentes (docker-cli, API-REST e o dockerd) forman o motor do sistema: docker engine. 

Polo tanto, nós imos instalar o docker-engine nunha máquina e interactuar con él dende o propio docker-cli de esa máquina. Pero nada nos impide, coa configuración axeitada, poder interactuar dende o noso docker-cli cos docker daemons doutros hosts. 

**O interior do Docker daemon**

> ⚠️ A estrutura interna do dockerd sufriu varias transformacións. A última e máis profunda a mediados do 2016 onde se [dividiu en varios compoñentes](https://www.docker.com/blog/docker-engine-1-11-runc/) para facilitar a sua adopción.

O proxecto Docker, nos últimos tres anos, fixo importantes cambios para facilita-la súa adopción por parte de grandes empresas e organismos:

- A [doazón á fundación CNCF](https://www.docker.com/blog/docker-donates-containerd-to-cncf/) do seu motor a baixo nivel (o containerd) responsable da xestión dos contedores. Constitúe agora o proxecto autónomo [containerd](https://containerd.io/). que se está comezando a empregar en outros proxectos aparte de Docker (p.ex. Kubernetes)
- Cambio no modelo de goberno, [transformando](https://www.docker.com/blog/introducing-the-moby-project/) o proxecto de código aberto [docker](https://github.com/moby/moby), no proxecto [Moby](https://www.docker.com/blog/introducing-the-moby-project/), independente da organización Docker Inc., o cal permite dispoñer dun framework común para construir os diferentes "sabores" da docker engine, tanto para a organización de Docker Inc. como para terceiros, partners,  desenvolvedores... (Por exemplo o servicio de Azure Containers se basa actualmente na súa propia compilación de Moby). A partir de ese momento a organización lanzou 2 sabores do docker-engine, docker Comunity Edition e docker Entreprise Edition, que comparten o mesmo código pero levan consigo un modelo de soporte e de custos diferente .
- Colaboración estreita co organismo de recente creación, a [OCI](https://opencontainers.org/) (Open Container Initiative) para estandariza-los contedores e imaxes. 
- O emprego da libraría [runc](https://github.com/opencontainers/runc) como endpoint para comunicarse co sistema operativo do host.

Esto implica que, actualmente, a baixo nivel, o demonio de docker emprega varios proxectos independentes, para poder realizar todas as súa tarefas.

Estos proxectos constituintes están dispoñibles  para a comunidade, como software libre, e moitos deles incluso xa non pertencen directamente a organización Docker Inc, senón que foron donados a fundacións e grupos alternativos (CNCF, OCI da Linux Fundation ...) , de xeito que garanticen a súa independencia, e así as grandes empresas, e  os grandes actores de cloud na actualidade, como Microsoft ou Google, lles xere confianza para seguir apostando por estas ferramentas para a construcción dos seus propios servizos, e deste xeito, dediquen recursos propios a manter a comunidade.

![Docker](./../_media/02_docker/ejemplo_plataforma_docker.png)

*Imaxe cortesía do blogue de [docker](https://i0.wp.com/blog.docker.com/wp-content/uploads/974cd631-b57e-470e-a944-78530aaa1a23-1.jpg?resize=906%2C470&ssl=1).*

**Ligazóns de interese:**
- [Docker overview](https://docs.docker.com/get-started/overview/)
