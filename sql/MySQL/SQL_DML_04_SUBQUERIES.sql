use bdejemplo;

alter table empleados 
add column sueldo decimal (12,2);

select * from empleados;

update empleados set sueldo = 0 where sueldo is null; 

alter table empleados 
modify cargo varchar(30) not null default 'Obrero' after estado;

alter table empleados 
modify dni varchar(15) not null unique after nombre;

alter table empleados 
modify sueldo decimal (12,2) not null after cargo;

UPDATE empleados
SET sueldo = FLOOR(2500 + RAND() * (12000 - 2500));

-- //Obtener los empleados que superen el sueldo promedio 
-- 		//Calcular el sueldo Promedio

select * 
from empleados 
where sueldo >= (
	select avg(sueldo) 
    from empleados
);

