# Blue Lock SQL Project  
## ¿Qué son las _Subconsultas_?
- Una `subconsulta` es una `consulta SQL` que se puede encontrar `dentro de otra consulta SQL`. 

- Dentro de una sola sentencia **SQL** se pueden especificar hasta `16 subconsultas` y dentro de una **_subconsulta_** se pueden especificar otras subconsultas. 

- Las `subconsultas` se ejecutan de la última a la primera dentro de la sentencia **SQL** principal en la que aparecen.

--- 
## Reglas para _Subconsultas_ 
- Cada `subconsulta` debe ir entre paréntesis. 
  
- En una `subconsulta`, se debe especificar sólo una columna o expresión a no ser que se esté utilizando `IN`, `ANY`, `ALL` o `EXISTS`. 

- Una `subconsulta` no puede contener una cláusula `BETWEEN` ni `LIKE`. 

- Una `subconsulta` no puede contener una cláusula `ORDER BY`. 

- Una `subconsulta` de una sentencia `UPDATE` no puede recuperar datos de la misma tabla en la que deben actualizarse los datos. 

- Una `subconsulta` de una sentencia `DELETE` no puede recuperar datos de la misma tabla de la que deben eliminarse los datos. 

--- 
## IN | ANY | ALL | EXISTS 

| Nombre | Definición | SENTENCIA | 
|--------|------------|-----------|
| IN     | Se pregunta si esta valor pertence al conjunto | `select * from empleados where id_departamento in ( select id from departamento );` | 
| ANY   |  Verifica si la comparación es verdadera para al menos un elemento del conjunto (AL MENOS UNO) | `select* from empleados where sueldo > any ( select sueldo from empleados );` | 
| ALL | Verifica que la comparación sea verdadera para todos los elementos del conjunto. | `select * from empleados where sueldo >= all ( select sueldo from empleados );` | 
| EXISTS | Verifica que exista al menos un elemento, no compara valores, solo que exista al menos un elemento. | `SELECT * FROM departamento d WHERE EXISTS ( SELECT * FROM empleados e WHERE e.id_departamento = d.id );` | 

--- 

