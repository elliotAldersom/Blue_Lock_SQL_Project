# Blue Lock SQL Project
## 🔹 `DELIMITER` en MySQL y su equivalente en SQL Server

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

## ⚠️ En SQL Server `DELIMITER` NO existe

SQL Server **no tiene** el comando `DELIMITER` ni necesita dólar-quoting. El motor entiende el cuerpo del procedimiento porque el bloque `BEGIN ... END` agrupa las instrucciones: **un `;` dentro de `BEGIN ... END` no termina el procedimiento**.

```sql
CREATE PROCEDURE ejemplo
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM products;
    SELECT * FROM customers;
END;
```

> **OJO:** en SQL Server el cuerpo va **después** de `AS`, sin `LANGUAGE`, sin `$$` y sin `DELIMITER`. Los `;` internos son parte del bloque.

Si el cuerpo es de una sola instrucción, `BEGIN ... END` es opcional:

```sql
CREATE PROCEDURE listar_productos
AS
    SELECT * FROM products;
```

---

## ¿Entonces qué separa las cosas en SQL Server? `GO`

`GO` **no es T-SQL**. Es un **separador de lotes** (*batch separator*) que entienden los clientes de SQL Server: **SSMS**, **Azure Data Studio**, `sqlcmd` y algunas librerías.

```sql
USE tienda;
GO

CREATE PROCEDURE ejemplo
AS
BEGIN
    SELECT * FROM products;
END;
GO

EXEC ejemplo;
GO
```

> **OJO:** `GO` **no se envía al servidor**. Es el cliente quien corta el texto y manda cada lote por separado. Por eso `GO` no puede ir dentro de un `BEGIN ... END` ni dentro de un `IF`.

> **OJO:** `GO` no acepta `;` delante sin problemas, pero sí acepta un número: `GO 5` ejecuta el lote **5 veces**.

---

## ¿Qué es “cliente”?

El **cliente** es el programa que usas para escribir `SQL`. En SQL Server, por ejemplo:

- `sqlcmd` _(cliente oficial de línea de comandos)_
- `SSMS` _(SQL Server Management Studio)_
- `Azure Data Studio`
- `DBeaver`
- `DataGrip`

👉 Ese programa es el que interpreta el `;`, el `GO` y los comandos que empiezan con `:` en `sqlcmd` (como `:r`, `:connect`, `:listvar`).  
👉 El servidor `SQL Server` solo ejecuta lo que le envían.

---

## Idea clave

- `;` = fin de **sentencia** para el motor
- `GO` = fin de **lote** para el cliente (SSMS, sqlcmd, Azure Data Studio)
- En MySQL, `DELIMITER` cambia el fin de sentencia temporalmente
- En SQL Server **no hace falta** cambiar nada: `BEGIN ... END` ya agrupa el cuerpo
- Se usa porque los procedimientos y funciones tienen varios `;` dentro

---

## Resumen rápido

- `DELIMITER` **no es SQL real del servidor** y **no existe en SQL Server**.
- En MySQL lo usa el programa _(cliente)_ para no cortar el procedimiento antes de tiempo.
- En SQL Server el equivalente práctico es **`BEGIN ... END`** para el cuerpo y **`GO`** para separar lotes.
- `GO` es del cliente, no del motor: no se puede usar dentro de un bloque.

---
