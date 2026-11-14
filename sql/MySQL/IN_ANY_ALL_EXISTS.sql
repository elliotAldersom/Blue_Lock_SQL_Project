use bdejemplo;

-- IN : Se pregunta si este valor pertenece al conjunto 
-- EJM fuera de subconsulta: 
select * 
from empleados 
where cargo in ("analista", "rrhh", "soporte técnico");

-- Equivale a: 
SELECT *
FROM empleados
WHERE cargo = 'analista'
   OR cargo = 'rrhh'
   OR cargo = 'soporte técnico';

-- EJM con SUBCONSULTA 
select * 
from empleados 
where id_departamento in (
	select id 
    from departamento
);

-- ==== ==== ==== ==== 
-- ANY: Verifica si la comparación es verdadera para al menos un elemento del conjunto (AL MENOS UNO)
-- EJM:  5 > any (1,3,10); // TRUE (1) 
-- EJM: 2 > any (5,8,10); // FALSE (0)

-- EJM con SUBCONSULTA 
select * 
from empleados 
where sueldo > any (
	select sueldo 
    from empleados
);

-- ALL : Verifica que la comparación sea verdadera para todos los elementos del conjunto. 
-- EJM: 10 > ALL (1,3,5) // TRUE (1) 
-- EJM: 4 > ALL (1,3,5) // FALSE (0)

-- EJM con SUBCONSULTA 
select * 
from empleados 
where sueldo >= all (
	select sueldo 
    from empleados
);

-- EXISTS: Verifica que exista al menos un elemento, no compara valores, solo que exista al menos un elemento 
-- EJM con SUBCONSULTA 
SELECT *
FROM departamento d
WHERE EXISTS (
    SELECT *
    FROM empleados e
    WHERE e.id_departamento = d.id
);
