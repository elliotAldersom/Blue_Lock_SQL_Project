# Blue Lock SQL Project  
## Funciones _Matemáticas_ 

- Las `funciones matemáticas` en `SQL` nos permiten hacer cálculos **_matemáticos_**, como hallar un **_promedio_** de sueldo, **_sumar_** ciertos números, por ende dedicaremos un espacio a este apartado tan importante. 

## Operadores _Matemáticos_ 
- Estos son los `Operadores Matemáticos` que tenemos en `SQL`. 
  - Suma `(+)` 
  - Resta `(-)`
  - Multiplicación `(*)`
  - División `(/)`
  - Módulo o Resto `(%)`

> **OJO (SQL Server):** la división entre **enteros** devuelve un entero, igual que en MySQL. Si querés un resultado decimal, convertí al menos uno de los operandos: `7 / 2` devuelve `3`, pero `CAST(7 AS DECIMAL(10,2)) / 2` devuelve `3.50`. También podés escribir `7.0 / 2`.

> **OJO (división por cero):** en SQL Server `1 / 0` lanza el error **`Divide by zero error encountered.`** y aborta la sentencia. Si el divisor puede ser cero, protegé la operación con `NULLIF(divisor, 0)`: `10 / NULLIF(0, 0)` devuelve `NULL` en lugar de fallar.

--- 
## Funciones _Matemáticas_ 

| Función    | Definición                  | Sentencia           | Salida | 
|------------|-----------------------------|---------------------|--------| 
| ABS(num)   | Valor Absoluto de un número | `select abs(-102)` | 102    |
| ROUND(a, b) | Redondea `a` con `b` decimales | `select round(59.789, 2)` | 59.79 |
| CEILING(num) | Redondea hacia arriba _(en SQL Server **no existe `CEIL`**)_ | `select ceiling(10.1)` | 11 | 
| FLOOR(num) | Redondea hacia abajo _(como si quitara los decimales)_ | `select floor(15.9)` | 15 | 
| POWER(num, exp) | Potencia _(en SQL Server **no existe `POW`**)_ | `select power(2, 3)` | 8 |
| SQRT(num) | Raíz cuadrada | `select sqrt(9)` | 3 |
| `%` | Residuo de la división _(en SQL Server **no existe la función `MOD()`**)_ | `select 10 % 3` | 1 | 
| RAND() | Número pseudoaleatorio donde **0 <= x < 1** | `select rand()` | 0.231232 | 
| ROUND(num, b, 1) | Trunca `num` a `b` decimales _(no redondea)_. El tercer argumento `1` significa "truncar" | `select round(59.789, 2, 1)` | 59.78 |
| SIGN(num) | Devuelve `-1`, `0` o `1` según el signo | `select sign(-42)` | -1 |
| PI() | Valor de π | `select pi()` | 3.14159265358979 |
| SQUARE(num) | Cuadrado de un número | `select square(5)` | 25 |
| EXP(num) | e elevado a `num` | `select exp(1)` | 2.718... |

> **OJO:** en SQL Server la función aleatoria es **`RAND()`**, no `RANDOM()`. `RANDOM()` es de PostgreSQL y **no existe** en SQL Server.

> **OJO (muy importante):** `RAND()` se evalúa **una sola vez por consulta**, no una vez por fila. Si lo usás sobre una tabla, todas las filas reciben el **mismo** número aleatorio. Para un valor distinto por fila se usa `ABS(CHECKSUM(NEWID()))` o `CRYPT_GEN_RANDOM()`.

### Random _RAND()_  
-  Fórmula General de **Números aleatorios enteros**  **=>** `FLOOR(RAND() * (max - min + 1)) + min` 
    EJM: 
      ```SQL 
      select floor(rand() * (120 - 50 + 1) + 50);
      ```

-  Fórmula General de **Números aleatorios decimales**  **=>** `ROUND((RAND() * (max - min + 1)), N) + min` 
    EJM: 
      ```SQL 
      select round((rand() * (120 - 50 + 1) + 50), 2);
      ```

> **Tip SQL Server:** para un entero aleatorio **por fila** en un rango, usá un `CHECKSUM` del `NEWID()`:
> ```sql
> SELECT ABS(CHECKSUM(NEWID())) % (120 - 50 + 1) + 50 AS numero_aleatorio
> FROM empleados;
> ```
> `NEWID()` genera un GUID distinto por fila, así que el módulo también cambia por fila.

--- 
