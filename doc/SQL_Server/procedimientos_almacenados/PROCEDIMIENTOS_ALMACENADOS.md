# Blue Lock SQL Project
# 📦 Procedimientos Almacenados _(Stored Procedures)_ en SQL Server

## ¿Qué es un Procedimiento Almacenado?

- Un **Procedimiento Almacenado** (*Stored Procedure*) es un conjunto de instrucciones `SQL` que se **guarda dentro de la BBDD** con un nombre para poder ejecutarlo cuando sea necesario.

- Es similar a una **función o método** de un `lenguaje de programación`, pero en lugar de estar escrito en `Java`, `JavaScript` o `PHP`, está escrito en `SQL` _(y el lenguaje procedimental del SGBD, en SQL Server: **T-SQL**)_.

- En SQL Server los procedimientos existen desde hace muchísimo (a diferencia de PostgreSQL, que los incorporó recién en la versión 11). Se crean con `CREATE PROCEDURE` y se ejecutan con `EXEC`.

---

## ¿Por qué existen?

- Imagina que en un sistema bancario cada transferencia debe realizar:

  1. Restar dinero de una cuenta.
  2. Sumar dinero a otra.
  3. Registrar un movimiento.
  4. Confirmar la transacción.

- Sin **procedimientos almacenados**, la aplicación tendría que enviar **todas esas consultas cada vez**.

- Con un procedimiento simplemente ejecuta:

  ```sql
  EXEC transferir_dinero ...;
  ```

- Toda la lógica ya está almacenada dentro de la base de datos.

---

# ¿Cómo funcionan?

## Crear un procedimiento

```sql
CREATE PROCEDURE mostrar_productos
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Listado de productos';

    SELECT * FROM products;
END;
```

### ¿Qué sucede aquí?

1. Se crea un procedimiento llamado **mostrar_productos**.
2. El cuerpo va **después de `AS`**, entre `BEGIN ... END` (no se usa `LANGUAGE` ni `$$`).
3. Dentro del bloque `BEGIN ... END` se escriben las instrucciones.
4. `SET NOCOUNT ON;` evita el mensaje *"(N rows affected)"* de cada sentencia. Es una buena práctica.
5. El procedimiento queda almacenado en la base de datos.

---

## Ejecutarlo

```sql
EXEC mostrar_productos;
```

o también:

```sql
EXECUTE mostrar_productos;
```

**Resultado:** el procedimiento se ejecuta y muestra el aviso `Listado de productos`.

> **OJO:** en SQL Server **no existe `CALL`** (eso es de MySQL y PostgreSQL). Los procedimientos se llaman con **`EXEC`** o **`EXECUTE`**. Y las **funciones** se llaman con `SELECT funcion(...)`.

---

# ¿Qué significa BEGIN y END?

Aquí es donde muchas personas se confunden.

## BEGIN NO siempre significa "iniciar una transacción".

Dentro de un procedimiento:

```sql
BEGIN
    ...
END
```

**NO inicia una transacción.**

Simplemente indica:

> "Aquí empieza el bloque de código."

y

> "Aquí termina."

Es exactamente igual que las llaves `{}` de `Java`, `JavaScript` o `C#`.

### JavaScript

```javascript
function saludar() {

    console.log("Hola");

}
```

Las llaves solamente agrupan instrucciones.

En `SQL` ocurre exactamente lo mismo.

```sql
BEGIN

    SELECT * FROM products;

END
```

> **OJO con el nombre:** `BEGIN` a secas abre un **bloque**. `BEGIN TRANSACTION` abre una **transacción**. Son instrucciones distintas, aunque compartan la palabra.

---

# ¿Entonces cómo se inicia una transacción?

**Fuera de un procedimiento, en SQL Server, se utiliza:**

```sql
BEGIN TRANSACTION;
```

o su forma corta:

```sql
BEGIN TRAN;
```

**Dentro de un procedimiento (T-SQL), el control es igual que afuera:**

