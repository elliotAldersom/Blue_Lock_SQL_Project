# Blue Lock SQL Project
# Funciones Definidas por el Usuario (User-Defined Functions - UDF) en PostgreSQL

## ¿Qué son?

Una **Función Definida por el Usuario (User-Defined Function o UDF)** es una función creada por el programador para reutilizar lógica dentro de la base de datos.

Su funcionamiento es similar a las funciones incorporadas de PostgreSQL como:

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
LANGUAGE plpgsql
AS $$
BEGIN

    instrucciones;

    RETURN valor;

END;
$$;
```

Ejemplo:

```sql
CREATE FUNCTION calcular_igv(precio NUMERIC(10,2))
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN precio * 0.18;

END;
$$;
```

---

# ¿Por qué se usa `$$ ... $$` en PostgreSQL?

En MySQL se usa `DELIMITER` para que el cliente no corte la función en el primer `;`. **PostgreSQL no tiene `DELIMITER`**: usa **dollar-quoting**.

El cuerpo de la función se encierra entre `$$ ... $$` (o `$etiqueta$ ... $etiqueta$`). Todo lo que está dentro se trata como un único texto y los `;` internos **no** cortan la sentencia.

```sql
CREATE FUNCTION ejemplo()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    total INTEGER;
BEGIN
    total := 10;
    RETURN total;
END;
$$;
```

> **Importante:** `DELIMITER` no existe en PostgreSQL. Si venís de MySQL, cambiá `DELIMITER //` por `AS $$` y el `END//` por `END; $$;`.

Si el cuerpo ya contiene `$$`, usá otra etiqueta:

```sql
CREATE FUNCTION ejemplo()
RETURNS void
LANGUAGE plpgsql
AS $func$
BEGIN
    RAISE NOTICE 'Hola';
END;
$func$;
```

---

# Parámetros

Los parámetros funcionan igual que en cualquier lenguaje de programación.

```sql
CREATE FUNCTION sumar(a INTEGER, b INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN a + b;
END;
$$;
```

**Aquí:**

- `a` es un parámetro.
- `b` es otro parámetro.

Pueden usarse dentro de la función.

**Uso:**

```sql
SELECT sumar(10,5);
```

**Resultado:**

```
15
```

> **OJO:** igual que en los procedimientos, si el parámetro se llama igual que una columna de una tabla usada dentro del cuerpo, PostgreSQL lanza un error de ambigüedad. Usá prefijos como `p_`.

---

# RETURNS

Indica el tipo de dato que devolverá la función.

**Ejemplo:**

```sql
RETURNS INTEGER
```

**o**

```sql
RETURNS VARCHAR(100)
```

**o**

```sql
RETURNS NUMERIC(10,2)
```

**Es obligatorio especificarlo.**

PostgreSQL además permite devolver **conjuntos de filas**:

```sql
RETURNS TABLE(id INTEGER, nombre TEXT)
```

o

```sql
RETURNS SETOF productos
```

---

# RETURN

Es la instrucción que devuelve el resultado.

**Ejemplo:**

```sql
RETURN precio * 0.18;
```

Una función siempre debe devolver un valor mediante `RETURN` (o `RETURN QUERY` si devuelve filas).

```sql
CREATE FUNCTION productos_caros()
RETURNS SETOF productos
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM products WHERE price > 100;
END;
$$;
```

```sql
SELECT * FROM productos_caros();
```

---

# Volatilidad: `IMMUTABLE`, `STABLE` y `VOLATILE`

En MySQL se usa `DETERMINISTIC` / `NOT DETERMINISTIC`. **En PostgreSQL no existe esa palabra**: se usa la **volatilidad**, que además le dice al planificador cómo optimizar la función.

| Categoría | Significado | Ejemplo |
|-----------|-------------|---------|
| `IMMUTABLE` | Siempre devuelve lo mismo para los mismos argumentos y no lee la base. | `cuadrado(4)` |
| `STABLE` | Dentro de una misma consulta devuelve lo mismo, pero puede depender de la base. | `obtener_precio(3)` |
| `VOLATILE` | Puede cambiar en cada llamada. Es el **default**. | `NOW()`, `RANDOM()` |

**Función inmutable:**

```sql
CREATE FUNCTION cuadrado(numero INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN

    RETURN numero * numero;

END;
$$;
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

---

## Ejemplo de función `VOLATILE`

```sql
CREATE FUNCTION hora_actual()
RETURNS TIMESTAMP
LANGUAGE plpgsql
VOLATILE
AS $$
BEGIN

    RETURN NOW();

