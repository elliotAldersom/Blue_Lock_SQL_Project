# Blue Lock SQL Project  
## 🧠 ¿Qué es una Vista (VIEW) en SQL Server? 📖 📊

Una **vista (VIEW)** es una **tabla virtual** basada en el resultado de una consulta `SELECT`.

- No almacena datos físicamente _(en la mayoría de casos)_.
- Guarda únicamente la **consulta SQL**.
- Se comporta como si fuera una tabla normal.

---

## 🔧 ¿Cómo funciona?

Cuando creas una vista:

```sql
CREATE VIEW view_name AS
SELECT ...
```

`SQL Server` guarda la consulta.

Cuando la usas:

```sql
SELECT * FROM view_name;
```

👉 `SQL Server` ejecuta internamente la consulta original.

---

## 📌 Ejemplo simple

### 🔨 Crear la vista 👀

```sql
CREATE VIEW view_employees AS
SELECT employeeid, firstname, lastname
FROM employees;
```

---

### 📊 Datos reales en la tabla `employees`

| employeeid | firstname | lastname | salary |
|------------|-----------|----------|--------|
| 1          | Nancy     | Davolio  | 3000   |
| 2          | Andrew    | Fuller   | 4000   |
| 3          | Maria     | Anders   | 3500   |

---

### 👀 Resultado al usar la vista

```sql
SELECT * FROM view_employees;
```

| employeeid | firstname | lastname |
|------------|-----------|----------|
| 1          | Nancy     | Davolio  |
| 2          | Andrew    | Fuller   |
| 3          | Maria     | Anders   |

👉 La columna `salary` queda oculta.

---

## 🔍 Ejemplo con filtro

### Crear vista

```sql
CREATE VIEW view_high_salary AS
SELECT employeeid, firstname, salary
FROM employees
WHERE salary > 3200;
```

---

### Resultado

```sql
SELECT * FROM view_high_salary;
```

| employeeid | firstname | salary |
|------------|-----------|--------|
| 2          | Andrew    | 4000   |
| 3          | Maria     | 3500   |

---

## 🔗 Ejemplo con JOIN (uso real)

```sql
CREATE VIEW view_employee_department AS
SELECT 
    e.employeeid,
    e.firstname,
    d.departmentname
FROM employees e
JOIN departments d
ON e.departmentid = d.departmentid;
```

---

### Resultado

| employeeid | firstname | departmentname |
|------------|-----------|----------------|
| 1 | Nancy | Sales |
| 2 | Andrew | IT |
| 3 | Maria | HR |

---

## 🎯 ¿Para qué sirven las vistas?

### 1. 🧩 Simplificar consultas complejas
En vez de escribir `JOINs` largos:

```sql
SELECT * FROM view_employee_department;
```

---

### 2. 🔐 Seguridad
Ocultas columnas sensibles:

- Salary
- Password
- Personal data

> En SQL Server, además, podés limitar permisos sobre la vista y no sobre la tabla base:
> ```sql
> GRANT SELECT ON view_employees TO usuario_consulta;
> ```

---

### 3. ♻️ Reutilización de lógica
Evitas repetir consultas complejas en múltiples partes del sistema.

---

### 4. 🧠 Abstracción
El usuario ve una “tabla simple”, pero detrás hay lógica compleja.

---

## ⚙️ Operaciones con vistas

### Crear o reemplazar

```sql
-- Si no existe la crea y si ya existe la reemplaza (SQL Server 2016 SP1+)
CREATE OR ALTER VIEW view_employees AS
SELECT employeeid, firstname
FROM employees;
```

> **OJO:** `CREATE OR REPLACE VIEW` **no existe** en SQL Server (eso es de PostgreSQL y MySQL). Se usa **`CREATE OR ALTER VIEW`**. Si tu versión es anterior a 2016 SP1, tenés que hacer `DROP VIEW` y volver a crearla.

> **OJO (muy importante):** `CREATE VIEW` **debe ser la primera instrucción del lote**. Si la ponés después de otro `SELECT`, `USE` o comentario con `;`, SQL Server lanza un error de sintaxis. En SSMS se resuelve separando con `GO`.

