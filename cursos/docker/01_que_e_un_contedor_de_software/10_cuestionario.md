# Cuestionario Final

Un SO illa completamente os recursos que expón aos procesos que corren nel?

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="1"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Sí, totalmente, é a sua misión principal.
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="2"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Non, existen unha serie de recursos (puntos de montaxe, usuarios, pids, IPC...) que siguen sendo globais. 
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
            Un SO non illa recursos. 
        </label>
    </div>
</div>

---

A técnica da virtualización a nivel de plataforma...

> <div class='checkboxes'>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="1"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            Busca emular con software o hardware dunha máquina para crear un computador virtual.
        </label>
    </div>
    </br>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="2"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            É moi pouco costosa en térrmos de tempo de arranque e de uso de CPU/RAM. 
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
            É incompatible con calquer outra forma de virtualización.
        </label>
    </div>
</div>

---

Os contedores de software son unha técnica de virtualización...

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox3"
            value="1"
            onclick="selectOnlyThis3(this)">
        <span class='indicator'></span>
            Que busca emular o hardware de forma similar ao que fan as técnicas de virtualización de plataforma.
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
            Ofrece unha vista "privada" dunha serie de recursos tradicionalmente globais de forma que o proceso, ou grupo de procesos, ten a ilusión de ter un SO para él.
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
            Non pode usarse en máquinas virtuais.
        </label>
    </div>
</div>
