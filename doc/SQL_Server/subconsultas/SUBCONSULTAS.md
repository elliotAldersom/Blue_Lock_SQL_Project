# Blue Lock SQL Project  
## ¿Qué son las _Subconsultas_?
- Una `subconsulta` es una `consulta SQL` que se puede encontrar `dentro de otra consulta SQL`. 

- Dentro de una sola sentencia **SQL** se pueden anidar subconsultas y dentro de una **_subconsulta_** se pueden especificar otras subconsultas. 

- Las `subconsultas` se ejecutan de la última a la primera dentro de la sentencia **SQL** principal en la que aparecen.

> **OJO (SQL Server):** el límite de `16 subconsultas` es una restricción de MySQL. **En SQL Server el límite es de 32 niveles de anidamiento** (no 16), y el límite práctico real lo pone la memoria y el planificador.

--- 
## Reglas para _Subconsultas_ en SQL Server
- Cada `subconsulta` debe ir entre paréntesis. 
  
- En una `subconsulta`, se debe especificar sólo una columna o expresión a no ser que se esté utilizando `IN`, `ANY`, `ALL` o `EXISTS`. 

- Una `subconsulta` **sí puede** contener `BETWEEN`, `LIKE`; esas restricciones son de MySQL, no de SQL Server. 

- Una `subconsulta` **no puede** contener `ORDER BY`, salvo que vaya acompañada de `TOP`, `OFFSET ... FETCH` u `OFFSET` (si no, SQL Server lanza un error).

- Para `UPDATE`, SQL Server usa `UPDATE ... FROM`: 
  ```sql
  UPDATE e
  SET e.sueldo = s.sueldo_nuevo
  FROM empleados AS e
  INNER JOIN sueldos AS s
      ON e.id = s.id_empleado;
  ```

- Para `DELETE`, SQL Server usa `DELETE ... FROM` con un `JOIN`: 
  ```sql
  DELETE e
  FROM empleados AS e
  INNER JOIN departamentos AS d
      ON e.id_departamento = d.id
  WHERE d.nombre = 'Temporal';
  ```

- Una `subconsulta` **no puede** referenciar directamente la misma tabla que se actualiza o elimina dentro del propio `UPDATE`/`DELETE`; SQL Server lanza el error *"The target table of the DML statement cannot have any enabled triggers..."* o un error de referencia circular. Se resuelve derivando la tabla en un `JOIN` o con una CTE.

---

## IN | ANY | ALL | EXISTS 

| Nombre | Definición | SENTENCIA | 
|--------|------------|-----------|
| IN     | Se pregunta si este valor pertenece al conjunto | `select * from empleados where id_departamento in ( select id from departamento );` | 
| ANY   |  Verifica si la comparación es verdadera para al menos un elemento del conjunto (AL MENOS UNO) | `select * from empleados where sueldo > any ( select sueldo from empleados );` | 
| ALL | Verifica que la comparación sea verdadera para todos los elementos del conjunto. | `select * from empleados where sueldo >= all ( select sueldo from empleados );` | 
| EXISTS | Verifica que exista al menos un elemento, no compara valores, solo que exista al menos un elemento. | `SELECT * FROM departamento d WHERE EXISTS ( SELECT * FROM empleados e WHERE e.id_departamento = d.id );` | 

> **Tip SQL Server:** `IN (SELECT ...)` y `= ANY (SELECT ...)` son equivalentes. SQL Server también acepta `SOME` como sinónimo de `ANY`. `NOT IN` con `NULL` puede dar resultados inesperados; en ese caso conviene usar `NOT EXISTS`.

--- 
## Subconsultas _correlacionadas_ 
- Una subconsulta es **correlacionada** cuando usa columnas de la consulta externa. Se ejecuta una vez por cada fila candidata de la consulta principal. 

```sql
SELECT e.nombre, e.sueldo
FROM empleados AS e
WHERE e.sueldo > (
    SELECT AVG(e2.sueldo)
    FROM empleados AS e2
    WHERE e2.id_departamento = e.id_departamento
);
```

--- 
## CTE (_Common Table Expressions_) — alternativa moderna
- SQL Server soporta `WITH` para nombrar subconsultas y hacerlas más legibles _(desde SQL Server 2005)_: 

```sql
WITH sueldo_promedio AS (
    SELECT id_departamento, AVG(sueldo) AS promedio
    FROM empleados
    GROUP BY id_departamento
)
SELECT e.nombre, e.sueldo, s.promedio
FROM empleados AS e
JOIN sueldo_promedio AS s ON s.id_departamento = e.id_departamento
WHERE e.sueldo > s.promedio;
```

> **OJO:** si la sentencia anterior termina con `;`, el `WITH` se entiende perfecto. Si no, hay que terminar la sentencia previa con punto y coma, porque `WITH` **debe** ser la primera palabra de la consulta.

--- 
## Top / Paginación en subconsultas
- En SQL Server no existe `LIMIT`. Para limitar filas dentro de una subconsulta se usa `TOP`, y para paginar se usa `OFFSET ... FETCH`:

```sql
-- Las 5 filas más recientes por departamento (subconsulta con TOP)
SELECT d.nombre AS departamento,
       (SELECT TOP 1 e.nombre
        FROM empleados AS e
        WHERE e.id_departamento = d.id
        ORDER BY e.sueldo DESC) AS mejor_pagado
FROM departamento AS d;
```

```sql
-- Paginación con OFFSET ... FETCH (requiere ORDER BY)
SELECT nombre, sueldo
FROM empleados
ORDER BY sueldo DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```

--- 
