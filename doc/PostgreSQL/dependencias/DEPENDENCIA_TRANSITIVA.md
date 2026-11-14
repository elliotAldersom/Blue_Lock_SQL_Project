# Blue Lock SQL Project  
## Dependencia _Transitiva_ 
- Ocurren cuando una **atributo** depende de la clave primaria a través de otro **atributo intermedio**, se presenta así: 
  - `A -> B` 
  - `B -> C`
  - `=> A -> C` _(transitiva)_   

  - Taducción simple: **A** determina a **B**, **B** detemrina a **C**, entonces **C** depende de **A**, pero indirectamente. 

**EJM:** 
- Tabla: 

    | id_empleado | id_departamento | nombre_departamento |
    | ----------- | --------------- | ------------------- |
    | 1           | 10              | RRHH                |
    | 2           | 20              | Sistemas            |
    | 3           | 10              | RRHH                |

- **Paso 1:** _Dependencias reales_ 
    - `id_empleado -> id_departamento` 
    - `id_departamento -> nombre_departamento` 

- **Paso 2:** _Deducción_
    - Si: 
      - `id_empleado` te da `id_departamento` 
      - `id_departamento` te da `nombre_departamento` 
    - Entonces: 
      - `id_empleado -> nombre_departamento`  
      - Pero de forma indirecta 

---
## ¿Por qué es un problema? 
- Porque estás repitiendo datos: 

    | id_empleado | id_departamento | nombre_departamento |
    | ----------- | --------------- | ------------------- |
    | 1           | 10              | RRHH                |
    | 2           | 20              | Sistemas            |
    | 3           | 10              | RRHH                |

- El problema es: `nombre_departamento` **NO** depende directamente del **empleado**. Depende del **departamento**. 

## ¿Qué pasa si cambia el nombre del departamento?
- Si **RRHH** cambia a: **Recursos Humanos** 

- Tienes que actualizar: Todas las filas donde `id_departamento = 10` 
- ❌ **Problema de redundancia y actualización** 

## Solución (3FN) 
- Se separa en dos tablas: 
- **Empleado:**
   
    | id_empleado | id_departamento |
    | ----------- | --------------- |
    | 1           | 10              |
    | 2           | 20              |
    | 3           | 10              |

- **Departamento:** 

    | id_departamento | nombre_departamento |
    | --------------- | ------------------- |
    | 10              | RRHH                |
    | 20              | Sistemas            |


## Ahora ya no existe _Transitividad_ 
- Porque: 
  - `id_empleado -> id_departamento` 
  - `id_departamento -> nombre_departamento` 
  - Pero en **tablas separadas**. 

--- 
## Datos 
- Una **dependencia transitiva** ocurre cuando un **_atributo no clave_** **depende de la clave primaria** a _través de otro atributo no clave_. 

- Preguntate esto: **_¿Existe un atributo que depende de otro atributo que no es la clave primaria?_**

- Una **dependencia transitiva** ocurre cuando la **clave primaria** determina un **atributo intermedio**, y ese **atributo intermedio** _(que no es clave)_ **determina otro atributo**.

---
## Comparación Rápida con lo que ya Sabes 

| Tipo                   | Definición                                          |
| ---------------------- | ----------------------------------------------------|
| Dependencia funcional  | Una dependencia funcional `A → B` significa que para cada valor de **A** existe un único valor de **B** asociado.                   |
| Dependencia parcial    | Ocurre cuando un atributo **no clave depende** de solo una **parte de una clave primaria compuesta**, en **lugar de depender de toda la clave.**  |
| Dependencia transitiva | Ocurre cuando un atributo no clave depende de la clave primaria a través de otro atributo no clave.  `PK -> A \| A -> B \| PK -> B  ` **Indirectamente.**                                                            |


| Tipo                   | Problema                                 |
| ---------------------- | ---------------------------------------- |
| Dependencia funcional  | relación correcta base                   |
| Dependencia parcial    | depende solo de parte de la PK compuesta |
| Dependencia transitiva | depende de otro atributo intermedio      |
