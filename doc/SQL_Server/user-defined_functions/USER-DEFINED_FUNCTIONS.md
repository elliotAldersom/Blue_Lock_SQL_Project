# Blue Lock SQL Project
# Funciones Definidas por el Usuario (User-Defined Functions - UDF) en SQL Server

## ¿Qué son?

Una **Función Definida por el Usuario (User-Defined Function o UDF)** es una función creada por el programador para reutilizar lógica dentro de la base de datos.

Su funcionamiento es similar a las funciones incorporadas de SQL Server como:

- `UPPER()`
- `LOWER()`
- `ROUND()`
- `GETDATE()`
- `CONCAT()`

La diferencia es que estas funciones las crea el propio desarrollador.

Por ejemplo, después de crear una función llamada `calcular_igv`, podremos escribir:

```sql
SELECT dbo.calcular_igv(100);
```

**o incluso:**

```sql
SELECT
    nombre,
    precio,
    dbo.calcular_igv(precio)
FROM productos;
```

> **OJO:** en SQL Server toda función propia se llama con **esquema + nombre** (`dbo.calcular_igv`). Si no ponés el esquema, el motor lo busca primero en tu esquema por defecto y **cada llamada puede resolverse distinto según el usuario**. Siempre usá `dbo.`.

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
SELECT dbo.calcular_igv(precio)
FROM productos;
```

La lógica queda centralizada y es más fácil de mantener.

---

# Sintaxis general

En SQL Server **no existe `LANGUAGE plpgsql` ni `$$ ... $$`**: el cuerpo va después de `AS`, entre `BEGIN ... END`.

```sql
CREATE FUNCTION dbo.nombre_funcion(@parametros tipo)
RETURNS tipo
AS
BEGIN

    -- instrucciones
    RETURN valor;

