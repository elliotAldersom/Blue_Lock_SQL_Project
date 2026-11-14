# Blue Lock SQL Project
## 🔹 `DELIMITER` en MySQL y su equivalente en PostgreSQL

## ¿Qué es `DELIMITER`?

`DELIMITER` es un comando de **MySQL Workbench (o consola mysql)** que cambia el símbolo que indica el final de una sentencia SQL.

Por defecto ese símbolo es:

```sql
;
```

---

## ¿Por qué se usa en MySQL?

Se usa cuando creas cosas como **procedimientos**, porque dentro hay varios `;`.

Ejemplo:

```sql
CREATE PROCEDURE ejemplo()
BEGIN
    SELECT * FROM products;
    SELECT * FROM customers;
END;
```

El problema es que el cliente _(Workbench)_ ve el primer `;` y piensa que la sentencia ya terminó.

---

## Solución en MySQL

Cambias temporalmente el delimitador:

```sql
DELIMITER $$

CREATE PROCEDURE ejemplo()
BEGIN
    SELECT * FROM products;
    SELECT * FROM customers;
END$$

DELIMITER ;
```

---

## ⚠️ En PostgreSQL `DELIMITER` NO existe

PostgreSQL **no tiene** el comando `DELIMITER`. En su lugar se usa **dollar-quoting**: el cuerpo del procedimiento o función se encierra entre `$$ ... $$` (o `$etiqueta$ ... $etiqueta$`). Todo lo que está dentro se trata como un único texto y los `;` internos **no** cortan la sentencia.

```sql
CREATE PROCEDURE ejemplo()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Productos:';
    PERFORM 1 FROM products;
    RAISE NOTICE 'Clientes:';
    PERFORM 1 FROM customers;
END;
$$;
```

> **OJO:** `PERFORM` se usa cuando querés ejecutar una consulta y descartar el resultado dentro de PL/pgSQL. Para devolver filas desde una **función**, usá `RETURN QUERY`.

Si el cuerpo ya contiene `$$`, usá una etiqueta distinta:

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

## ¿Qué es “cliente”?

El **cliente** es el programa que usas para escribir `SQL`. En PostgreSQL, por ejemplo:

- `psql` _(cliente oficial de línea de comandos)_
- `pgAdmin`
- `DBeaver`
- `DataGrip`

👉 Ese programa es el que interpreta el `;` y los comandos que empiezan con `\` (como `\d`, `\dt`, `\df`).  
👉 El servidor `PostgreSQL` solo ejecuta lo que le envían.

---

## Idea clave

- `;` = fin de consulta para el cliente
- En MySQL, `DELIMITER` cambia ese fin temporalmente
- En PostgreSQL, `$$ ... $$` (dollar-quoting) evita que los `;` internos corten el cuerpo
- Se usa porque los procedimientos y funciones tienen varios `;` dentro

---

## Resumen rápido

- `DELIMITER` **no es SQL real del servidor** y **no existe en PostgreSQL**.
- En MySQL lo usa el programa _(cliente)_ para no cortar el procedimiento antes de tiempo.
- En PostgreSQL el equivalente es **dollar-quoting** (`$$`, `$tag$`).
- En `psql`, los comandos del cliente empiezan con `\`, no con `DELIMITER`.

---
