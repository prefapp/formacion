
# Pull request

Unha pull request (PR) é unha solicitude de fusión dunha rama noutra rama. En GitHub as pull requests utilízanse para solicitar esta fusión e para revisar os cambios realizados na rama antes de completala.

Para crear unha pull request en GitHub pódese utilizar a interface web do repositorio remoto ou, no seu caso, algunha ferramenta de liña de comandos complementaria que se poida instalar no equipo local, coma o GitHub CLI.

Algunhas boas prácticas para crear unha pull request son:

- **Mantén a pull request pequena e enfocada**: isto facilitará a revisión e a aprobación da solicitude.

- **Proporciona unha descrición clara**: describe o que se cambiou, por que se realizou o cambio e como afecta ó proxecto.

- **Actualiza coa rama base**: antes de enviar unha pull request, para evitar conflitos, asegúrate de que a túa rama está actualizada coa rama base.

- **Fai o seguimento á pull request**: asegúrate de facer o seguimento e estar dispoñible para responder calquera pregunta ou comentario que poidan ter os revisores.

E, pola outra parte, algunhas boas prácticas para os revisores dunha pull request son:

- **Realiza unha revisión detallada**: asegúrate de revisar coidadosamente os cambios realizados na pull request e de entender o propósito dos mesmos.

- **Proporciona comentarios construtivos**: asegúrate de que os teus comentarios sexan construtivos e de que as suxestións sexan claras, para que o autor poida mellorar o seu traballo.

- **Fai preguntas para obter máis información**: se tes dúbidas sobre os cambios realizados, asegúrate de facer preguntas ata comprender o que está facendo o autor.

- **Comunica claramente a decisión da revisión**: unha vez feita a revisión, comunica claramente ó autor se se aprobou a pull request, se é preciso facer cambios adicionais ou se se rexeita a solicitude. Se é posible, explica por que se tomou esta decisión.

## Ship / Show / Ask
_Extraído do artigo de Rouan Wilsenach ["Ship / Show / Ask"](https://martinfowler.com/articles/ship-show-ask.html)_

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../_media/02_hands_on/ship_show_ask.png)

  </div>
</div>

Cada vez que fas unha pull request, elixes unha das tres opcións: Ship, Show ou Ask.

### Ship
Isto é o máis parecido á [Integración Continua](https://es.wikipedia.org/wiki/Integraci%C3%B3n_continua) de antano. Fas directamente o cambio na rama principal con tódalas técnicas habituais de integración continua para que sexa seguro. Cando fas isto, non te quedas agardando a que alguén leve o teu cambio a produción. Non estás pedindo unha revisión do código.

Funciona moi ben cando:

- Se engade unha característica usando un patrón establecido.
- Se arranxa un erro sen importancia.
- Se actualiza documentación.
- Se mellorou o código baseándose nos comentarios.
- O repositorio non é colaborativo.
- Non son cambios críticos.
- Tes a suficiente confianza na túa experiencia e na experiencia do teu equipo.

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../_media/02_hands_on/ship.png)

  </div>
</div>

### Show 

A opción show inclúe a mentalidade da Integración Continua e dálle uso ás bondades que os pull requests poden darnos. Fas o teu cambio nunha rama distinta á principal, abres unha pull request e fas a fusión sen esperar a ninguén, tan só ás túas comprobacións automatizadas (probas, cobertura de código, contornas de preview, etc. Veremos os workflow máis adiante).

Deste modo, terás posto en marcha o cambio con rapidez, deixando un espazo para os comentarios e a conversación a posteriori. O teu equipo será notificado da pull request e, entón, poden revisar o que fixeches. Poden proporcionarche comentarios sobre o seu enfoque. Poden facerte preguntas. Poden aprender do que fixeches.

Funciona moi ben cando:

- Queres a opinión de terceiros sobre como se podería mellorar o cambio.
- Se quere amosar un novo enfoque ou patrón.
- Refactorización, bugs, melloras de rendemento, etc.
- Cando é un erro ou unha solución interesante ou para non esquecer.
- O repositorio é colaborativo, pero cun owner único.
- Cando non son cambios críticos.
- Tes a confianza suficiente na túa experiencia e na experiencia do teu equipo.

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../_media/02_hands_on/show.png)

  </div>
</div>

### Ask
Coa opción ask facemos unha pausa. Cos nosos cambios nunha rama abrimos unha pull request contra a rama principal e esperamos a retroalimentación antes de fusionar. Tal vez non esteamos seguros de ter tomado o enfoque correcto. Tal vez hai algún código co que non estamos totalmente contentos pero non estamos seguros de como melloralo. Tal vez fixemos un experimento e queremos ver que pensa a xente.

As ferramentas modernas de revisión de código ofertan un gran espazo para este tipo de conversa e incluso podes reunir a todo o equipo para ver unha pull request e discutila.

Funciona moi ben cando:

- Queremos preguntar se algo funcionará.
- Proposta dun novo enfoque.
- Pides axuda para melloras.
- Terminamos por hoxe e vaise fusionar mañá.
- Control de novos integrantes no código.
- Cando os cambios son críticos.
- O código é colaborativo e mantido por un equipo ou comunidade.

<div style="text-align: center;">
  <div style="margin: 0 auto;">

![](../_media/02_hands_on/ask.png)

  </div>
</div>
