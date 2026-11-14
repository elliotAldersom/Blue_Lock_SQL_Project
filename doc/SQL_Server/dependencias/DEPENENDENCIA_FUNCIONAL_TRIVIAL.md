# Blue Lock SQL Project  
## Dependencia _Funcional Trivial_ 
- Una dependencia funcional es `trivial` cuando el **atributo del lado derecho _(dependiente)_** ya está **contenido en el lado izquierdo _(determinante)_**.

**EJM 1:** 
  -  `(id_piloto, lenguaje) -> id_piloto` 
  - Porque `id_piloto` ya está dentro del **lado izquierdo**. 

**EJM 2:** 
  -  `(id_empleado, nombre) -> nombre` 
  - Porque `nombre` ya está dentro del **lado izquierdo**. 

**EJM 3:** 
  -  `(A, B, C) -> B` 
  - Porque `B` ya está dentro del **lado izquierdo**. 

**Idea Intuitiva** 
  - **_"No te está diciendo nada nuevo, solo 'repite' información que ya tenías."_**

--- 
## Dependencia _Funcional NO Trivial_ 
- Una dependencia funcional es no `trivial` cuando el **lado derecho _(dependiente)_** contiene algo que **NO** está en el **lado izquierdo _(determinante)_**. 

**EJM 1:** 
  -  `(id_piloto, lenguaje) -> nombre` 
  - `Nombre` no está en el lado **determinante** sino en el **dependiente**.

**EJM 2:** 
  -  `lenguaje -> instructor` 
  - `Instructor` no está en el lado **determinante** sino en el **dependiente**.

--- 
## Dependencia _Funcional  SemiTrivial_ 
- Cuando **_parte_** del atributo **derecho _(dependiente)_** ya está en el **izquier _(determinante)_**, **_pero no todo_**. 

**EJM 1:** 
  -  `(id_piloto, nombre) -> nombre, edad` 
  - `Nombre` es parte del **determinante** pero edad **NO**.
  - Básicamente su **intersección** de `{id_piloto, nombre} E {nombre, edad} = nombre`

--- 
