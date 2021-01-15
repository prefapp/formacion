# Revisitando as imaxes: o overlayfs

Na sección anterior vimos o concepto de imaxe e cómo se empregan para acada-los obxectivos da containerización. 

Sen embargo, nesta sección imos profundizar no concepto de imaxe botando unha ollada ás tecnoloxías que as fan posibles: referímonos ós **union mounts**. 

## 1. Os unions mounts
Un union mount é un sistema que permite combinar diferentes directorios nun só que se ve como unha mestura dos mesmos: de ahí o seu nome.

![Union](./../_media/01_creacion_de_imaxes/union_1.png)

### A. Xogando cos union mounts

> ⚠️ Para facer esta  práctica guiada compre un sistema linux cun kernel >= 3.18. Non se pode realizar dentro dun contedor!

A tecnoloxía empregada hoxe en día por Docker é o [OverlayFS](https://en.wikipedia.org/wiki/OverlayFS), incluído no propio kernel dende a 3.18. 

Imos crear dous directorios: 

```shell
mkdir a b
```

Dentro de o directorio _**~/a**_ imos crear dous ficheiros baleiros: 

```shell
touch a b
```

Dentro do directorio _**~/b**_ imos crear dous ficheiros baleiros (**c** **e** **d**) e un novo directorio **e**.

```shell
touch c d
mkdir e
```

Agora creamos un directorio c ó mesmo nivel que _**~/a**_ _**e ~/b**_.

```shell
mkdir c
``` 

Lanzando o seguinte comando:

```shell
mount -t overlay overlay -o lowerdir=./a,upperdir=./b,workdir=./c ./c
```

Se listamos os contidos do _**~/c**_ veremos que temos unha estrutura como a do diagrama.

Que fixemos con este comando?

- Montamos unha unidade nun directorio _**~/c**_.
- De tipo _**overlay**_.
- Especificamos como obxectivo: un directorio de só lectura (_**~/a**_) un directorio de escritura-lectura (_**~/b**_) e un directorio especial de trasvase (_**~/c**_).

### B. O mecanismo COW e o copy-up

Por suposto, xorden preguntas:

- Que pasa se modifico un ficheiro?
- Que pasa se elimino un directorio ou ficheiro?
- Podo establecer elementos de solo lectura?

Cando falamos de lowerdir e upperdir estámonos a referir a dous niveles de montaxe no overlayfs. 

#### i. O Lowerdir

As capas montadas neste nivel non poder ser modificadas ou eliminadas.

En caso de modificar un ficheiro pertencente a esta capa, o que se vai facer e copialo (COW - copy on write) a unha capa superior, ó upperdir.

![Union](./../_media/01_creacion_de_imaxes/union_3.png)

O copy-up recibe o seu nome de esa operación de copia-lo ficheiro dunha capa de lowerdir a unha de upperdir antes de modificala. Esto permite dúas cousas:

- So se copian os ficheiros que son realmente modificados (Copy On Write -> COW)
- Pódense manter capas de só lectura mesturadas con capas de escritura. 
- Todas estas operacións son transparentes para o proceso que corre no volume de overlayfs.

#### ii. O upperdir

Trátase dos directorios de escritura/lectura. Os copy-up realízanse nestas capas. 


## 2. Imaxes e OverlayFS

Como contaramos, o contedor créase a partir dunha imaxe que é un sistema de ficheiros de só lectura.

Nembargantes, dentro de contedor podemos instalar, borrar e modificar todo o que queiramos.

Agora, entendemos que tódolos cambios se están a guardar na capa do contedor que é un upperdir montado precisamente por enriba da imaxe que é capa de lowerdir.

E os volumes? Os volumes, dependendo de se os montamos de só lectura ou non, estarán en lowerdir ou en upperdir.
