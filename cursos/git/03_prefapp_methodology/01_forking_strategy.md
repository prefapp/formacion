
# Estratexia de bifurcación - TBD vs. Git Flow

Existen distintas estratexias populares de ramificación que podes adoptar, sendo as máis populares **git-flow** (tamén coñecido como ramas de características de longa duración) e **trunk-based development** (desenvolvemento baseado na rama principal).

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../_media/03_prefapp_methodology/git-flow_vs_Trunk-based_Development.png)

  </div>
</div>

Ademais da estratexia de ramificación, temos que ter en conta que se pode combinar cunha estratexia de fusión, como comentamos no capítulo [ship/show/ask](../02_hands_on/04_pull_request.md#ship--show--ask). Ambas estratexias poden ser máis laxas ou menos, segundo o tamaño do proxecto e a experiencia dos programadores.

Táboa coas diferenzas entre git-flow e trunk-based development:

<table border="1">
  <tr>
    <th></th>
    <th>Git-flow</th>
    <th>Trunk-based</th>
  </tr>
  <tr>
    <th>Filosofía</th>
    <td>
      <ul>
        <li>O máis lonxe posible da rama principal</li>
        <li>As novas características comezan dende a rama 'develop'</li>
        <li>Nova rama de versión derivada da rama 'develop'. Implántase a rama de versión xa estabilizada.</li>
        <li>Só os hotfixes derivan da rama principal</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>O máis preto posible da rama principal</li>
        <li>Ramas de características de corta duración que parten da rama principal</li>
        <li>A rama principal está sempre lista para implementarse en produción</li>
        <li>Hotfixes parten da rama principal ou de versión e deben seleccionarse de volta á rama principal</li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Composición do equipo</th>
    <td>
      <ul>
        <li>Falta de antigüidade no equipo</li>
        <li>Traballo con outros provedores/terceiros</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>Equipo ben composto e experimentado</li>
        <li>Modelo de aumento do equipo</li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Tipo de produto</th>
    <td>
      <ul>
        <li>Produto complexo, maduro, monolítico</li>
        <li>Produto en terreo complicado</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>Microservizos</li>
        <li>Aplicación de páxina única (SPA) moderna / Aplicacións móbiles</li>
        <li>Proba de concepto (POC) / Prototipo</li>
        <li>Compoñentes de sistemas distribuídos</li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Proceso de creación</th>
    <td>
      <ul>
        <li>Gobernado</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>Dirixido polo equipo</li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Implantación</th>
    <td>
      <ul>
        <li>Utilízanse varios modelos de implantación</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>Recoméndanse prácticas de Implementación Continua, coma palancas de características, portas de calidade, probas canarias, automatización de autoservizo (por exemplo, ChatOps) e vixilancia</li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Máis información</th>
    <td>
      <ul>
        <li><a href="https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow" target="blank">https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://trunkbaseddevelopment.com/" target="blank">https://trunkbaseddevelopment.com/</a></li>
      </ul>
    </td>

  </tr>
</table>


## Trunk-Based Development (TBD)

En Prefapp adoptamos Trunk-Based Development coma estratexia principal de desenvolvemento de software. Esta metodoloxía permítenos manter un fluxo de traballo áxil e eficiente, entregando produtos de alta calidade de xeito rápido e seguro ós nosos clientes.

A metodoloxía de Trunk-Based Development (TBD) é unha estratexia áxil de desenvolvemento de software que se centra na simplicidade e na integración continua de cambios nunha única rama principal. No canto de enfoques máis complexos coma Git-flow, TBD promove a rapidez e a colaboración ó eliminar ramas prolongadas e fomentar a integración frecuente na rama principal. Na anterior táboa pódense apreciar as diferenzas. Coma resumo dos principios clave:

- **Integración Continua**: en TBD os programadores integran cambios con frecuencia na rama principal, o que permite detectar e resolver cedo os conflitos e manter o código nun estado sempre funcional.
- **Ramas de características cortas**: as ramas de características en TBD son de corta duración e intégranse rapidamente na rama principal. Isto simplifica a xestión do código e reduce o risco de conflitos de integración.
- **Rama principal estable**: a rama principal en TBD está sempre lista para ser implantada en produción, o que garante un fluxo de traballo fluído e unha alta calidade do código.

As vantaxes de TBD que se poden apreciar son:
- **Redución de conflitos**: integrar cambios con frecuencia minimiza os conflitos de integración e mellora a eficiencia do equipo.
- **Despregamento continuo**: TBD facilita o despregamento continuo de novas funcionalidades, permitindo entregas rápidas e seguras ós usuarios finais.
- **Colaboración eficiente**: ó traballar nunha única rama principal, os equipos colaboran estreitamente e coordinan eficientemente os seus esforzos de desenvolvemento.

Para implantar TBD en Prefapp, seguimos prácticas de integración continua, revisións de código e probas automatizadas para garantir a estabilidade e calidade do código na rama principal.

Máis info: https://trunkbaseddevelopment.com/


## Versionado semántico

O versionado semántico (SemVer) é unha convención para asignar versións ás bibliotecas de software que seguen un patrón de tres números: `X.Y.Z` onde `X` é a versión maior, `Y` a versión menor e `Z` é a versión de parche. A convención de versionado semántico establece regras claras para incrementar cada número de versión en función dos cambios realizados na biblioteca.

**Versión Mayor** `(X)`:
- Incrementa cando se realizan cambios incompatibles na API.
- Indica que hai modificacións significativas que poden romper a compatibilidade con versións anteriores.

**Versión Menor** `(Y)`:
- Incrementa cando se engaden funcionalidades de xeito retrocompatible.
- Reflicte melloras e novas características que non afectan ó funcionamento do código existente.

**Versión de Parche** `(Z)`:
- Incrementa cando se corrixen erros de xeito retrocompatible.
- Indica a solución de problemas sen introducir novas funcionalidades nin romper a compatibilidade.

Ademais do Semantic Versioning (SemVer), existen outras convencións e sistemas de numeración de versións que se utilizan no desenvolvemento de software. Vexamos outros tipos nunha táboa comparativa:

| Método de Versionamento   | Exemplo de Versión           | Características                                      |
| ------------------------- | ---------------------------- | ---------------------------------------------------- |
| Versionamento Calendárico | 2024.05.24                   | Baseado en datas                                     |
| Números Secuenciais       | 1, 2, 3, …                   | Incrementa secuencialmente sen significado semántico |
| Nome de Código            | Trusty Tahr, Bionic Beaver   | Utiliza nomes descritivos ou temáticos               |
| Baseado en Hitos o Metas  | Alpha, Beta, RC, …           | Identifica o estado de desenvolvemento do software   |
| Semántica Personalizada   | 1.2.3-alpha.1+build.20240524 | Adaptación do SemVer ou personalización específica   |

Cada enfoque ten as súas propias vantaxes e desvantaxes, e a elección do método de versionamento depende en gran medida das necesidades e preferencias do equipo de desenvolvemento e da comunidade de usuarios do software. 😊

En Prefapp combinamos o Trunk-Based Development co versionado semántico para manter un fluxo de traballo áxil e transparente. Ó integrar frecuentemente os cambios na rama principal e seguir as convencións de versionado semántico, acadamos:
- **Claridade e transparencia**: os usuarios e os programadores poden comprender facilmente a natureza dos cambios entre versións.
- **Compatibilidade e mantemento**: facilitamos o mantemento do software e a compatibilidade cara a atrás ó seguir unha convención clara para os cambios importantes, as novas funcionalidades e as correccións de erros.
- **Axilidade nos despregamentos**: cunha rama principal sempre lista para produción, podemos despregar novas versións rapidamente, asegurando que cada cambio se documente e versione de xeito adecuado.

Máis info: https://semver.org/ 
