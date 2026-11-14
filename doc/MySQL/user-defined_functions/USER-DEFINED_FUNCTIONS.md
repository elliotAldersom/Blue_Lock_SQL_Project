# Blue Lock SQL Project
# Funciones Definidas por el Usuario (User-Defined Functions - UDF) en MySQL

## ¿Qué son?

Una **Función Definida por el Usuario (User-Defined Function o UDF)** es una función creada por el programador para reutilizar lógica dentro de la base de datos.

Su funcionamiento es similar a las funciones incorporadas de MySQL como:

- `UPPER()`
- `LOWER()`
- `ROUND()`
- `NOW()`
- `CONCAT()`

La diferencia es que estas funciones las crea el propio desarrollador.

Por ejemplo, después de crear una función llamada `calcular_igv`, podremos escribir:

```sql
SELECT calcular_igv(100);
```

**o incluso:**

```sql
SELECT
    nombre,
    precio,
    calcular_igv(precio)
FROM productos;
```

---

# ¿Para qué sirven?

Permiten encapsular lógica que se utiliza muchas veces.

**Sin funciones:**

```sql
SELECT precio * 0.18
FROM productos;
```

Si esa operación se usa en muchos lugares, terminaremos copiando el mismo cálculo.

Con una función:

```sql
SELECT calcular_igv(precio)
FROM productos;
```

La lógica queda centralizada y es más fácil de mantener.

---

# Sintaxis general

```sql
CREATE FUNCTION nombre_funcion(parametros)
RETURNS tipo
caracteristicas
BEGIN

    instrucciones

    RETURN valor;

END;
```

Ejemplo:

```sql
DELIMITER //

CREATE FUNCTION calcular_igv(precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

    RETURN precio * 0.18;

END//

DELIMITER ;
```

---

# ¿Por qué se usa DELIMITER?

Por defecto `MySQL` considera que cada instrucción termina cuando encuentra un punto y coma (`;`).

Por ejemplo:

```sql
SELECT * FROM productos;
```

El problema aparece cuando una función contiene varias instrucciones:

```sql
BEGIN

    DECLARE total DECIMAL(10,2);

    SET total = precio * 0.18;

    RETURN total;

END;
```

Todas esas instrucciones tienen `;`.

Si no cambiáramos el delimitador, `MySQL` pensaría que la función termina en el primer `;`, generando un error de sintaxis.

Por eso se cambia temporalmente el delimitador:

```sql
DELIMITER //
```

Ahora `MySQL` entiende que la función termina cuando encuentra:

```sql
END//
```

Al finalizar se restaura el delimitador original:

```sql
DELIMITER ;
```

> **Importante:** `DELIMITER` no forma parte del lenguaje SQL. Es una instrucción del cliente de `MySQL` (como `MySQL Workbench` o la consola) para indicar cómo separar sentencias mientras se escribe código con varias instrucciones.

---

# Parámetros

Los parámetros funcionan igual que en cualquier lenguaje de programación.

```sql
CREATE FUNCTION sumar(a INT, b INT)
```

**Aquí:**

- `a` es un parámetro.
- `b` es otro parámetro.

Pueden usarse dentro de la función.

**Ejemplo:**

```sql
RETURN a + b;
```

**Uso:**

```sql
SELECT sumar(10,5);
```

**Resultado:**

```
15
```

---

# RETURNS

Indica el tipo de dato que devolverá la función.

**Ejemplo:**

```sql
RETURNS INT
```

**o**

```sql
RETURNS VARCHAR(100)
```

**o**

```sql
RETURNS DECIMAL(10,2)
```

**Es obligatorio especificarlo.**

---

# RETURN

Es la instrucción que devuelve el resultado.

**Ejemplo:**

```sql
RETURN precio * 0.18;
```

Una función siempre debe devolver un valor mediante `RETURN`.

---

# DETERMINISTIC

- Esta palabra le indica a `MySQL` si la función siempre devuelve el mismo resultado para los mismos parámetros.

- Una función `DETERMINISTIC` siempre devuelve el mismo resultado para los mismos argumentos de entrada.

**Por ejemplo:**

```sql
CREATE FUNCTION cuadrado(numero INT)
RETURNS INT
DETERMINISTIC
BEGIN

    RETURN numero * numero;

END;
```

**Si se llama:**

```sql
SELECT cuadrado(4);
```

**Siempre devolverá:**

```
16
```

Nunca cambiará.

Por eso es **DETERMINISTIC**.

---

## Ejemplo de función NO DETERMINISTIC

```sql
CREATE FUNCTION hora_actual()
RETURNS DATETIME
NOT DETERMINISTIC
BEGIN

    RETURN NOW();

END;
```

**Cada vez que se ejecuta:**

```sql
SELECT hora_actual();
```

