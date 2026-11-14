# Blue Lock SQL Project  
## 🧠 ¿Qué es una Vista (VIEW) en MySQL? 📖 📊

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

`MySQL` guarda la consulta.

Cuando la usas:

```sql
SELECT * FROM view_name;
```

👉 `MySQL` ejecuta internamente la consulta original.

---

## 📌 Ejemplo simple

### 🔨 Crear la vista 👀

```sql
CREATE VIEW view_employees AS
SELECT EmployeeID, FirstName, LastName
FROM employees;
```

---

### 📊 Datos reales en la tabla `employees`

| EmployeeID | FirstName | LastName | Salary |
|------------|-----------|----------|--------|
| 1          | Nancy     | Davolio  | 3000   |
| 2          | Andrew    | Fuller   | 4000   |
| 3          | Maria     | Anders   | 3500   |

---

### 👀 Resultado al usar la vista

```sql
SELECT * FROM view_employees;
```

| EmployeeID | FirstName | LastName |
|------------|-----------|----------|
| 1          | Nancy     | Davolio  |
| 2          | Andrew    | Fuller   |
| 3          | Maria     | Anders   |

👉 La columna `Salary` queda oculta.

---

## 🔍 Ejemplo con filtro

### Crear vista

```sql
CREATE VIEW view_high_salary AS
SELECT EmployeeID, FirstName, Salary
FROM employees
WHERE Salary > 3200;
```

---

### Resultado

```sql
SELECT * FROM view_high_salary;
```

| EmployeeID | FirstName | Salary |
|------------|-----------|--------|
| 2          | Andrew    | 4000   |
| 3          | Maria     | 3500   |

---

## 🔗 Ejemplo con JOIN (uso real)

```sql
CREATE VIEW view_employee_department AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    d.DepartmentName
FROM employees e
JOIN departments d
ON e.DepartmentID = d.DepartmentID;
```

---

### Resultado

| EmployeeID | FirstName | DepartmentName |
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
SELECT EmployeeID, FirstName
FROM employees;
```

---

### Eliminar

```sql
-- Usar IF EXISTS 
-- Util para eliminar solo si existe la vista
DROP VIEW IF EXISTS view_employees;
```

---

## 🧱 Importante sobre DBMS

| DBMS       | Soporte de vistas | Comentarios                      |
|------------|-------------------|----------------------------------|
| MySQL      | ✅ Sí            | No materializadas (por defecto)   |
| PostgreSQL | ✅ Sí            | Soporta vistas avanzadas          |
| SQL Server | ✅ Sí            | Soporta indexed views             |
| Oracle     | ✅ Sí            | Muy potentes + materialized views |
| SQLite     | ⚠️ Limitado      | Depende de versión                |

---

## 🚨 Punto clave

- Una vista **NO almacena datos** (en MySQL estándar)
- Siempre ejecuta la consulta en tiempo real
- Puede afectar rendimiento si la consulta es compleja

---

## 🧠 Resumen final

> Una vista es una “tabla virtual” que representa el resultado de una consulta SQL reutilizable, útil para simplificar, proteger y organizar el acceso a datos.

--- 