END;
$$;
```

**Cada vez que se ejecuta:**

```sql
SELECT hora_actual();
```

obtendrá una hora distinta.

Por eso es **volátil**.

> **OJO:** `NOW()` en PostgreSQL devuelve `TIMESTAMPTZ` (fecha y hora con zona horaria). `DATETIME` **no existe** en PostgreSQL; se usa `TIMESTAMP` o `TIMESTAMPTZ`.

---

# Otras características

Además de la volatilidad, PostgreSQL tiene otras opciones para indicar el comportamiento de la función.

## `STRICT`

Si algún argumento es `NULL`, la función **no se ejecuta** y devuelve `NULL`.

```sql
CREATE FUNCTION dividir(a NUMERIC, b NUMERIC)
RETURNS NUMERIC
LANGUAGE plpgsql
IMMUTABLE
STRICT
AS $$
BEGIN
    RETURN a / b;
END;
$$;
```

---

## `SECURITY DEFINER` / `SECURITY INVOKER`

- `SECURITY INVOKER` (default): la función se ejecuta con los permisos de quien la llama.
- `SECURITY DEFINER`: se ejecuta con los permisos de quien la creó. Se usa con cuidado, porque puede escalar privilegios.

```sql
CREATE FUNCTION mi_funcion()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- ...
END;
$$;
```

---

## `PARALLEL SAFE` / `PARALLEL RESTRICTED` / `PARALLEL UNSAFE`

Le indica al planificador si la función puede ejecutarse en paralelo.

```sql
CREATE FUNCTION calcular_igv(precio NUMERIC)
RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
AS $$
    SELECT precio * 0.18;
$$;
```

> **Nota:** PostgreSQL **no usa** `READS SQL DATA`, `CONTAINS SQL`, `NO SQL` ni `MODIFIES SQL DATA` (eso es de MySQL). Se reemplazan por la volatilidad (`STABLE`, `IMMUTABLE`, `VOLATILE`) y por `PARALLEL`.

---

# Ejemplo completo

```sql
CREATE FUNCTION calcular_descuento
(
    precio NUMERIC(10,2),
    porcentaje NUMERIC(5,2)
)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN

    RETURN precio - (precio * porcentaje / 100);

END;
$$;
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
CREATE FUNCTION obtener_precio(p_id_producto INTEGER)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    precio_producto NUMERIC(10,2);  -- DECLARAR VARIABLE
BEGIN

    SELECT precio
    INTO precio_producto            -- ALMACENAR VALOR DEL SELECT EN LA VARIABLE
    FROM productos
    WHERE id = p_id_producto;

    RETURN precio_producto;

END;
$$;
```

**Uso:**

```sql
SELECT obtener_precio(3);
```

> **OJO:** si el `SELECT ... INTO` no encuentra filas, la variable queda en `NULL`. Si encuentra más de una, PostgreSQL lanza un error. Para varios resultados se usa `RETURN QUERY` o un cursor.

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

La función ya está almacenada en `PostgreSQL`.

`Python` únicamente la invoca mediante `SQL`, usando el driver **`psycopg2`** (o `psycopg` 3).

```python
import psycopg2

conexion = psycopg2.connect(
    host="localhost",
    user="postgres",
    password="1234",
    dbname="tienda"
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

El cálculo lo hace `PostgreSQL`.

`Python` simplemente recibe el resultado.

---

# ¿Cuándo crear una función en PostgreSQL?

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
| Devuelve un valor mediante `RETURN` (o filas con `RETURN QUERY`). | No está obligado a devolver un valor. |
| Puede utilizarse dentro de un `SELECT`. | Se ejecuta mediante `CALL`. |
| Está pensada para cálculos. | Está pensado para procesos completos. |
| Siempre tiene `RETURNS`. | No utiliza `RETURNS`. |
| **No puede** hacer `COMMIT`/`ROLLBACK`. | **Sí puede** hacer `COMMIT`/`ROLLBACK`. |
| Se crea con `CREATE FUNCTION`. | Se crea con `CREATE PROCEDURE` (PostgreSQL 11+). |

**Ejemplo de función:**

```sql
SELECT calcular_igv(precio)
FROM productos;
```

**Ejemplo de procedimiento:**

```sql
CALL registrar_venta(3,2);
```

---

# Eliminar una función

```sql
DROP FUNCTION calcular_igv(NUMERIC);
```

> **OJO:** en PostgreSQL hay que indicar los tipos de los parámetros si hay sobrecargas. `DROP FUNCTION nombre;` a secas puede fallar.

---
