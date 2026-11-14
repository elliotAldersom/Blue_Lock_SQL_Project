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

> **OJO (PostgreSQL):** la división entre enteros devuelve un entero. Si querés un resultado decimal, convertí al menos uno de los operandos: `7 / 2` devuelve `3`, pero `7::NUMERIC / 2` devuelve `3.5`.

--- 
## Funciones _Matemáticas_ 

| Función    | Definición                  | Sentencia           | Salida | 
|------------|-----------------------------|---------------------|--------| 
| ABS(num)   | Valor Absoluto de un número | `select abs(-102)` | 102    |
| ROUND(a, b) | Redondea `a` con `b` decimales | `select round(59.789, 2)` | 59.79 |
| CEIL(num) OR CEILING(num) | Redondea hacia arriba | `select ceil(10.1)` | 11 | 
| FLOOR(num) | Redondea hacia abajo _(como si quitara los decimales)_ | `select floor(15.9)` | 15 | 
| POW(num, exp) OR POWER(num, exp) | Potencia | `select pow(2, 3)` | 8 | 
| SQRT(num) | Raíz cuadrada | `select sqrt(9)` | 3 |
| MOD(dividendo, divisor) | Residuo de la división, es equivalente al **%** | `select mod(10, 3)` | 1 | 
| RANDOM() | Número pseudoaleatorio donde **0 <= x < 1** | `select random()` | 0.231232 | 
| TRUNC(num, b) | Trunca `num` a `b` decimales _(no redondea)_ | `select trunc(59.789, 2)` | 59.78 |
| SIGN(num) | Devuelve `-1`, `0` o `1` según el signo | `select sign(-42)` | -1 |
| PI() | Valor de π | `select pi()` | 3.14159265358979 |

> **OJO:** en PostgreSQL la función aleatoria es **`random()`**, no `RAND()`. `RAND()` es de MySQL y **no existe** en PostgreSQL.

### Random _RANDOM()_  
-  Fórmula General de **Números aleatorios enteros**  **=>** `FLOOR(RANDOM() * (max - min + 1)) + min` 
    EJM: 
      ```SQL 
      select floor(random() * (120 - 50 + 1) + 50);
      ```

-  Fórmula General de **Números aleatorios decimales**  **=>** `ROUND((RANDOM() * (max - min + 1)), N) + min` 
    EJM: 
      ```SQL 
      select round((random() * (120 - 50 + 1) + 50), 2);
      ```

> **Tip PostgreSQL:** si necesitás un entero aleatorio en un rango, también existe `random(min, max)` en PostgreSQL 17+, que devuelve un número en ese rango.

--- 
