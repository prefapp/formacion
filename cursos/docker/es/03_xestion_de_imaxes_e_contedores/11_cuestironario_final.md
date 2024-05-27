# Cuestionario Final

¿Qué relación tienen las imágenes con los contenedores?

> <div class='checkboxes'>
    <div>
        <label class='checkboxgreen'>
        <input
            type='checkbox'
            name="myCheckbox1"
            value="1"
            onclick="selectOnlyThis1(this)">
        <span class='indicator'></span>
            Es el plan de creación del contenedor, almacenan toda la pila de software que se puede ejecutar en el contenedor.
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
            Es un conjunto de configuraciones que reflejan cómo debe funcionar un contenedor.
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
            Un imaxe es un ISO de un sistema operativo que se montará en el contenedor. 
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
            Una copia de seguridad o instantánea de un sistema en funcionamiento.
        </label>
    </div>
</div>

---

¿Cuál es el problema de la persistencia en contenedores?

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox2"
            value="1"
            onclick="selectOnlyThis2(this)">
        <span class='indicator'></span>
            El contenedor no puede almacenar datos porque su estado completo debe definirse en la imagen que ensambla.
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
            Dada la volatilidad de los contenedores, asegúrese de que los datos se almacenen en volúmenes externos no volátiles. 
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
            Los contenedores se pueden marcar como persistentes, almacenando sus datos indefinidamente.
        </label>
    </div>
</div>

---

¿En qué casos debo usar la opción _**-f**_ en _**docker rmi**_?

> <div class='checkboxes'>
    <div>
        <label class='checkboxred'>
        <input
            type='checkbox'
            name="myCheckbox3"
            value="1"
            onclick="selectOnlyThis3(this)">
        <span class='indicator'></span>
            Para <strong><i>"¿Estár a salvo? (S/N)"</i></strong>.
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
            Para forzarlo se desdibujó la imagen aún siendo utilizada por contenedores en funcionamiento.
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
            Usando la opción <strong><i>-f</i></strong>, la imagen se borra en el lugar y también en el repositorio donde se almacena (siempre que se den los permisos).
        </label>
    </div>
</div>
