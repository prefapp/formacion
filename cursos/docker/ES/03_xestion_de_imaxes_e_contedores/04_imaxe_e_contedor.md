# Imaxe e contedor

> Nesta sección afirmamos que a imaxe é algo **estático** e **inmutable**, polo que as imaxes non se poden cambiar, agás a través dos métodos establecidos para o desenvolvemento e mantemento de imaxes por parte da suite de Docker.

- Significa isto que un container non pode escribir en disco? 
- Dentro do container, poderemos crear, borrar ou modificar ficheiros?
- Se a imaxe é algo inmutable, cómo se pode facer todo isto?
Por suposto, Docker permite que os containers modifiquen o seu sistema de ficheiros, puidendo, se quixer, borrar todas as carpetas e os seus contidos. 

Para poder facer isto, Docker emprega un mecanismo coñecido como **copy-on-write** (COW).

## O mecanismo de COPY-ON-WRITE

O "truco" é concetualmente sinxelo: Docker non corre o noso container directamente sobre a imaxe, senón que, por enriba da última capa da mesma, crea unha nova: **a capa de container**.

Partamos dun container correndo e baseado nunha imaxe:

![Container imaxe](./../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_1.png)

Realmente, a imaxe está formada polas capas propias da imaxe e por unha capa de container. Tan só a capa de container é de **ESCRITURA/LECTURA**.

![Container imaxe](./../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_2.png)

Deste xeito, os programas correndo no container poden escribir no sistema de ficheiros de xeito natural sen ser conscientes de que, realmente, están a escribir nunha capa asociada ó container e non na imaxe que é inmutable. 

![Container imaxe](./../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_3.png)

Isto posibilita que, cada container, poida face-las súas modificacións no sistema de ficheiros sen afectar a outros containers que estén baseados na mesma imaxe, dado que, **cada container ten asociada unha capa de container específica para él**. 

![Container imaxe](./../_media/03_xestion_de_imaxes_e_contedores/imaxe_e_contedor_4.png)

Tal e como podemos ver, este mecanismo é moi útil. Non obstante, esto produce un problema: **a volatilidade dos datos**.

O tratamento deste problema e das súas solucións, será obxecto da seguinte sección.
