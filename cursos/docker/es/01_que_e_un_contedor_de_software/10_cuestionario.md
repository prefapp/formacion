# Cuestionario final

¿Un SO elimina por completo los recursos que expone a los procesos que se ejecutan en él?

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="1"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Sí, totalmente, es su principal misión.
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
            No, hay una serie de recursos (puntos mountaxe, usuarios, pids, IPC...) que siguen siendo globales.
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
            Un SO no aisla recursos. 
        </label>
    </div>
</div>

---

La técnica de virtualización a nivel de plataforma...

> <div class='checkboxes'>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="1"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            Busca emular el hardware de una máquina con software para crear una computadora virtual.
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
            Es muy económico en términos de tiempo de arranque y uso de CPU/RAM.
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
            Es incompatible con cualquier otra forma de virtualización.
        </label>
    </div>
</div>

---

Los contenidos del software son una técnica de virtualización...

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox3"
            value="1"
            onclick="selectOnlyThis3(this)">
        <span class='indicator'></span>
            Que busca emular el hardware de forma similar a las técnicas de virtualización de plataformas.
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
            Ofrece una vista "privada" de una serie de recursos tradicionalmente globales para que el proceso, o grupo de procesos, tenga la ilusión de tener un SO propio.
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
            No se puede utilizar en máquinas
        </label>
    </div>
</div>
