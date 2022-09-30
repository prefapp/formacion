# Cuestionario Final

Que relación teñen as imaxes cos containers?

> <div class='checkboxes'>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="1"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Son a planiña de creación do container, almacenan todo o stack de software que pode executarse no container.
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="2"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Trátase do conxunto de configuracións que reflicten cómo debe funcionar un container. 
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="3"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Unha imaxe é unha ISO dun sistema operativo a montar no container. 
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="4"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Unha copia de seguridade ou snapshot dun sistema en funcionamento.
        </label>
    </div>
</div>

---

En que consiste o problema da persistencia nos containers?

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="1"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            O container non pode almacenar datos polo que todo o seu estado ten que vir definido na imaxe que monta.
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="2"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            Dada a volatilidade dos containers, compre que os datos fiquen almacenados en volúmenes externos, non volátiles. 
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="3"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            Os containers podense marcar como persistentes, almacenando indefinidamente os seus datos. 
        </label>
    </div>
</div>

---

En que casos compre empregar a opción _**-f**_ no _**docker rmi**_?

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox3"
            value="1"
            onclick="selectOnlyThis3(this)">
        <span class='indicator'></span>
            Para <strong><i>"está vostede seguro? (S/N)"</i></strong>.
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox3"
            value="2"
            onclick="selectOnlyThis3(this)">
        <span class='indicator'></span>
            Para forza-lo borrado da imaxe aínda que esté a ser empregada por containers en funcionamento. 
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox3"
            value="3"
            onclick="selectOnlyThis3(this)">
        <span class='indicator'></span>
            Empregando a opción <strong><i>-f</i></strong> a imaxe bórrase en local e tamén no repositorio onde esté aloxada (sempre que se teñan permisos).
        </label>
    </div>
</div>