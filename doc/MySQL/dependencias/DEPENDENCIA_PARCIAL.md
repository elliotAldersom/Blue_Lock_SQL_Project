# Blue Lock SQL Project  
## Dependencia _Parcial_ 

- Antes de empezar hay que tener en cuenta que: 
  - La **dependencia parcial** es un tipo especial de **dependencia funcional**. 
  - No es un concepto separado. Nace a partir de las **dependencias funcionales**. 
--- 

## ¿Qués es una _Dependencia Parcial_? 
- Una **_dependencia parcial_** ocurre cuando un **atributo** depende solamente de una parte de una `clave primaria compuesta` y no de toda la clave.
--- 

## Primero... ¿Qué es una _Clave Compuesta_? 
- Es una `clave primaria` formada por más de una columna. 

- **EJM:** 

    | id_empleado | idioma  |
    | ----------- | ------- |
    | 1           | Inglés  |
    | 1           | Francés |
    | 2           | Inglés  |

    - **_Aquí:_** `PK= (id_empleado, idioma)` 
    - Porque: 
      - `id_idioma` solo no identifica una fila. 
      - `idioma` solo tampoco. 
      - Juntos si identifican una fila. 
---

- **Ahora Agreguemos más Columnas:** 

    | id_empleado | idioma  | nombre |
    | ----------- | ------- | ------ |
    | 1           | Inglés  | Ana    |
    | 1           | Francés | Ana    |
    | 2           | Inglés  | Juan   |

    - La `clave primaria` sigue siendo: `(id_empleado, idioma)`

**Preguna Importante** 
- ¿_De qué depende `nombre`_? 
- ¿Depende de `(id_empleado, idoma)`? 
- O ¿Solamente de `id_empleado`? 

**Observemos:** 
- `id_empleado = 1`  
- Siempre corresponde a `nombre = Ana` sin importar el **idioma**. 
- Por tanto: `id_empleado -> nombre`

**Aquí Aparece la dependencia parcial** 
- La `clave primaria` es: `(id_empleado, idioma)`
- Pero: `nombre` depende solamente de `id_empleado`
- Y `id_empleado` es solo una parte de la clave. 
- Entonces existe una `dependencia parcial`
- Se escribe así: 
    ```text
    (id_empleado, idioma)
            ↓
          nombre
    ```

- Pero relamente: `id_empleado -> nombre` 

---
## ¿Por qués es un Problema?** 
- Porque genera redundancia 
- **EJM:** 

    | id_empleado | idioma  | nombre |
    | ----------- | ------- | ------ |
    | 1           | Inglés  | Ana    |
    | 1           | Francés | Ana    |
    | 1           | Alemán  | Ana    |

    - El nombre se repite. 
    - Si mañana **Ana** cambia de `nombre` _(supón un error corregido)_.  
    - Debemos de actualizar el `nombre` en varias filas. 
  
--- 
## Solución (2FN) 
- Separar la información 
- **Empleados:** 

    | id_empleado | nombre |
    | ----------- | ------ |
    | 1           | Ana    |
    | 2           | Juan   |

- **Emplado_idioma:**

    | id_empleado | idioma  |
    | ----------- | ------- |
    | 1           | Inglés  |
    | 1           | Francés |
    | 1           | Alemán  |
    | 2           | Inglés  |

    - Ahora `id_empelado -> nombre` 
    - Está en una tabla propia y : `(id_empleado, idioam) => PK` solo almacena la relación `emplado-idioma`. 

--- 
## Regla práctica para detectar dependencias parciales 
- Cuando tengas una `clave compuesta`: `(A, B)` 
- Preguntate: `¿Todas las demás columnas necesitan de A y B para determinarse`. 
- Si encuentras algo como `A -> X` | `B -> X` entonces tienes una dependencia parcial. 
- Porque `X` depende de una parte de la clave, no de toda ella. 

---
## Datos 
- Una `dependencia parcial` ocurre cuando un **_atributo depende funcionalmente_** de **solo una parte de una clave primaria compuesta**, en lugar de depender de toda la clave.

- Si la `clave primaria` no es compuesta, no pueden existir `dependencias parciales`.

--- 
