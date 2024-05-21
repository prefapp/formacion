# Comandos básicos git

Os comandos máis utilizados:

- `git init`: inicializa un novo repositorio Git baleiro na carpeta actual.
- `git add`: agrega cambios de arquivos específicos ou de tódolos arquivos novos ou modificados á área de preparación.
- `git commit`: crea un novo commit cos cambios agregados á área de preparación e unha mensaxe de commit descritiva.
- `git status`: amosa o estado actual do repositorio, incluíndo os arquivos modificados, os arquivos que se atopan na área de preparación e os commits pendentes.
- `git log`: amosa o historial de commits do repositorio, incluíndo as mensaxes de commit, os autores e as datas de cada commit.
- `git branch`: amosa unha lista de ramas no repositorio, e tamén pódese utilizar para crear, eliminar e cambiar de rama.
- `git checkout`: cambia de rama, crea unha nova rama ou cambia o estado dos arquivos no repositorio.
- `git merge`: fusiona dúas ramas nunha rama común, e tamén se pode utilizar para resolver conflitos de fusión.
- `git pull`: descarga e fusiona os cambios máis recentes dun repositorio remoto no repositorio local.
- `git push`: envía os cambios locais a un repositorio remoto.
- `git diff`: amosa as diferencias entre dous arquivos ou entre dous commits, e tamén se pode utilizar para comparar os cambios entre dúas ramas.
- `git reset`: desfai cambios no repositorio, sexa eliminando os cambios da área de preparación ou eliminando un commit específico.
- `git rm`: elimina arquivos do repositorio e tamén os elimina da área de preparación.
- `git mv`: cambia o nome dun arquivo ou move un arquivo dunha localización a outra, e tamén actualiza o estado do repositorio e a área de preparación.
- `git stash`: garda temporalmente as modificacións nunha pila de cambios e restablece o repositorio ó seu estado anterior, o cal pode ser útil para cambiar rapidamente de rama ou para almacenar cambios inacabados.
- `git tag`: crea unha etiqueta para un commit específico, o que pode ser útil para marcar versións ou fitos importantes.
- `git remote`: amosa unha lista dos repositorios remotos asociados co repositorio local, e tamén se pode utilizar para agregar, eliminar e actualizar repositorios remotos.
- `git fetch`: descarga os cambios máis recentes dun repositorio remoto no repositorio local, pero non fusiona os cambios coa rama actual.
- `git clone`: crea unha copia completa dun repositorio remoto nunha nova carpeta local.

Non esquezas consultar a [guía oficial de comandos de git](https://git-scm.com/docs/git) para sacarlle o máximo partido a git.


## 10 comandos (menos un) moi útiles

1. Cando introduces mal un comando en Git, este adoita suxerir o correcto. Podes facer que se execute automaticamente configurando o tempo de auto corrección (onde 1 é unha décima de segundo):

    ```bash
    git config --global help.autocorrect 1
    ```

2. Volver á rama anterior rapidamente usando:

    ```bash
    git switch -
    ```

    Se non tes `git switch`, podes usar `git checkout`.

3. O git log, por defecto, non ofrece unha información visual. Cunhas poucas opcións podes conseguir cores, ramificacións e máis información.

    ```bash
    git log --pretty=oneline --graph --decorate --all
    ```

    Un exemplo vistoso do que podes conseguir é o seguinte:

    ```bash
    git log --graph --pretty=format:"%C(yellow)%h%Cred%d%Creset  -  %C(cyan)%an%Creset:  '%s'    %Cgreen(%cr)%Creset"
    ```

    Cuxo resultado é similar a este:

    ![](../_media/02_hands_on/git-log-format.png)

    E, para non ter que recordar o comando, pódese definir un alias (coma gglog) no arquivo `.zshrc`/`.bashrc`.

4. Se non queres pasar pola fase de staging de Git, se engades o parámetro `-a` ó commit, sáltaste a necesidade de executar `git add` sobre eses ficheiros. 

    ⚠️ Ollo! Non funciona para ficheiros novos. Só para ficheiros modificados.

5. Pódense crear alias no ficheiro de configuración de Git dos comandos máis usados. Por exemplo, con dúas letras para `git commit`:

    ```bash
    git config --global alias․co commit
    ```

    Agora podes usar:

    ```bash
    git co
    ```

6. Podes facer Push a múltiples remotos á vez.

    Primeiro, configura o repositorio remoto coma o terías normalmente, con push e fetch:

    ```bash
    git remote add origin git@github.com:[username]/[repository]
    ```

    Podes confirmar esta configuración listando os remotos configurados:

    ```bash
    git remote -v
    ```

    Agora, configura as múltiples URLs remotas, incluíndo a que acabas de engadir:

    ```bash
    git remote set-url --add --push origin git@github.com:[username]/[repository]
    git remote set-url --add --push origin git@bitbucket.org:[username]/[repository]
    ```

    E se confirmas de novo con `git remote -v` poderás ver configuradas ambas URLs coma push e mais a primeira coma fetch. 

    ```bash
    origin	git@github.com:[username]/[repository] (fetch)
    origin	git@github.com:[username]/[repository] (push)
    origin	git@bitbucket.org:[username]/[repository] (push)
    ```

7. Podes engadir ficheiros ó commit anterior con:

    ```bash
    git commit --amend
    ```

    Isto é útil cando esqueciches engadir algo ó commit anterior.
    ⚠️ Ollo! Non o fagas se xa fixeches push do commit.

8. Imaxina que modificaches varios arquivos dun repositorio, pero só queres facer commit dun deles. Como podo facer commit dun só ficheiro do meu repositorio?

    ```bash
    git commit -m "A túa mensaxe do commit" arquivo.txt
    ```

9. No caso de que teñamos engadido ó staging con `git add` un arquivo que aínda non está listo para subir, podemos volver atrás con:

    ```bash
    git rm --cached nomeficheiro.txt
    ```
    
    ou, se queremos sacar do staging tódolos arquivos porque fixemos un `git add .` por erro, podemos utilizar:

    ```bash
    git reset HEAD. 
    ```
    ⚠️ Ollo! Non o fagas se xa fixeches un push do commit.

    ⚠️ Ollo! Non deberías utilizar `git add .` co punto: a boa práctica é engadir os arquivos un por un, con `git add nomearquivo.txt`. Recorda que os pull request deben ser o máis pequenos posible, de xeito que os commits tamén.

## Cheatsheat comandos
Unha cheatsheet é unha folla de referencia rápida que contén  os comandos máis utilizados dunha linguaxe ou ferramenta, neste caso de Git. Aquí tes algunhas que te poden axudar:
- Cheatsheat [oficial de git](https://training.github.com/downloads/es_ES/github-git-cheat-sheet/)
- Cheatsheet de [GitLab](https://about.gitlab.com/images/press/git-cheat-sheet.pdf)
- Cheatsheet de [GitHub](https://education.github.com/git-cheat-sheet-education.pdf)
- Cheatsheet de [Atlassian](https://www.atlassian.com/es/git/tutorials/atlassian-git-cheatsheet)
- Cheatsheet de [Git Tower](https://www.git-tower.com/blog/git-cheat-sheet/)
- Cheatsheet de [Cheatography](https://cheatography.com/itsellej/cheat-sheets/git-commands/)
