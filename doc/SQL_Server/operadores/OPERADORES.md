# Blue Lock SQL Project  
## Operadores en _SQL_ 
- Tenemos **DOS** tipos de `operadores` en `SQL`, uno de `comparación` y otro de `lógica`. 

---

## Operadores de _Comparación_ 
- Los `operadores de comparación` son aquellos que _evaluan_ o mejor dicho **_comparan_** directamente con el valor y retornan un `booleano`.  

**Entre ellos se encuentran:** 
| **Símbolo** | **Significado**   | **Ejemplo**  | **Detalles** |
|-------------|-------------------|--------------|--------------|
| `=`         | Igual             | `A = B`      | Compara si ambos valores son iguales. |
| `>`         | Mayor que         | `A > B`      | Compara si el valor de la izquierda es mayor que el de la derecha. |
| `<`         | Menor que         | `A < B`      | Compara si el valor de la izquierda es menor que el de la derecha. |
| `>=`        | Mayor o igual que | `A >= B`     | Compara si el valor es mayor o igual al otro. |
| `<=`        | Menor o igual que | `A <= B`     | Compara si el valor es menor o igual al otro. |
| `<>`        | Distinto de        | `A <> B`    | Operador estándar SQL para indicar desigualdad. |
| `!=`        | Distinto de        | `A != B`     | **No pertenece al estándar SQL**, pero SQL Server lo acepta como sinónimo de `<>`. |
| `IN`        | Dentro de un conjunto | `A IN (1, 2, 3)` | Evalúa si el valor pertenece a un conjunto de valores. |
| `ANY`       | Cumple para al menos uno | `A > ANY (conjunto)` | La condición debe cumplirse para **al menos uno** de los valores devueltos por la subconsulta. |
| `ALL`       | Cumple para todos | `A > ALL (conjunto)` | La condición debe cumplirse para **todos** los valores devueltos por la subconsulta. |
| `EXISTS`    | Verifica si una subconsulta devuelve filas | `WHERE EXISTS (SELECT ...)` | Devuelve `TRUE` si la subconsulta retorna **al menos una fila**. |
| `BETWEEN`   | Dentro de un rango | `A BETWEEN 20 AND 45` | El rango es **inclusivo**, equivalente a `A >= 20 AND A <= 45`. |
| `IS NULL`   | Es nulo | `A IS NULL` | Verifica si el valor es `NULL`. Para comprobar que **no** es nulo se utiliza `IS NOT NULL`. |
| `LIKE`      | Coincidencia de patrones | `A LIKE 'JUAN%'` | Utiliza **comodines** para buscar patrones. `%` representa **cero o más caracteres** y `_` representa **exactamente un carácter**. |

--- 
## Operadores _Lógicos_ 
- Los `operadores lógicos` son aquellos que trabajan directamente con **_valores_** `booleanos` **_(TRUE or False / 1 or 0)_** y dan como resultado un `booleano`. 

**Entre ellos se encuentran:** 
| **Operador** | **Significado** | **Ejemplo**  | **Detalles**|
|:------------:|-----------------|------------------------------|----------------|
| `AND`        | Y               | `A > 10 AND B < 20`          | Devuelve `TRUE` únicamente cuando **ambas** condiciones son `TRUE`.                             |
| `OR`         | O               | `A > 10 OR B < 20`           | Devuelve `TRUE` cuando **al menos una** de las condiciones es `TRUE`.                           |
| `NOT`        | Negación        | `NOT (A > 10)`               | Invierte el resultado de una condición: `TRUE → FALSE` y `FALSE → TRUE`.                     |

--- 
## Operadores _propios de SQL Server_ 
- Además de los operadores estándar, SQL Server agrega algunos muy útiles: 

| **Operador** | **Significado** | **Ejemplo** | **Detalles** |
|:------------:|-----------------|-------------|--------------|
| `+`          | Concatenación de texto | `'Hola' + ' ' + 'mundo'` | Propio del lenguaje en T-SQL. **OJO:** si un operando es `NULL`, el resultado es `NULL`. Para evitarlo usa `CONCAT()` o `CONCAT_WS()`. |
| `%`          | Módulo (resto) | `A % 3` | Devuelve el resto de la división. En SQL Server **no existe** la función `MOD()`. |
| `LIKE` con `[ ]` | Coincidencia por rango de caracteres | `A LIKE '[A-C]%'` | `[A-C]` = un carácter entre A y C; `[^A-C]` = cualquier carácter **fuera** de ese rango. |
| `TRY_CAST` / `TRY_CONVERT` | Conversión que **no falla** | `TRY_CAST('abc' AS INT)` | Devuelve `NULL` si la conversión no es posible, en lugar de lanzar un error. |
| `IS [NOT] DISTINCT FROM` | Comparación segura con `NULL` | `A IS DISTINCT FROM B` | Disponible desde **SQL Server 2022**. En versiones anteriores se simula con `EXISTS` o comparando `NULL`. |
| `COLLATE`    | Cambiar la collation de una comparación | `A COLLATE Latin1_General_CS_AS = 'Juan'` | Permite forzar comparación sensible a mayúsculas/minúsculas o a tildes. |
| `::`         | **No existe** en SQL Server | — | Usa `CAST(valor AS tipo)` o `CONVERT(tipo, valor)`. |

> **OJO con `LIKE`:** en SQL Server `LIKE` **no distingue mayúsculas de minúsculas** por defecto, porque depende de la *collation* de la columna o de la base. No existe `ILIKE` (eso es de PostgreSQL): `'juan' LIKE 'JUAN%'` ya devuelve `TRUE` con la collation habitual `..._CI_AS`. Si necesitás que **sí** distinga, aplicá `COLLATE Latin1_General_CS_AS`.

> **OJO con las regex:** SQL Server **no tiene** el operador `~` ni `SIMILAR TO` (eso es de PostgreSQL). Se trabaja con `LIKE`, con `PATINDEX()` o con expresiones regulares de .NET vía CLR.

--- 
## Imágenes Explicativas 

![Operadores SQL BLUE LOCK](../../../img/Operadores_SQL_BLUE_LOCK.png)