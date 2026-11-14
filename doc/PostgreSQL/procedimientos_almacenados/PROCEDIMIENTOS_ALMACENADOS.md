# Blue Lock SQL Project
# 📦 Procedimientos Almacenados _(Stored Procedures)_ en PostgreSQL

## ¿Qué es un Procedimiento Almacenado?

- Un **Procedimiento Almacenado** (*Stored Procedure*) es un conjunto de instrucciones `SQL` que se **guarda dentro de la BBDD** con un nombre para poder ejecutarlo cuando sea necesario.

- Es similar a una **función o método** de un `lenguaje de programación`, pero en lugar de estar escrito en `Java`, `JavaScript` o `PHP`, está escrito en `SQL` _(y el lenguaje procedimental del SGBD, en PostgreSQL: **PL/pgSQL**)_.

- En PostgreSQL, los procedimientos existen desde la **versión 11**. Antes de eso solo había funciones.

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
  CALL transferir_dinero(...);
  ```

- Toda la lógica ya está almacenada dentro de la base de datos.

---

# ¿Cómo funcionan?

## Crear un procedimiento

```sql
CREATE PROCEDURE mostrar_productos()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Listado de productos';
    PERFORM 1 FROM products;
END;
$$;
```

### ¿Qué sucede aquí?

1. Se crea un procedimiento llamado **mostrar_productos**.
2. `LANGUAGE plpgsql` indica el lenguaje procedimental.
3. El cuerpo va entre `$$ ... $$` (**dollar-quoting**), no con `DELIMITER`.
4. Dentro del bloque `BEGIN ... END` se escriben las instrucciones.
5. El procedimiento queda almacenado en la base de datos.

---

## Ejecutarlo

```sql
CALL mostrar_productos();
```

**Resultado:** el procedimiento se ejecuta y muestra el aviso `Listado de productos`.

> **OJO:** `CALL` es para procedimientos. Las **funciones** se llaman con `SELECT funcion(...)`.

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

    PERFORM 1 FROM products;

END
```

---

# ¿Entonces cómo se inicia una transacción?

**Fuera de un procedimiento, en PostgreSQL, se utiliza:**

```sql
BEGIN;
```

o también el estándar:

```sql
START TRANSACTION;
```

**Dentro de un procedimiento (PL/pgSQL), el control es distinto:**

- No se usa `START TRANSACTION;` dentro del cuerpo.
- Un procedimiento **puede** ejecutar `COMMIT` y `ROLLBACK` (esto es lo que lo diferencia de una función).
- Si el `CALL` se ejecuta dentro de una transacción abierta, el `COMMIT` del procedimiento la confirma.

**Ejemplo:**

```sql
CREATE PROCEDURE transferir()
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE cuentas
    SET saldo = saldo - 500
    WHERE id = 1;

    UPDATE cuentas
    SET saldo = saldo + 500
    WHERE id = 2;

    COMMIT;

END;
$$;
```

Aquí existen **dos BEGIN diferentes**:

- El primero pertenece al bloque del procedimiento (`BEGIN ... END`).
- El segundo, si aparece solo (`BEGIN;`), inicia una transacción.

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
BEGIN;
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

**Ejemplo:**

```sql
CREATE PROCEDURE buscar_producto(
    p_id_producto INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN

    RAISE NOTICE 'Buscando producto %', p_id_producto;

    PERFORM 1
    FROM products
    WHERE productid = p_id_producto;

END;
$$;
```

**Ejecución:**

```sql
CALL buscar_producto(5);
```

> **OJO (muy importante en PostgreSQL):** si el parámetro se llama igual que una columna (`id_producto` vs `id_producto`), PostgreSQL no sabe si hablás de la columna o del parámetro y lanza un error de ambigüedad. Por eso se acostumbra usar el prefijo **`p_`** (`p_id_producto`).

### Modos de parámetros en PostgreSQL

| Modo | Significado |
|------|-------------|
| `IN` | Entrada (es el **default**). |
| `OUT` | Salida: el procedimiento devuelve ese valor. |
| `INOUT` | Entrada y salida. |

```sql
CREATE PROCEDURE contar_productos(OUT total INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO total FROM products;
END;
$$;

CALL contar_productos(NULL);
```

---