- Se puede abrir y cerrar transacciones con `BEGIN TRANSACTION` / `COMMIT` / `ROLLBACK`.
- Un procedimiento **puede** hacer `COMMIT` y `ROLLBACK`.
- Si el `EXEC` se ejecuta dentro de una transacción abierta por la aplicación, el `COMMIT` del procedimiento la confirma (y si hay transacciones anidadas, `COMMIT` va bajando el contador y solo la última confirma de verdad).

**Ejemplo:**

```sql
CREATE PROCEDURE transferir
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;   -- si hay un error, SQL Server hace ROLLBACK solo

    BEGIN TRANSACTION;

        UPDATE cuentas
        SET saldo = saldo - 500
        WHERE id = 1;

        UPDATE cuentas
        SET saldo = saldo + 500
        WHERE id = 2;

    COMMIT TRANSACTION;
END;
```

Aquí existen **dos BEGIN diferentes**:

- El primero pertenece al bloque del procedimiento (`BEGIN ... END`).
- El segundo, `BEGIN TRANSACTION`, inicia una transacción.

---

# BEGIN y END NO reemplazan COMMIT

**Muchas personas creen:**

```
BEGIN
...
END
```

**equivale a**

```
BEGIN TRANSACTION;
...
COMMIT;
```

Eso es falso.

`END` solamente finaliza el bloque del procedimiento.

Las transacciones siguen utilizando:

- `COMMIT`
- `ROLLBACK`

---

# Procedimientos con parámetros

Los procedimientos pueden recibir información.

En SQL Server los parámetros **siempre empiezan con `@`**.

**Ejemplo:**

```sql
CREATE PROCEDURE buscar_producto
    @id_producto INT
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Buscando producto ' + CAST(@id_producto AS VARCHAR(10));

    SELECT *
    FROM products
    WHERE productid = @id_producto;
END;
```

**Ejecución:**

```sql
EXEC buscar_producto 5;
```

o con nombre explícito del parámetro _(más legible)_:

```sql
EXEC buscar_producto @id_producto = 5;
```

> **OJO (diferencia con PostgreSQL):** en SQL Server **no hay error de ambigüedad** entre un parámetro y una columna, porque el parámetro siempre lleva `@`. Igual conviene usar nombres claros: `@id_producto` en vez de `@id`.

### Modos de parámetros en SQL Server

| Modo | Significado |
|------|-------------|
| **Por valor** _(default)_ | Entrada. Es el comportamiento normal, sin palabra clave. |
| `OUTPUT` | Salida: el procedimiento devuelve ese valor modificado. |
| `READONLY` | El parámetro es de solo lectura (obligatorio en parámetros de tipo tabla). |

```sql
CREATE PROCEDURE contar_productos
    @total INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @total = COUNT(*) FROM products;
END;
```

```sql
DECLARE @cantidad INT;

EXEC contar_productos @total = @cantidad OUTPUT;

SELECT @cantidad AS total_productos;
```

> **OJO:** en SQL Server **no existen** `IN`, `OUT`, `INOUT` ni `OUT` como palabras clave (eso es de PostgreSQL). Solo existe `OUTPUT` para los parámetros de salida.

---

# ¿Qué pueden hacer?

Un procedimiento puede contener prácticamente cualquier lógica.

Puede tener:

- SELECT
- INSERT
- UPDATE
- DELETE
- Variables (`DECLARE @x INT`)
- IF / ELSE
- CASE
- WHILE
- Cursores
- Transacciones (`BEGIN TRANSACTION` / `COMMIT` / `ROLLBACK`)
- Manejo de errores (`TRY ... CATCH`)

Es prácticamente un pequeño programa dentro de la base de datos.

---

# Utilidad

Los procedimientos almacenados sirven para:

- **Reutilizar** código `SQL`.
- Evitar **repetir** consultas.
- **Centralizar** la lógica del negocio.
- **Automatizar** procesos.
- **Ejecutar** varias consultas **con una sola llamada**.
- **Mejorar** el **mantenimiento** del sistema.

