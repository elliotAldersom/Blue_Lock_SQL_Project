# Blue Lock SQL Project  
## 🧠 ¿Qué es una Vista (VIEW) en PostgreSQL? 📖 📊

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

`PostgreSQL` guarda la consulta.

Cuando la usas:

```sql
SELECT * FROM view_name;
```

👉 `PostgreSQL` ejecuta internamente la consulta original.

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

> En PostgreSQL, además, podés limitar permisos sobre la vista y no sobre la tabla base:
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
-- Si no existe la crea y si ya existe la reemplaza
CREATE OR REPLACE VIEW view_employees AS
SELECT employeeid, firstname
FROM employees;
```

> **OJO:** `CREATE OR REPLACE VIEW` solo puede **agregar** columnas al final. Si cambiás el orden o el tipo de una columna existente, tenés que hacer `DROP VIEW` y crearla de nuevo.

---

### Eliminar

```sql
-- Usar IF EXISTS 
-- Útil para eliminar solo si existe la vista
DROP VIEW IF EXISTS view_employees;
```

---

### Ver la definición de una vista

```sql
-- Desde psql:
\d+ view_employees

-- O consultando el catálogo:
SELECT pg_get_viewdef('view_employees', true);
```

---

## 🧊 Vistas _materializadas_ (Materialized Views)

- Una **vista materializada** **sí guarda** el resultado en disco. Es más rápida para leer, pero hay que **refrescarla** cuando cambian los datos.
- Es una ventaja importante de PostgreSQL frente a MySQL, que no las tiene de forma nativa.

```sql
CREATE MATERIALIZED VIEW resumen_ventas AS
SELECT categoria, SUM(total) AS total_vendido
FROM pedidos
GROUP BY categoria;
```

```sql
-- Refrescar (bloquea lecturas mientras dura)
REFRESH MATERIALIZED VIEW resumen_ventas;

-- Refrescar sin bloquear lecturas (requiere un índice UNIQUE)
REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_ventas;
```

```sql
DROP MATERIALIZED VIEW IF EXISTS resumen_ventas;
```

---

## 🧱 Importante sobre DBMS

| DBMS       | Soporte de vistas | Comentarios                      |
|------------|-------------------|----------------------------------|
| MySQL      | ✅ Sí            | No materializadas (por defecto)   |
| PostgreSQL | ✅ Sí            | Vistas normales **y materializadas** |
| SQL Server | ✅ Sí            | Soporta indexed views             |
| Oracle     | ✅ Sí            | Muy potentes + materialized views |
| SQLite     | ⚠️ Limitado      | Depende de versión                |

---

## 🚨 Punto clave

- Una vista **NO almacena datos** (en PostgreSQL estándar); una vista **materializada sí**.
- Siempre ejecuta la consulta en tiempo real.
- Puede afectar rendimiento si la consulta es compleja.
- En PostgreSQL podés usar `WITH CHECK OPTION` para que los `INSERT`/`UPDATE` a través de la vista respeten el `WHERE`:

```sql
CREATE VIEW view_high_salary AS
SELECT employeeid, firstname, salary
FROM employees
WHERE salary > 3200
WITH CHECK OPTION;
```

---

## 🧠 Resumen final

> Una vista es una “tabla virtual” que representa el resultado de una consulta SQL reutilizable, útil para simplificar, proteger y organizar el acceso a datos. En PostgreSQL también existen las **vistas materializadas**, que guardan el resultado en disco.

---
