# Blue Lock SQL Project  
## ¿Qué son las _Subconsultas_?
- Una `subconsulta` es una `consulta SQL` que se puede encontrar `dentro de otra consulta SQL`. 

- Dentro de una sola sentencia **SQL** se pueden anidar subconsultas y dentro de una **_subconsulta_** se pueden especificar otras subconsultas. 

- Las `subconsultas` se ejecutan de la última a la primera dentro de la sentencia **SQL** principal en la que aparecen.

> **OJO (PostgreSQL):** el límite de `16 subconsultas` es una restricción de MySQL. **PostgreSQL no tiene ese límite fijo**; el límite práctico lo pone la memoria y el planificador.

--- 
## Reglas para _Subconsultas_ en PostgreSQL
- Cada `subconsulta` debe ir entre paréntesis. 
  
- En una `subconsulta`, se debe especificar sólo una columna o expresión a no ser que se esté utilizando `IN`, `ANY`, `ALL` o `EXISTS`. 

- Una `subconsulta` **sí puede** contener `BETWEEN`, `LIKE` o `ILIKE`; esas restricciones son de MySQL, no de PostgreSQL. 

- Una `subconsulta` **sí puede** contener `ORDER BY`, pero solo tiene sentido si va acompañada de `LIMIT` u `OFFSET` (si no, el orden se descarta). 

- Para `UPDATE`, PostgreSQL usa `UPDATE ... FROM`: 
  ```sql
  UPDATE empleados e
  SET sueldo = s.sueldo_nuevo
  FROM sueldos s
  WHERE e.id = s.id_empleado;
  ```

- Para `DELETE`, PostgreSQL usa `DELETE ... USING`: 
  ```sql
  DELETE FROM empleados e
  USING departamentos d
  WHERE e.id_departamento = d.id
    AND d.nombre = 'Temporal';
  ```

- Una `subconsulta` puede referenciar la misma tabla que se actualiza o elimina; PostgreSQL lo permite, pero hay que tener cuidado con la semántica (usar `FROM`/`USING` o una CTE para evitar resultados inesperados).

--- 
## IN | ANY | ALL | EXISTS 

| Nombre | Definición | SENTENCIA | 
|--------|------------|-----------|
| IN     | Se pregunta si este valor pertenece al conjunto | `select * from empleados where id_departamento in ( select id from departamento );` | 
| ANY   |  Verifica si la comparación es verdadera para al menos un elemento del conjunto (AL MENOS UNO) | `select * from empleados where sueldo > any ( select sueldo from empleados );` | 
| ALL | Verifica que la comparación sea verdadera para todos los elementos del conjunto. | `select * from empleados where sueldo >= all ( select sueldo from empleados );` | 
| EXISTS | Verifica que exista al menos un elemento, no compara valores, solo que exista al menos un elemento. | `SELECT * FROM departamento d WHERE EXISTS ( SELECT * FROM empleados e WHERE e.id_departamento = d.id );` | 

> **Tip PostgreSQL:** `IN (SELECT ...)` y `= ANY (SELECT ...)` son equivalentes. `NOT IN` con `NULL` puede dar resultados inesperados; en ese caso conviene usar `NOT EXISTS`.

--- 
## Subconsultas _correlacionadas_ 
- Una subconsulta es **correlacionada** cuando usa columnas de la consulta externa. Se ejecuta una vez por cada fila candidata de la consulta principal. 

```sql
SELECT e.nombre, e.sueldo
FROM empleados e
WHERE e.sueldo > (
    SELECT AVG(e2.sueldo)
    FROM empleados e2
    WHERE e2.id_departamento = e.id_departamento
);
```

--- 
## CTE (_Common Table Expressions_) — alternativa moderna
- PostgreSQL soporta `WITH` para nombrar subconsultas y hacerlas más legibles: 

```sql
WITH sueldo_promedio AS (
    SELECT id_departamento, AVG(sueldo) AS promedio
    FROM empleados
    GROUP BY id_departamento
)
SELECT e.nombre, e.sueldo, s.promedio
FROM empleados e
JOIN sueldo_promedio s ON s.id_departamento = e.id_departamento
WHERE e.sueldo > s.promedio;
```

--- 