END;
```

Ejemplo:

```sql
CREATE FUNCTION dbo.calcular_igv(@precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN

    RETURN @precio * 0.18;

END;
```

---

# ¿Por qué se usa `GO` en SQL Server?

En MySQL se usa `DELIMITER` para que el cliente no corte la función en el primer `;`. **SQL Server no tiene `DELIMITER`** y no necesita dollar-quoting: el bloque `BEGIN ... END` agrupa las instrucciones.

Lo que sí necesitás es **`GO`** al terminar el lote, para que el cliente (SSMS, `sqlcmd`, Azure Data Studio) envíe la función completa antes de la siguiente sentencia:

```sql
CREATE FUNCTION dbo.ejemplo()
RETURNS INT
AS
BEGIN
    DECLARE @total INT;
    SET @total = 10;
    RETURN @total;
END;
GO
```

> **Importante:** `DELIMITER` **no existe** en SQL Server. Si venís de MySQL, cambiá `DELIMITER //` por nada (o `GO` al final del lote) y `END//` por `END;`.

> **OJO:** `GO` no es T-SQL, es del cliente. Si ejecutás la sentencia por una librería (por ejemplo `pyodbc`), **no** incluyas `GO`: la librería no lo entiende.

---

# Parámetros

Los parámetros funcionan igual que en cualquier lenguaje de programación.

En SQL Server **siempre empiezan con `@`**.

```sql
CREATE FUNCTION dbo.sumar(@a INT, @b INT)
RETURNS INT
AS
BEGIN
    RETURN @a + @b;
END;
GO
```

**Aquí:**

- `@a` es un parámetro.
- `@b` es otro parámetro.

Pueden usarse dentro de la función.

**Uso:**

```sql
SELECT dbo.sumar(10,5);
```

**Resultado:**

```
15
```

> **OJO:** a diferencia de PostgreSQL, en SQL Server **no hay ambigüedad** entre un parámetro y una columna, porque el parámetro lleva `@`. Igual conviene usar nombres claros.

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

SQL Server tiene **tres tipos de funciones** y cada una declara el retorno distinto:

| Tipo | Cómo declara el retorno | Cuándo usarla |
|------|-------------------------|----------------|
| **Escalar** | `RETURNS INT` | Devuelve **un solo valor**. |
| **Tabla en línea** (*inline TVF*) | `RETURNS TABLE` | Devuelve filas desde un **único `SELECT`**. Es la más rápida. |
| **Tabla de varias sentencias** (*multi-statement TVF*) | `RETURNS @t TABLE (id INT, nombre VARCHAR(100))` | Devuelve filas construyendo una tabla variable. Más lenta. |

```sql
-- Tabla en línea: UN SOLO SELECT, sin BEGIN ... END
CREATE FUNCTION dbo.productos_caros()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM products WHERE price > 100
);
```

```sql
-- Tabla de varias sentencias: necesita tabla variable y BEGIN ... END
CREATE FUNCTION dbo.productos_por_rango(@min DECIMAL(10,2), @max DECIMAL(10,2))
RETURNS @resultado TABLE (
    productid INT,
    nombre    VARCHAR(100),
    price     DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @resultado
    SELECT productid, productname, price
    FROM products
    WHERE price BETWEEN @min AND @max;

    RETURN;
END;
```

> **OJO:** en SQL Server **no existe** `RETURNS SETOF tabla` (eso es de PostgreSQL). Para devolver filas se usa `RETURNS TABLE` o `RETURNS @variable TABLE (...)`.

---

# RETURN

Es la instrucción que devuelve el resultado.

**Ejemplo:**

```sql
RETURN @precio * 0.18;
```

En una función **escalar**, `RETURN` devuelve el valor y **termina la función en ese punto**. En una función **de tabla**, `RETURN` sin valor solo termina el cuerpo (las filas ya se devolvieron con `INSERT INTO @resultado ...`).

```sql
CREATE FUNCTION dbo.productos_caros_fn()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM products WHERE price > 100
);
```

```sql
-- Una función de tabla se consulta en el FROM, como si fuera una tabla
SELECT * FROM dbo.productos_caros_fn();
```

> **OJO:** a diferencia de PostgreSQL, SQL Server **no tiene `RETURN QUERY`**. Para una función de tabla se escribe el `SELECT` directamente en el `RETURN` (inline) o se hace `INSERT INTO @tabla SELECT ...` (multi-sentencia).

---

# Determinismo: `WITH SCHEMABINDING`

En MySQL se usa `DETERMINISTIC` / `NOT DETERMINISTIC`. **En SQL Server no existe esa palabra** y tampoco existe la volatilidad (`IMMUTABLE` / `STABLE` / `VOLATILE`) de PostgreSQL.

SQL Server trabaja con dos ideas distintas:

| Concepto | Qué significa | Cómo se declara |
|----------|---------------|-----------------|
| **Determinista** | Siempre devuelve lo mismo para los mismos argumentos. | No se declara: se **deduce** del cuerpo. |
| **`WITH SCHEMABINDING`** | La función queda **atada al esquema** de las tablas que usa: no se pueden borrar ni cambiar esas columnas mientras exista. Permite indexar columnas calculadas y vistas indexadas. | Se escribe después del nombre. |

**Función determinista:**

```sql
CREATE FUNCTION dbo.cuadrado(@numero INT)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN

    RETURN @numero * @numero;

END;
```

**Si se llama:**

```sql
SELECT dbo.cuadrado(4);
```

**Siempre devolverá:**

```
16
```

Nunca cambiará.

---

## Ejemplo de función **no determinista**

```sql
CREATE FUNCTION dbo.hora_actual()
RETURNS DATETIME2
AS
BEGIN

    RETURN SYSDATETIME();

END;
```

**Cada vez que se ejecuta:**

```sql
SELECT dbo.hora_actual();
```

obtendrá una hora distinta.

Por eso **no es determinista** y no se puede usar en una columna calculada persistida ni en un índice.

> **OJO:** `GETDATE()` / `SYSDATETIME()` **no son deterministas**. `DATETIME` no es el tipo moderno: se recomienda `DATETIME2`.

---

# Otras características

## `INLINE = ON` / `OFF` _(SQL Server 2019+)_

Le indica al optimizador si puede **expandir** (inline) el cuerpo de una función escalar UDF dentro de la consulta como si fuera una expresión.

```sql
CREATE FUNCTION dbo.calcular_igv(@precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
WITH INLINE = ON
AS
BEGIN
    RETURN @precio * 0.18;
END;
```

> **OJO:** antes de SQL Server 2019, una función escalar **bloqueaba el paralelismo** de toda la consulta y se ejecutaba fila por fila. Por eso se recomienda usar **funciones de tabla en línea** cuando se consultan tablas.

---

## `WITH EXECUTE AS` _(equivalente a `SECURITY DEFINER`)_

- Por defecto, la función se ejecuta con los permisos de quien la llama (*security invoker*, el comportamiento normal).
- `WITH EXECUTE AS OWNER` (o `'usuario'`) hace que se ejecute con los permisos del dueño. Se usa con cuidado, porque puede escalar privilegios.

```sql
CREATE FUNCTION dbo.mi_funcion()
RETURNS INT
WITH EXECUTE AS OWNER
AS
BEGIN
    RETURN 1;
END;
```

> **OJO:** en SQL Server **no existe** la palabra `SECURITY DEFINER` (eso es de PostgreSQL). El equivalente es `WITH EXECUTE AS`.

---

## `PARALLEL SAFE` / `RESTRICTED` / `UNSAFE`

**No existe** en SQL Server (eso es de PostgreSQL). SQL Server no permite declarar cómo se comporta la función en paralelo. Lo que hace es:

- Las funciones **de tabla en línea** participan del paralelismo normalmente.
- Las funciones **escalares** bloqueaban el paralelismo antes de 2019; desde 2019 el motor puede "inlinearlas" y el problema se reduce.
- Las funciones **de tabla de varias sentencias** tienen un costo estimado fijo y son las más lentas.

> **Nota:** SQL Server **no usa** `READS SQL DATA`, `CONTAINS SQL` ni `MODIFIES SQL DATA` (eso es de MySQL). Esas categorías no existen en T-SQL.

---

# Ejemplo completo

```sql
CREATE FUNCTION dbo.calcular_descuento
(
    @precio     DECIMAL(10,2),
    @porcentaje DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN

    RETURN @precio - (@precio * @porcentaje / 100);

END;
GO
```

**Uso:**

```sql
SELECT dbo.calcular_descuento(200,15);
```

**Resultado:**

```
170.00
```

---

# Funciones que consultan tablas

Las funciones también pueden leer información.

```sql
CREATE FUNCTION dbo.obtener_precio(@id_producto INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @precio_producto DECIMAL(10,2);   -- DECLARAR VARIABLE

    SELECT @precio_producto = precio            -- ALMACENAR VALOR DEL SELECT EN LA VARIABLE
    FROM productos
    WHERE id = @id_producto;

    RETURN @precio_producto;

END;
```

**Uso:**

```sql
SELECT dbo.obtener_precio(3);
```

> **OJO:** en SQL Server la asignación dentro del `SELECT` va con `@variable = columna` (no con `INTO`, que es de SQL Server solo para crear tablas temporales). Si el `SELECT` no encuentra filas, la variable queda en `NULL`. Si encuentra más de una, **no lanza error**: toma el último valor. Es una diferencia importante con PostgreSQL.

---

# Cómo usar una función

Puede utilizarse igual que cualquier función incorporada.

```sql
SELECT dbo.calcular_igv(150);
```

También dentro de consultas:

```sql
SELECT
    nombre,
    dbo.calcular_igv(precio)
FROM productos;
```

O incluso en una cláusula `WHERE`:

```sql
SELECT *
FROM productos
WHERE dbo.calcular_igv(precio) > 20;
```

> **OJO:** una función **de tabla** no se llama con `SELECT dbo.fn()`. Se consume desde el `FROM`, y si recibe la columna de otra tabla, se combina con `CROSS APPLY` / `OUTER APPLY`:
> ```sql
> SELECT p.nombre, f.total
> FROM productos AS p
> CROSS APPLY dbo.ventas_por_producto(p.productid) AS f;
> ```

---

# Usar la función desde Python

La función ya está almacenada en `SQL Server`.

`Python` únicamente la invoca mediante `SQL`, usando el driver **`pyodbc`** (o `pymssql`).

```python
import pyodbc

conexion = pyodbc.connect(
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=tienda;"
    "UID=sa;"
    "PWD=1234;"
    "TrustServerCertificate=yes;"
)

cursor = conexion.cursor()

cursor.execute("""
SELECT
    nombre,
    precio,
    dbo.calcular_igv(precio) AS igv
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

El cálculo lo hace `SQL Server`.

`Python` simplemente recibe el resultado.

---

# ¿Cuándo crear una función en SQL Server?

**Es recomendable cuando:**

- Se reutiliza el mismo cálculo muchas veces.
- La lógica pertenece a la base de datos.
- Se desea evitar duplicar código.
- El cálculo puede utilizarse desde distintas aplicaciones (`PHP`, `Python`, `Java`, `C#`, etc.).

**No es recomendable cuando:**

- La lógica depende de la interfaz de usuario.
- Se necesita acceder a `APIs` externas.
- Se deben realizar procesos complejos que no pertenecen a la base de datos.
- La función va a usarse sobre **millones de filas**: las funciones escalares son mucho más lentas que escribir la expresión directamente.

---

# Diferencia entre una Función y un Procedimiento

| Función | Procedimiento |
|----------|---------------|
| Devuelve un valor con `RETURN` (o filas con `RETURNS TABLE`). | No está obligado a devolver un valor; puede devolver un código de estado. |
| Puede utilizarse dentro de un `SELECT`. | Se ejecuta mediante `EXEC`. |
| Está pensada para cálculos. | Está pensado para procesos completos. |
| Siempre tiene `RETURNS`. | No utiliza `RETURNS` (usa parámetros `OUTPUT`). |
| **No puede** modificar datos de la base (`INSERT`/`UPDATE`/`DELETE` sobre tablas). | **Sí puede** modificar datos. |
| **No puede** usar `BEGIN TRANSACTION`/`COMMIT`/`ROLLBACK`. | **Sí puede** usar `BEGIN TRANSACTION`/`COMMIT`/`ROLLBACK`. |
| Se crea con `CREATE FUNCTION`. | Se crea con `CREATE PROCEDURE`. |

**Ejemplo de función:**

```sql
SELECT dbo.calcular_igv(precio)
FROM productos;
```

**Ejemplo de procedimiento:**

```sql
EXEC registrar_venta @id_producto = 3, @cantidad = 2;
```

---

# Eliminar una función

```sql
DROP FUNCTION IF EXISTS dbo.calcular_igv;
```

> **OJO:** en SQL Server **no hace falta indicar los tipos de los parámetros** (eso es de PostgreSQL). El nombre de la función es único dentro del esquema, así que `DROP FUNCTION dbo.calcular_igv;` alcanza.

---
