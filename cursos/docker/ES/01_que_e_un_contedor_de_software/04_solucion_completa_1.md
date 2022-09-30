# Solución completa (1): os namespaces

Os contedores de software consisten nunha técnica de virtualización a nivel de SO, tamén se coñocen como virtualización a nivel de proceso. 

A idea é sinxela, dado que o SO é, dende o punto de vista do proceso, un conxunto de recursos, podemos ofrecerlle unha vista "privada" ou virtual desos recursos. 

![Container](./../_media/01_que_e_un_contedor_de_software/container_7.png)

A virtualización desos recursos globais de tal forma que, desde o punto de vista do proceso, sexan privados para él, **é no que consiste un contedor**.

> "De igual xeito que na virtualización a nivel de plataforma o SO "cree" estarse a executar nunha máquina real, na  containerización, o proceso "cree" ter un SO para sí mesmo"

A técnica de usar contedores é superior a da virtualización de plataforma en que:

- No supón un custe de recursos adicionais por ter que emular hardware e correr en él un SO: se poden ter milleiros de contedores nun servidor
- O arranque/parada dun container é prácticamente igual ao arranque/parada dun proceso (< 1'')

A costa de:

- Compartir o Kernel do SO

Ademais, non é alternativa a técnica de virtualización de plataforma: ao contrario, é **totalmente compatible**. Precisamente, é como se está a empregar en moitos sitios:

![Container](./../_media/01_que_e_un_contedor_de_software/container_8.png)

Kerrisk Michael, "Namespaces in operation, part 1: namespaces overview" [en liña](https://lwn.net/Articles/531114/) [Consulta: 06-Xaneiro-2019]
* O primeiro de 9 artigos a consultar para explorar en profundidade os namespaces en Linux e a súa condición de elemento fundamental para os contedores. 
