# Entón, que é un contedor?

> Empregando as ferramentas que nos da Linux, imos construir un contedor para unha distro de debian.

\**Nota - Esta práctica está baseada [nesta](https://ericchiang.github.io/post/containers-from-scratch/).*

## 1 - O sistema de ficheiros 

Para correr un sistema debian, obviamente, precisamos do conxunto de ferramentas, útiles e demonios que ten unha distro deste tipo. 

Imos baixar un sistema de ficheiros con tódolos elementos necesarios.

Collemos o tar deste link.

Nun directorio do noso sistema de ficheiros, descargamos o tar co sistema debian:

```bash
wget https://github.com/ericchiang/containers-from-scratch/releases/download/v0.1.0/rootfs.tar.gz
```

Imos extraer os contidos do tar:

```bash
tar xfz rootfs.tar.gz
```

Se listamos os contidos do rootfs resultante, veremos que ten unha estrutura moi similar á dun sistema tradicional debian.

## 2 - Engaiolar o proceso no sistema de ficheiros mediante chroot

A ferramenta [chroot](https://en.wikipedia.org/wiki/Chroot), permítenos illar un proceso con respecto a unha ruta concreta dentro do noso sistema de ficheiros. 

Se lanzamos este comando dende a ruta onde desentarramos o noso sistema de ficheiros:

```bash
chroot rootfs /bin/bash
```

Entraremos nunha nova shell, un novo proceso, que está montado a partires de 6. ```~/rootfs```.

![Container](./../_media/01_que_e_un_contedor_de_software/container_10.png)

Temos un container real? 

A resposta é que non.

Se montamos o proc nunha ruta do noso proceso:

```bash
mount -t proc proc /proc
```

E facemos un ps ou un top, seguimos a ver tódolos procesos do sistema. 

Polo tanto, o noso proceso, ainda que ten como raíz o rootfs, non está realmente illado do resto do sistema, posto que segue a pertencer ós namespaces globáis.

É dicir, o noso proceso **segue a estar no namespace global compartido polo resto dos procesos do sistema**.

![Container](./../_media/01_que_e_un_contedor_de_software/container_11.png)

Como podemos ver, este proceso non está realmente "contido":

- Pode crear usuarios no namespace xeral da máquina.
- Pode ve-los procesos de toda a máquina.
- Se modifica iptables, se conecta a portos.. estará afectando ó resto dos procesos da máquina.

Isto non é un verdadeiro isolamento do noso proceso.

Para logralo, imos recorrer ós namespaces.

## 3 - Illa-lo proceso mediante os namespaces

Como vimos no paso 2, realmente, estamos a lanzar un proceso que ten unha nova raíz no sistema de ficheiros, pero non está realmente illado do resto dos recursos do sistema. Se o queremos realmente illar, teríamos que crear unha serie de namespaces privados dese proceso (e do resto de fillos do mesmo). 

Nun diagrama:

![Container](./../_media/01_que_e_un_contedor_de_software/container_12.png)

O comando [unshare](https://man7.org/linux/man-pages/man1/unshare.1.html) permítenos lanzar un comando ou proceso especificando os namespaces que queremos que sexan privados do mesmo. 

Imos lanzar de novo un proceso, pero esta vez mediante unshare:

```bash
unshare -m -i -n -p -u -f chroot rootfs /bin/bash
```

Neste comando estamos a dicirlle ó sistema:

- Lanza o proceso chroot rootfs /bin/bash
- Illa en namespaces novos de mounts, de ipc, de networking, de pids, de UTS ó proceso
Sinxelo, non? Imos ver se realmente é así. 

Montamos o proc:

```bash
mount -t proc proc /proc
```

Se introducimos o comando top, veremos que temos dous procesos. 

Vemos que proceso que ten o pid 1, é o noso /bin/bash.

Cómo é iso posible? 

Recordemos que agora estamos dentro dun novo namespace de PIDS é, o proceso que creou ese namespace, foi o noso /bin/bash. 

Imos facer outra cousa:

```bash
hostname
```

Veremos o hostname da nosa máquina. O cal non é extraño, dado que o namespace de UTS clonóuse do noso UTS global. 

Pero se agora cambiamos o hostname dentro do noso container:

```bash
hostname contedor-a-man
```

Veremos que, efectivamente, o noso hostname mudou a "contedor-a-man".

Se abrimos outra terminal na nosa máquina, e facemos hostname, veremos que conserva o hostname orixinal.

Isto é posible porque, tra-la chamada a **unshare**, o noso container ten un UTS diferente (privado) con respecto ó global.

## 4 - Conclusión

Fomos quen de crear un proceso que está dentro dun contedor (dun conxunto de namespaces privados a ese proceso). 

Deste xeito, accións que normalmente afectarían á tódolos procesos da máquina:

- Cambiar o hostname.
- Creación de usuarios.
- Facer mounts.
- Conectar aplicacións a escoitar en portos concretos.

Están illados dentro dos namespaces do contedor sen afectar á máquina.

Por último, notar que a creación do contedor levou prácticamente o mesmo tempo que lanzar un proceso novo (faga a proba) e que o custo en memoria e insignificante.
