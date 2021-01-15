# A "pingueira" no illamento do Kernel: recursos globais

> Unha discusión en profundidade sobre este problema pódese atopar neste [artigo](https://lwn.net/Articles/524952/). 

Vimos na sección anterior que o kernel illa unha serie de recursos de forma que poden usarse privativamente, ainda que sexa de forma ilusoria, por un proceso ou grupo de procesos. 

Pero, ¿logran os SO illar todos los recursos dunha máquina?

La respuesta é que non. Alomenos nos entornos UNIX, existen unha serie de recursos que son comúns e, polo tanto, globais para todos os procesos.

![Container](./../_media/01_que_e_un_contedor_de_software/container_4.png)

Estos recursos son:

- Usuarios
- Comunicacións entre procesos (IPC: Sockets, pipes...)
- Puntos de montaxe (Sistemas de ficheiros)
- Pila de rede (interfaces, bridges, iptables...)
- UTS (hostname, domainname...)
- PIDs

Esto implica que, nun sistema non pode haber dous procesos co mesmo PID, ou dos procesos que vexan dos hostnames diferentes na mesma máquina, ou teñan acceso a puntos de montaxe distintos...

**Σ Webgrafía**
- Kerrisk, Michael. "LEC: The failure of operating systems and how we can repair it". [en liña](https://lwn.net/Articles/524952/) [Consulta: 6-xan-2019]