---

### Eliminar

```sql
-- Usar IF EXISTS 
-- Útil para eliminar solo si existe la vista (SQL Server 2016+)
DROP VIEW IF EXISTS view_employees;
```

---

### Ver la definición de una vista

```sql
-- Desde SSMS / sqlcmd:
sp_helptext 'view_employees';

-- O consultando el catálogo:
SELECT OBJECT_DEFINITION(OBJECT_ID('view_employees')) AS definicion;

-- O con sys.sql_modules
SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('view_employees');
```

---

## 🧊 Vistas _indexadas_ (Indexed Views)

- Una **vista indexada** **sí guarda** el resultado en disco. Es más rápida para leer, pero hay que **mantenerla** cuando cambian los datos: SQL Server la actualiza **automáticamente** en cada `INSERT`/`UPDATE`/`DELETE` de las tablas base _(no se refresca a mano)_.
- Es el equivalente a la vista materializada de PostgreSQL y al `MATERIALIZED VIEW` de Oracle.
- Para crearla se necesita `WITH SCHEMABINDING` y **un índice clúster único** sobre la vista.
- Requiere `SET` de sesión específicos en cada conexión (`ANSI_NULLS`, `QUOTED_IDENTIFIER`, `ARITHABORT`, etc.). Si no están, SQL Server ignora la vista indexada y usa la normal.

```sql
CREATE VIEW resumen_ventas
WITH SCHEMABINDING
AS
SELECT categoria,
       COUNT_BIG(*) AS cantidad,
       SUM(total) AS total_vendido
FROM dbo.pedidos
GROUP BY categoria;
```

```sql
-- Un índice clúster UNIQUE es OBLIGATORIO para materializar la vista
CREATE UNIQUE CLUSTERED INDEX ix_resumen_ventas
ON resumen_ventas(categoria);
```

```sql
DROP VIEW IF EXISTS resumen_ventas;
```

> **OJO:** la vista indexada **no se puede refrescar manualmente**. `REFRESH MATERIALIZED VIEW` **no existe** en SQL Server (eso es de PostgreSQL). La actualización la mantiene el motor.

> **OJO:** no puede tener `OUTER JOIN`, `UNION`, subconsultas, `DISTINCT` ni CTEs. Si la consulta los usa, la vista no se puede indexar.

---

## 🧱 Importante sobre DBMS

| DBMS       | Soporte de vistas | Comentarios                      |
|------------|-------------------|----------------------------------|
| MySQL      | ✅ Sí            | No materializadas (por defecto)   |
| PostgreSQL | ✅ Sí            | Vistas normales **y materializadas** |
| SQL Server | ✅ Sí            | Soporta **indexed views** (similares a materializadas, se mantienen solas) |
| Oracle     | ✅ Sí            | Muy potentes + materialized views |
| SQLite     | ⚠️ Limitado      | Depende de versión                |

---

## 🚨 Punto clave

- Una vista **NO almacena datos** (en SQL Server estándar); una vista **indexada sí**.
- Siempre ejecuta la consulta en tiempo real.
- Puede afectar rendimiento si la consulta es compleja.
- En SQL Server podés usar `WITH CHECK OPTION` para que los `INSERT`/`UPDATE` a través de la vista respeten el `WHERE`:

```sql
CREATE VIEW view_high_salary AS
SELECT employeeid, firstname, salary
FROM employees
WHERE salary > 3200
WITH CHECK OPTION;
```

> **OJO (actualización a través de vistas):** en SQL Server una vista es *actualizable* solo si modifica **una** tabla base, sin agregados, `DISTINCT`, `GROUP BY`, `UNION` ni varias consultas anidadas.

---

## 🧠 Resumen final

> Una vista es una “tabla virtual” que representa el resultado de una consulta SQL reutilizable, útil para simplificar, proteger y organizar el acceso a datos. En SQL Server también existen las **vistas indexadas**, que guardan el resultado en disco y el motor mantiene actualizado automáticamente.

---
