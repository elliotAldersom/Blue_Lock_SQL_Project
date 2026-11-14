# Blue Lock SQL Project
## 🔹 DELIMITER en MySQL (explicación corta)

## ¿Qué es?

`DELIMITER` es un comando de **MySQL Workbench (o consola mysql)** que cambia el símbolo que indica el final de una sentencia SQL.

Por defecto ese símbolo es:

```sql
;
```

---

## ¿Por qué se usa?

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

## Solución

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

## ¿Qué es “cliente”?

El **cliente** es el programa que usas para escribir `SQL`, por ejemplo:

- `MySQL Workbench`
- consola `mysql`
- `DBeaver`

👉 Ese programa es el que interpreta el `;`  
👉 El servidor `MySQL` solo ejecuta lo que le envían

---

## Idea clave

- `;` = fin de consulta para el cliente
- `DELIMITER` = cambia ese fin temporalmente
- Se usa porque los procedimientos tienen varios `;` dentro

---

## Resumen rápido

- No es `SQL` real del servidor
- Solo lo usa el programa _(cliente)_
- Evita que el procedimiento se corte antes de tiempo

--- 