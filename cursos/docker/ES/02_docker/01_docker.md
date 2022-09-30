# Docker

> Docker, a pesar da sua curta vida como proxecto de software aberto, está a producir unha revolución no sector das tecnoloxías da información.

**De xeito similar a revolución que supoxo a adopción dos contedores de mercancías, ao estandarizar as características das caixas nas que se transportan e moven por todo o mundo todo tipo de materias,  o que permiten adaptar e optimizar as infraestructuras polas que se almacenan e desprazan, Docker estandariza o proceso de transporte de software**.

Dende o punto de vista dun administrador de sistemas, nos permite cambiar a maneira de "transportar" e despregar aplicacións. En vez de ter que recoller as especificacións e dependencias que precisa unha aplicación, e levar a cabo a instalación da mesma  en cada máquina e sistema operativo no que se vaia a aloxar, Docker nos permite definir un "contrato", un interfaz estandard, que separa o que vai dentro de ese contedor (a aplicación e as súas dependencias) do que vai fora, o  entorno onde se vai a aloxar ( o pc doutro desenvolvedor, o servidor físico da organización, os cluster de servidores virtuais na nube...)

Dende o punto de vista do desenvolvedor  da aplicación, Docker lle proporciona o poder de controlar de xeito sinxelo o software que precisa a súa aplicación para funcionar. El só se ten que preocupar de proporcionar un artefacto, unha caixa negra que opere con total autonomía dentro dun sistema operativo definido, para que o administrador poida coller esa caixa e testeala, monitorizala e aloxala dentro da súa infraestructura.