# Blue Lock SQL Project
# 📦 Procedimientos Almacenados _(Stored Procedures)_ en SQL

## ¿Qué es un Procedimiento Almacenado?

- Un **Procedimiento Almacenado** (*Stored Procedure*) es un conjunto de instrucciones `SQL` que se **guarda dentro de la BBDD** con un nombre para poder ejecutarlo cuando sea necesario.

- Es similar a una **función o método** de un `lenguaje de programación`, pero en lugar de estar escrito en `Java`, `JavaScript` o `PHP`, está escrito en `SQL` _(y el lenguaje procedimental del SGBD)_.

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
DELIMITER $$

CREATE PROCEDURE mostrar_productos()
BEGIN
    SELECT * FROM products;
END$$

DELIMITER ;
```

### ¿Qué sucede aquí?

1. Se crea un procedimiento llamado **mostrar_productos**.
2. Dentro del bloque `BEGIN ... END` se escriben las instrucciones SQL.
3. El procedimiento queda almacenado en la base de datos.

---

## Ejecutarlo

```sql
CALL mostrar_productos();
```

**Resultado:**

| ProductID | ProductName    |
|-----------|----------------|
| 1         | Chai           |
| 2         | Chang          |
| 3         | Aniseed Syrup  |


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

---

# ¿Entonces cómo se inicia una transacción?

**Dentro de un procedimiento se utiliza:**

```sql
START TRANSACTION;
```

**o también**

```sql
BEGIN;
```

(En `MySQL` normalmente se recomienda usar `START TRANSACTION` para evitar confusión.)

**Ejemplo:**

```sql
DELIMITER $$

CREATE PROCEDURE transferir()
BEGIN

    START TRANSACTION;

    UPDATE cuentas
    SET saldo = saldo - 500
    WHERE id = 1;

    UPDATE cuentas
    SET saldo = saldo + 500
    WHERE id = 2;

    COMMIT;

END$$

DELIMITER ;
```

Aquí existen **dos BEGIN diferentes**:

- El primero pertenece al procedimiento.
- El segundo (`START TRANSACTION`) inicia la transacción.

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
DELIMITER $$

CREATE PROCEDURE buscar_producto(
    IN idProducto INT -- IN : Indica que es un Input o sea un parámetro 
)
BEGIN

    SELECT *
    FROM products
    WHERE ProductID = idProducto;

END$$

DELIMITER ;
```

**Ejecución:**

```sql
CALL buscar_producto(5);
```

**Resultado:**



| ProductID | ProductName |
|-----------|-------------|
| 5         | Queso       |



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
- Transacciones
- Manejo de errores

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
WHERE Price > 100;
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
BEGIN

    UPDATE products
    SET Price = Price * 1.10;

END;
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

BEGIN

...

END
```

---

# Resumen

| Concepto | Descripción |
|----------|-------------|
| Procedimiento almacenado | Programa guardado dentro de la base de datos. |
| BEGIN...END | Delimita el bloque del procedimiento; **no inicia una transacción**. |
| START TRANSACTION | Inicia una transacción. |
| COMMIT | Guarda definitivamente los cambios de una transacción. |
| ROLLBACK | Revierte los cambios realizados desde el inicio de la transacción. |
| CALL | Ejecuta un procedimiento almacenado. |
| Vista | Consulta guardada para facilitar la lectura de datos. |

---

# Conclusión

Los **Procedimientos Almacenados** permiten encapsular lógica `SQL` dentro de la base de datos, reutilizar procesos y ejecutar operaciones complejas mediante una única llamada (`CALL`). Son especialmente útiles para procesos repetitivos, operaciones críticas y cuando varias aplicaciones comparten la misma base de datos.

Es importante no confundir el `BEGIN ... END` de un procedimiento con el `BEGIN` o `START TRANSACTION` de una transacción. El primero únicamente delimita el bloque de instrucciones del procedimiento, mientras que el segundo inicia una transacción que posteriormente debe finalizar con `COMMIT` o `ROLLBACK`.

--- 

## EJM DE PRODCEDIMEINTO ALMACENADO CON PARÁMETROS 
```SQL 
-- EJM DE PROCEDIMIENTO ALMACENADO 
-- Vamos a usar un parámetro y será el ID 78 
delimiter $$ 
create procedure aumentarPrecio(
	in idProduct int,
	in plusPrice decimal(10,2) 
)
begin 
update products set price = coalesce(price, 0) + plusPrice 
where ProductID = idProduct;

end $$ 
delimiter ;

-- COMETÍ UN ERROR INTENCIONAL 'ProductoID' => ProductID 
-- ELIMINAR PROCEDIMIENTO: DROP PROCEDURE nombre_procedimiento;
drop procedure aumentarPrecio;

call aumentarPrecio(78, 12.50);

select * from products;
```