---

# Importancia

Supongamos un sistema bancario.

Sin procedimientos:

```
PHP

↓

UPDATE

↓

UPDATE

↓

INSERT

↓

COMMIT
```

Cada aplicación tendría que implementar toda la lógica.

Con procedimientos:

```
PHP

↓

EXEC transferir (...)

↓

Base de datos
```

Toda la lógica queda en un solo lugar.

---

# ¿Siempre es recomendable usarlos?

## No.

Depende del proyecto.

### Son recomendables cuando

✅ Existen procesos repetitivos.

Ejemplo:

- registrar ventas
- generar reportes
- actualizar inventario
- transferencias bancarias
- cálculos complejos

---

✅ Hay varias aplicaciones utilizando la misma base de datos.

Ejemplo

- aplicación web
- aplicación móvil
- sistema administrativo

Todas pueden llamar al mismo procedimiento.

---

✅ Existe mucha lógica SQL.

Ejemplo

```
IF

↓

UPDATE

↓

INSERT

↓

DELETE

↓

COMMIT
```

---

# ¿Cuándo NO conviene?

Cuando la lógica pertenece más a la aplicación que a la base de datos.

Por ejemplo:

- reglas del negocio muy cambiantes
- validaciones de interfaz
- cálculos propios del backend

En muchos proyectos modernos se procura que la mayor parte de la lógica esté en el backend (`Java`, `C#`, `PHP`, `Node.js`, etc.), utilizando procedimientos solo cuando realmente aportan ventajas.

---

# Procedimiento vs Vista

| Característica | Procedimiento | Vista |
|---------------|--------------|--------|
| Es un programa | ✅ | ❌ |
| Es una consulta guardada | ❌ | ✅ |
| Puede recibir parámetros | ✅ | ❌ |
| Puede modificar datos | ✅ | Limitado |
| Puede contener IF | ✅ | ❌ |
| Puede usar WHILE | ✅ | ❌ |
| Se ejecuta con EXEC | ✅ | ❌ |
| Se consulta con SELECT | ❌ | ✅ |

---

## Vista

Una vista es simplemente una consulta guardada.

```sql
CREATE VIEW productos_caros AS

SELECT *
FROM products
WHERE price > 100;
```

Uso

```sql
SELECT *
FROM productos_caros;
```

La vista únicamente devuelve información.

---

## Procedimiento

```sql
CREATE PROCEDURE aumentar_precios
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE products
    SET price = price * 1.10;
END;
```

Uso

```sql
EXEC aumentar_precios;
```

Aquí sí existe modificación de datos.

---

# Analogía con Programación

## Vista

Es como una variable que guarda una consulta.

```
Vista

↓

SELECT
```

---

## Procedimiento

Es como un método.

`Java`

```java
public void transferir(){

    ...

}
```

`SQL`

```sql
CREATE PROCEDURE transferir
AS
BEGIN

...

END;
```

---

# Manejo de errores en SQL Server

- SQL Server **no usa bloques `EXCEPTION`** (eso es de PL/pgSQL). Usa **`TRY ... CATCH`**, muy parecido a `try/catch` en Java o C#:

```sql
CREATE PROCEDURE registrar_pago
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

            UPDATE cuentas SET saldo = saldo - @monto WHERE id = 1;

            IF @monto <= 0
                THROW 50001, 'El monto debe ser mayor a cero', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;   -- vuelve a lanzar el error original
    END CATCH
END;
```

- `THROW` lanza un error con número y mensaje personalizados (SQL Server 2012+).
- `RAISERROR` es la forma antigua de lanzar el mismo tipo de error.
- `PRINT` muestra un mensaje informativo (reemplaza al `RAISE NOTICE` de PostgreSQL).
- `THROW;` **sin argumentos** vuelve a lanzar la excepción capturada, dentro del `CATCH`.

