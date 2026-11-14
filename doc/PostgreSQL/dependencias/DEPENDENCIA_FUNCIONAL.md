# Blue Lock SQL Project  
## Dependencia _Funcional_ 

- Una **dependencia funcional** es una relación entre columnas donde el valor de una columna permite conocer de manera única el valor de otra columna. 

- **Se presenta como:** `A -> B` 

- **Y se lee:**  `A determina a B` | | `B depende funcionalmente de A` 

-  **EJM:** 

    | id_empleado | nombre |
    | ----------- | ------ |
    | 1           | Ana    |
    | 2           | Juan   |
    | 3           | Laura  |

- Si conocemos el valor de `id_empleado`, podemos determinar de manera única el valor de `nombre`. **_Por tanto:_** `id_empleado -> nombre`

---
**¿Qué significa realmente _"determina_"?** 
- Significa que para **un mismo valor de la izquierda**, nunca pueden existir dos valores **distintos a la derecha**.  
---

- **Cumple dependencia _Funcional:_** 

    | id_empleado | nombre |
    | ----------- | ------ |
    | 1           | Ana    |
    | 2           | Juan   |
    | 3           | Laura  |

    - Aqué: `id_empleado -> nombre` es verdadero porque `1 -> Ana` | `2 -> Juan` | `3 -> Laura`. Cada ID tiene un **único nombre**.

- **No cumple dependencia _Funcional:_** 

    | nombre | edad |
    | ------ | ---- |
    | Juan   | 20   |
    | Juan   | 35   |

    - _¿Se cumple?_ => `nombre -> edad` 
    - No se cumple porque `Juan -> 20` | `Juan -> 35` 
    - El `mismo valor de la izquierda` produce `dos valores distinto a la derecha`. 
  
---
**¿Por qué es importante?** 
Porque toda la normalización se basa en ellas. 

- **EJM:** 

    | id_empleado | nombre | id_departamento | nombre_departamento |
    | ----------- | ------ | --------------- | ------------------- |
    | 1           | Ana    | 10              | RRHH                |
    | 2           | Juan   | 20              | Sistemas            |

    - **_Podemos Identificar:_** 
      - `id_empleado -> nombre` 
      - `id_empleado -> id_departamento` 
      - `id_departamento -> nombre_departamento` 

    - Estas dependencias nos permiten detectar: 
      - Dependencias parciales **(2FN)**
      - Dependencias transitivas **(3FN)** 

---
**Dato:** 
- Si: `A -> B` _(A determina a B)_ podemos verlo así también: 
- Para cada valor de **A**, debe existir un único valor de **B** **_ASOCIADO_**
- Esto no implica que los valores de **B** sean únicos en la tabla.
-  Si un mismo valor de **B** está asociado a varios valores distintos de **A**, entonces `B -> A` es falso.

- **_EJM:_**
    | A | B |
    | - | - |
    | 1 | X |
    | 2 | Y |
    | 3 | X |

    - Podemos ver que para **A**, su valor _asociado_ **B** es único. 
    - El valor **X** se repite en la columna **B**, por lo que **B** no es único.
    - Aún así se cumple `A -> B`
---