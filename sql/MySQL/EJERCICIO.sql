create database ejercicio;
use ejercicio;
create table producto (
	id int primary key auto_increment, 
    nombre varchar(200), 
    precio double, 
    stock int, 
    categoria varchar(200)
);

insert into producto (nombre, precio, stock, categoria) values
('Laptop', 3500, 10, 'Tecnología'),
('Mouse',  50, 100, 'Tecnología'),
('Teclado', 120, 50, 'Tecnología'),
('Silla', 400, 20, 'Muebles'),
('Escritorio', 900, 15, 'Muebles'),
('Cuaderno', 9, 200, 'Utiles');

-- DATOS GENERALES
select * from producto;
-- 1) =====================================================================================================================
-- Mostrar el nombre y precio de los productos cuyo precio sea mayor a 100, ordenados de mayor a menor precio. 
select nombre, precio from producto 
where precio > 100 order by precio desc;

-- Mostrar el nombre y precio de los productos cuyo precio sea mayor que el precio promedio de todos los productos.
select nombre, precio from producto 
where precio > (select avg(precio) from producto);

-- Mostrar el nombre del producto con el precio más alto.
select nombre, precio from producto 
where precio = (select max(precio) from producto);

-- Mostrar el nombre del producto con el precio más bajo.
select nombre, precio from producto 
where precio = (select min(precio) from producto);
-- ========================================================================================================================
-- 2) =====================================================================================================================
-- Mostrar el nombre, precio y stock de los productos cuyo stock sea menor a 50, ordenados por precio de menor a mayor. 
select nombre, precio, stock from producto 
where stock < 50 order by precio asc;

-- Mostrar los productos cuyo precio sea mayor que la suma total de precios dividida entre la cantidad de productos. (PROMEDIO) 
select * from producto 
where precio > (select avg(precio) from producto);

-- Mostrar las categorías que tienen más de un producto registrado, utilice GROUP BY y COUNT(). 
select categoria from producto group by categoria having count(*) > 1;

-- Mostrar los productos cuyo precio sea mayor que el precio mínimo registrado.
select * from producto 
where precio > (select min(precio) from producto);
-- ========================================================================================================================


create table Empleado (
	id int primary key auto_increment, 
    nombre varchar(200), 
    edad int, 
    salario double , 
    departamento varchar(100)
);

-- AGREGAR DATOS 
insert into Empleado (nombre, edad, salario, departamento) values 
('Ana', 25 , 1500 , 'Ventas'),
('Luis', 30 , 2200 , 'Sistemas'),
('Marta', 28 , 1800 , 'Ventas'),
('Pedro', 40 , 3000 , 'Sistemas'),
('Juan', 35 , 2500 , 'Finanzas');

-- MOSTRAR DATOS 
SELECT * FROM Empleado;

-- ORDENAR LA TABLA EMPLEADOS POR SALARIOS DE FORMA ASCENDENTE 
SELECT nombre, salario FROM Empleado order by salario asc;

-- ORDENAR LA TABLA EMPLEADOS POR SALARIOS DE FORMA DESCENDENTE 
SELECT nombre, salario FROM Empleado order by salario desc;

-- USAR WHERE 
SELECT id, nombre, salario FROM Empleado 
WHERE salario > 2000;

SELECT id, nombre, salario FROM Empleado 
WHERE salario = 2200;

SELECT id, nombre, salario FROM Empleado 
WHERE departamento = 'Sistemas';

-- EL svg() ES PARA PROMEDIOS
SELECT id, nombre, salario FROM Empleado 
WHERE salario > (select avg(salario) from Empleado);

-- FILTRAR AL TRABAJADOR CON MAYOR SALARIO max()
select id, nombre, salario from Empleado 
where salario = (select max(salario) from Empleado);

-- FILTRAR AL TRABAJADOR CON MENOR SALARIO min()
select id, nombre, salario from Empleado 
where salario = (select min(salario) from Empleado);

-- USAR count() 
select departamento from empleado group by departamento having count(*) >1;

