create database libreria;
use libreria;

create table editoriales(
	id int primary key auto_increment, 
    codigo varchar(25) not null unique,
    pais_origen varchar(40) not null
);

alter table editoriales 
add column nombre varchar(50) not null after codigo; 

create table libros(
	id int primary key auto_increment, 
    codigo varchar(25) not null unique, 
    titulo varchar(50) not null,
    precio decimal(5,2) not null default 0.0,
    id_editorial int, 
    foreign key (id_editorial) references editoriales(id)
);

alter table libros modify id_editorial int not null;

-- INSERT EDITORIAL 
insert into editoriales(codigo, nombre, pais_origen)
values
('ED-001', 'Planeta', 'España'),
('ED-002', 'Anagrama', 'España'),
('ED-003', 'Penguin Random House', 'Estados Unidos');

-- INSERT LIBROS 
insert into libros(codigo, titulo, precio, id_editorial)
values
('LB-001', 'El Quijote Moderno', 45.90, 1),
('LB-002', 'SQL desde Cero', 39.50, 1),
('LB-003', 'Historia del Mundo', 55.00, 1),

('LB-004', 'Filosofía Básica', 28.90, 2),
('LB-005', 'Pensar Rápido', 42.00, 2),
('LB-006', 'Psicología Social', 47.80, 2),

('LB-007', 'Python Avanzado', 60.00, 3),
('LB-008', 'Data Science Intro', 58.50, 3),
('LB-009', 'Machine Learning Básico', 65.00, 3),
('LB-010', 'Algoritmos Modernos', 70.00, 3);

-- SELECT GENERAL 
select * from editoriales; 
select * from libros;

-- Ordenar por precio ASC los libros
select * 
from libros
order by precio asc;

-- Ordenar por nombre las editoriales
select * 
from editoriales 
order by nombre asc;

-- Obtener titulo y precio de libros mayores de 50.00
select titulo, precio 
from libros 
where precio > 50;

-- Obtener el título y precio del libro más barato 
select titulo, precio
from libros
order by precio asc 
limit 1;

select titulo, precio 
from libros 
where precio = (
	select min(precio) from libros
);