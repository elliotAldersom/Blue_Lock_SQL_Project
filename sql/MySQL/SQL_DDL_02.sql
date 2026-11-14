use bdejemplo;

create table productos(
	id int auto_increment primary key, 
    nombre varchar(30) not null, 
    precio double not null, 
    stokc int not null default 0
);

alter table productos 
rename column stokc to stock;

create table empleados(
	id int auto_increment primary key, 
    nombre varchar(30) not null, 
    edad int not null check (edad >= 18), 
    estado boolean default true,
    email varchar(100) not null unique,
    num_telefono varchar(11) not null unique,
    cargo varchar(30) not null default 'Obrero'
);

alter table productos 
add descripcion varchar(120),
add cateogria varchar(50);

alter table productos 
modify descripcion varchar(120) not null; 

alter table productos 
rename column cateogria to categoria;

-- MODIFY : Modificar tipo de dato, valor por defecto (default) y restricciones
alter table productos 
modify categoria varchar(50) not null;

-- Usar CHANGE para cambiar nombre (versiones que no soportan RENAME) 
-- y además al usar CHANGE se necesita volver a definir el tipo y restricciones de la columna
alter table productos 
change precio costo double not null;

-- Insert 
insert into productos(nombre, costo, stock, descripcion, categoria)
values("Laptop MSI", 5000, default, "Laptop Gamer", "TECH");

update productos set 
nombre = "Laptop MSI" , 
costo = 5000, stock = 200, 
descripcion = "Laptop Gamer", 
categoria = "TECH"
where id = 1; 

update productos set stock = 999;

alter table productos 
change stock cantidad int not null default 0;
alter table productos rename column cantidad to stock;

-- Usar Modify para cambiar el tipo de dato del precio a decimal (N, Y) 
-- Donde N es la cantidad de números que tendrá antes de la ","  
-- Donde Y es la cantidad de números después de la ","
alter table productos 
modify costo decimal (12, 3) not null;

update productos set costo = 5455.7565 where id = 1;

select * from productos;

insert into empleados(nombre, edad, estado, email, num_telefono, cargo)
values("Pepe", 23, true, "pepitoQuechua@alicorp.pe", "456234789", "Vicepresidente"); 

truncate table empleados; 

alter table empleados drop column num_telefono;

drop table empleados;

select * from empleados;