# ¿Qué pueden hacer?

Un procedimiento puede contener prácticamente cualquier lógica.

Puede tener:

- SELECT
- INSERT
- UPDATE
- DELETE
- Variables
- IF
- CASE
- WHILE
- LOOP
- REPEAT
- Cursores
- Transacciones (`COMMIT` / `ROLLBACK`)
- Manejo de errores (`EXCEPTION`)

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

CALL transferir(...)

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
| Se ejecuta con CALL | ✅ | ❌ |
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
CREATE PROCEDURE aumentar_precios()
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE products
    SET price = price * 1.10;

END;
$$;
```

Uso

```sql
CALL aumentar_precios();
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
CREATE PROCEDURE transferir()
LANGUAGE plpgsql
AS $$
BEGIN

...

END;
$$;
```

---

# Manejo de errores en PostgreSQL

- A diferencia de MySQL, PostgreSQL usa bloques `EXCEPTION` dentro de PL/pgSQL:

```sql
CREATE PROCEDURE registrar_pago(p_monto NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE cuentas SET saldo = saldo - p_monto WHERE id = 1;

    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto debe ser mayor a cero';
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
```

- `RAISE EXCEPTION` lanza un error.
- `RAISE NOTICE` muestra un mensaje informativo.
- `RAISE;` vuelve a lanzar la excepción original.

---

# Resumen

| Concepto | Descripción |
|----------|-------------|
| Procedimiento almacenado | Programa guardado dentro de la base de datos. |
| `LANGUAGE plpgsql` | Lenguaje procedimental del cuerpo. |
| `$$ ... $$` | Dollar-quoting: delimita el cuerpo sin `DELIMITER`. |
| `BEGIN...END` | Delimita el bloque del procedimiento; **no inicia una transacción**. |
| `BEGIN;` / `START TRANSACTION;` | Inicia una transacción (fuera del procedimiento). |
| `COMMIT` | Guarda definitivamente los cambios de una transacción. |
| `ROLLBACK` | Revierte los cambios realizados desde el inicio de la transacción. |
| `CALL` | Ejecuta un procedimiento almacenado. |
| `EXCEPTION` | Manejo de errores dentro de PL/pgSQL. |
| Vista | Consulta guardada para facilitar la lectura de datos. |

---

# Conclusión

Los **Procedimientos Almacenados** permiten encapsular lógica `SQL` dentro de la base de datos, reutilizar procesos y ejecutar operaciones complejas mediante una única llamada (`CALL`). Son especialmente útiles para procesos repetitivos, operaciones críticas y cuando varias aplicaciones comparten la misma base de datos.

Es importante no confundir el `BEGIN ... END` de un procedimiento con el `BEGIN` o `START TRANSACTION` de una transacción. El primero únicamente delimita el bloque de instrucciones del procedimiento, mientras que el segundo inicia una transacción que posteriormente debe finalizar con `COMMIT` o `ROLLBACK`.

> **Diferencia clave con MySQL:** PostgreSQL no usa `DELIMITER`; usa **dollar-quoting** (`$$`). Y en PostgreSQL los procedimientos **sí pueden** hacer `COMMIT`/`ROLLBACK`, mientras que las funciones **no**.

--- 

## EJM DE PROCEDIMIENTO ALMACENADO CON PARÁMETROS 
```SQL 
-- EJM DE PROCEDIMIENTO ALMACENADO 
-- Vamos a usar un parámetro y será el ID 78 
CREATE PROCEDURE aumentar_precio(
    p_id_product INTEGER,
    p_plus_price NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN 
    UPDATE products
    SET price = COALESCE(price, 0) + p_plus_price 
    WHERE productid = p_id_product;
END;
$$;

-- COMETÍ UN ERROR INTENCIONAL 'ProductoID' => productid 
-- ELIMINAR PROCEDIMIENTO (en PostgreSQL hay que indicar la firma):
-- DROP PROCEDURE aumentar_precio(INTEGER, NUMERIC);

CALL aumentar_precio(78, 12.50);

SELECT * FROM products;
```

> **OJO:** `DROP PROCEDURE nombre;` a secas falla en PostgreSQL si hay sobrecargas. Se usa `DROP PROCEDURE nombre(tipos_de_parametros);`.

---
