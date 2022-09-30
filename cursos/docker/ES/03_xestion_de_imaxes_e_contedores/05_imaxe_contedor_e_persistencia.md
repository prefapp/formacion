# Imaxe, contedor e persistencia

O problema da persistencia 
Sabemos que un container é un elemento volátil que pode ser arrincado e parado en cuestión de segundos. Sabemos, tamén, que é susceptible de correr nunha máquina ó carón doutros centos ou incluso miles de containers. 

Na anterior sección viramos que o container realiza as súas operacións de escritura, **modifica o seu estado**, nunha capa distinta da imaxe que está asociada a ese container concreto. 

O problema xorde en que, se o container é volátil, a capa asociada a ese container o é tamén.

> Polo tanto, **NON PODEMOS ALMACENAR DATOS DE IMPORTANCIA NA CAPA DO CONTAINER**.

Imaxinemos que o noso container escribe datos clave nun ficheiro situado no sistema de archivos:

![Container](./../_media/03_xestion_de_imaxes_e_contedores/container_escribe_datos.png)

Agora xa sabemos que todos esos cambios realmente se están a facer na capa onde o container pode escribir, isto é, **na capa de container**. 

Se por algunha razón, o container cae ou desaparece, tamén o fai a capa de datos asociada ó mesmo. 

![Container](./../_media/03_xestion_de_imaxes_e_contedores/container_escribe_datos_desaparece.png)

Isto supón que, si relanzamos un container, vai ter unha nova capa de datos (asociada ó container) e, polo tanto, **non ten ese ficheiro de datos, ou os seus cambios**.

![Container](./../_media/03_xestion_de_imaxes_e_contedores/container_escritura_datos_error.png)

## Solucións ó problema da persistencia

O problema da persistencia solucionase de dúas formas distintas:

- **Almacenar na imaxe**: existen formas de almacenar datos importantes na imaxe. Non é recomandable no 99% dos casos!!!! A imaxe é algo estático que ten dependencias básicas do sistema, a súa evolución basease na creación dunha nova imaxe e expresa configuracións estruturais de sistema ou novas versións de software, o estado dunha aplicación non se debe almacenar na imaxe do container.

- **Volúmenes de datos**: esta é a forma adecuada de garantir a persistencia. Deste xeito os datos están nunha carpeta da máquina anfitrión e, o container, fai cambios no sistema de ficheiros que non é volátil, polo que, ainda que o container desapareza os datos está almacenados nun lugar estable e persistente.
