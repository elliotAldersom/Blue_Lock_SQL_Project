# Blue Lock SQL Project  
## Funciones _Matemáticas_ 

- Las `funciones matemáticas` en `SQL` nos permiten hacer calculos **_matemáticos_**, como hallar un **_promeido_** de sueldo, **_sumar_** ciertos números, por ende dedicademos un espacio a este apartado tan importante. 

## Operadores _Matemáticos_ 
- Estos son los `Operadores Matemáticos`  que tenemos en `SQL`. 
  - Suma `(+)` 
  - Resta `(-)`
  - Multiplicación `(*)`
  - División `(/)`
  - Módulo o Resto `(%)`

--- 
## Funciones _Matemáticas_ 

| Función    | Definición                  | Sentencia           | Salida | 
|------------|-----------------------------|---------------------|--------| 
| ABS(num)   | Valor Absoluto de un número | `select  abs(-102)` | 102    |
| ROUND(a, b) | Redondea `a` con `b` decimales | `select round(59.789, 2)` | 59.79 |
| CEIL(num) OR CEILING(num) | Redondea hacia arriba | `select ceil(10.1)` | 11 | 
| FLOOR(num) | Redondea hacia abajo _(como si quitara los decimales)_ | `select floor(15.9)` | 15 | 
| POW(num, exp) OR POWER(num, exp) | Potencia | `select pow(2, 3)` | 8 | 
|SQRT(num) | Raíz cuadrada | `select sqrt(9) ` | 3 |
| MOD(dividendo, divisor) | Residuo de la división, es equivalente al **%** | `select mod(10, 3)` | 1 | 
| RAND() | RANDOM,  número pseudoaleatorio donde **0 <= x < 1** | `select rand()` | 0.231232 | 
|

### Random _RAND()_  
-  Fórmula General de **Números aleatorio enteros**  **=>** `FLOOR(RAND() * (max - min + 1)) + min` 
    EJM: 
      ```SQL 
      select floor(rand() * (120 - 50 + 1) + 50);
      ```

-  Fórmula General de **Números aleatorio decimales**  **=>** `ROUND((RAND() * (max - min + 1)), N) + min` 
    EJM: 
      ```SQL 
      select round((rand() * (120 - 50 + 1) + 50), 2);
      ```

--- 