> **OJO:** `@@TRANCOUNT` te dice cuántas transacciones hay abiertas. Es la forma correcta de decidir si hace falta `ROLLBACK` dentro del `CATCH`.

> **OJO (muy importante):** si un error no es capturado por un `TRY ... CATCH` y `XACT_ABORT` está en `OFF` (el default), la transacción puede quedar **abierta y en estado inconsistente**. Activá `SET XACT_ABORT ON;` al inicio del procedimiento.

---

# Resumen

| Concepto | Descripción |
|----------|-------------|
| Procedimiento almacenado | Programa guardado dentro de la base de datos. |
| `T-SQL` | Lenguaje procedimental del cuerpo en SQL Server. |
| `AS BEGIN ... END` | Delimita el cuerpo; **no** hace falta `DELIMITER` ni `$$`. |
| `BEGIN...END` | Delimita el bloque del procedimiento; **no inicia una transacción**. |
| `BEGIN TRANSACTION;` | Inicia una transacción. |
| `COMMIT` | Guarda definitivamente los cambios de una transacción. |
| `ROLLBACK` | Revierte los cambios realizados desde el inicio de la transacción. |
| `EXEC` / `EXECUTE` | Ejecuta un procedimiento almacenado. |
| `TRY ... CATCH` | Manejo de errores dentro de T-SQL. |
| Vista | Consulta guardada para facilitar la lectura de datos. |

---

# Conclusión

Los **Procedimientos Almacenados** permiten encapsular lógica `SQL` dentro de la base de datos, reutilizar procesos y ejecutar operaciones complejas mediante una única llamada (`EXEC`). Son especialmente útiles para procesos repetitivos, operaciones críticas y cuando varias aplicaciones comparten la misma base de datos.

Es importante no confundir el `BEGIN ... END` de un procedimiento con el `BEGIN TRANSACTION` de una transacción. El primero únicamente delimita el bloque de instrucciones del procedimiento, mientras que el segundo inicia una transacción que posteriormente debe finalizar con `COMMIT` o `ROLLBACK`.

> **Diferencia clave con MySQL y PostgreSQL:** SQL Server no usa `DELIMITER` ni dollar-quoting (`$$`); usa `BEGIN ... END` y el separador de lotes `GO` del cliente. Y en SQL Server los procedimientos **sí pueden** hacer `COMMIT`/`ROLLBACK`, mientras que las funciones **no pueden**: las sentencias de control de transacciones están prohibidas dentro de una UDF.

---

## EJM DE PROCEDIMIENTO ALMACENADO CON PARÁMETROS 
```SQL 
-- EJM DE PROCEDIMIENTO ALMACENADO 
-- Vamos a usar un parámetro y será el ID 78 
CREATE PROCEDURE aumentar_precio
    @id_product   INT,
    @plus_price   DECIMAL(10,2)
AS
BEGIN 
    SET NOCOUNT ON;

    UPDATE products
    SET price = COALESCE(price, 0) + @plus_price 
    WHERE productid = @id_product;
END;
GO

-- COMETÍ UN ERROR INTENCIONAL 'ProductoID' => productid 
-- ELIMINAR PROCEDIMIENTO (en SQL Server NO hay que indicar la firma):
-- DROP PROCEDURE IF EXISTS aumentar_precio;

EXEC aumentar_precio @id_product = 78, @plus_price = 12.50;

SELECT * FROM products;
```

> **OJO:** en SQL Server `DROP PROCEDURE nombre;` funciona aunque haya "sobrecargas" aparentes, porque **SQL Server no permite dos procedimientos con el mismo nombre** dentro del mismo esquema. Si el procedimiento ya existe, usá `DROP PROCEDURE IF EXISTS nombre;` o `CREATE OR ALTER PROCEDURE`.

> **OJO:** como SQL Server no permite sobrecargar procedimientos, no existen los `DROP PROCEDURE nombre(tipos)` de PostgreSQL.

---