obtendrá una hora distinta.

Por eso **NO es determinística**.

---

# Otras características

Además de `DETERMINISTIC`, existen otras opciones para indicar el comportamiento de la función.

## NO DETERMINISTIC

Indica que puede devolver resultados distintos con los mismos parámetros.

**Ejemplo:**

```sql
NOW()
RAND()
UUID()
```

---

## READS SQL DATA

Indica que la función únicamente lee datos.

**Ejemplo:**

```sql
READS SQL DATA
```

Se utiliza cuando dentro de la función hay consultas `SELECT`.

**Ejemplo:**

```sql
SELECT precio
INTO precio_producto
FROM productos;
```

---

## CONTAINS SQL

Indica que la función contiene instrucciones `SQL` pero no necesariamente lee ni modifica tablas.

---

## NO SQL

Indica que la función **no utiliza instrucciones** `SQL`.

**Por ejemplo:**

```sql
RETURN numero * numero;
```

---

## MODIFIES SQL DATA

Indica que la función modifica datos mediante:

- INSERT
- UPDATE
- DELETE

En la práctica, `MySQL` restringe mucho este tipo de operaciones dentro de las funciones. Generalmente, las modificaciones de datos se realizan mediante **procedimientos almacenados (Stored Procedures)**.

---

# Ejemplo completo

```sql
DELIMITER //

CREATE FUNCTION calcular_descuento
(
    precio DECIMAL(10,2),
    porcentaje DECIMAL(5,2)
)

RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

    RETURN precio - (precio * porcentaje / 100);

END//

DELIMITER ;
```

**Uso:**

```sql
SELECT calcular_descuento(200,15);
```

**Resultado:**

```
170.00
```

---

# Funciones que consultan tablas

Las funciones también pueden leer información.

```sql
DELIMITER //

CREATE FUNCTION obtener_precio(id_producto INT)

RETURNS DECIMAL(10,2)

READS SQL DATA

BEGIN

    DECLARE precio_producto DECIMAL(10,2);  -- DECLARAR VARIABLE 

    SELECT precio 
    INTO precio_producto -- ALMACENAR VALOR DEL SELECT EN LA VARIABLE
    FROM productos
    WHERE id = id_producto;

    RETURN precio_producto;

END//

DELIMITER ;
```

**Uso:**

```sql
SELECT obtener_precio(3);
```

---

# Cómo usar una función

Puede utilizarse igual que cualquier función incorporada.

```sql
SELECT calcular_igv(150);
```

También dentro de consultas:

```sql
SELECT
    nombre,
    calcular_igv(precio)
FROM productos;
```

O incluso en una cláusula `WHERE`:

```sql
SELECT *
FROM productos
WHERE calcular_igv(precio) > 20;
```

---

# Usar la función desde Python

La función ya está almacenada en `MySQL`.

`Python` únicamente la invoca mediante `SQL`.

```python
import mysql.connector

conexion = mysql.connector.connect(
    host="localhost",
    user="root",
    password="1234",
    database="tienda"
)

cursor = conexion.cursor()

cursor.execute("""
SELECT
    nombre,
    precio,
    calcular_igv(precio)
FROM productos;
""")

for fila in cursor.fetchall():
    print(fila)

cursor.close()
conexion.close()
```

**Salida:**

```
('Laptop', 3500.00, 630.00)
('Mouse', 80.00, 14.40)
('Monitor', 900.00, 162.00)
```

`Python` nunca calcula el **IGV**.

El cálculo lo hace `MySQL`.

`Python` simplemente recibe el resultado.

---

# ¿Cuándo crear una función en MySQL?

**Es recomendable cuando:**

- Se reutiliza el mismo cálculo muchas veces.
- La lógica pertenece a la base de datos.
- Se desea evitar duplicar código.
- El cálculo puede utilizarse desde distintas aplicaciones (`PHP`, `Python`, `Java`, `C#`, etc.).

**No es recomendable cuando:**

- La lógica depende de la interfaz de usuario.
- Se necesita acceder a `APIs` externas.
- Se deben realizar procesos complejos que no pertenecen a la base de datos.

---

# Diferencia entre una Función y un Procedimiento

| Función | Procedimiento |
|----------|---------------|
| Devuelve un valor mediante `RETURN`. | No está obligado a devolver un valor. |
| Puede utilizarse dentro de un `SELECT`. | Se ejecuta mediante `CALL`. |
| Está pensada para cálculos. | Está pensado para procesos completos. |
| Siempre tiene `RETURNS`. | No utiliza `RETURNS`. |

**Ejemplo de función:**

```sql
SELECT calcular_igv(precio)
FROM productos;
```

**Ejemplo de procedimiento:**

```sql
CALL registrar_venta(3,2);
```