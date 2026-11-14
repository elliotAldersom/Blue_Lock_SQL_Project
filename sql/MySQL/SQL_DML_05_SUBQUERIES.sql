create database futbol; 
use futbol;

create table hinchas(
	id int primary key auto_increment,
    nombre varchar(65) not null, 
    apellidos varchar(65) not null,
    equipo_futbol varchar(65) not null
); 

create table equipos_primera(
	id int primary key auto_increment, 
    nombre varchar(65) not null,
    cantidad_socios int not null default 1,
    localidad varchar(65),
    categoria varchar(65)
);

INSERT INTO hinchas (nombre, apellidos, equipo_futbol) VALUES
('Carlos', 'Ramirez Torres', 'Universitario'),
('Juan', 'Lopez Garcia', 'Alianza Lima'),
('Miguel', 'Fernandez Rojas', 'Sporting Cristal'),
('Luis', 'Castillo Mendoza', 'Melgar'),
('Pedro', 'Vargas Silva', 'Cienciano'),
('Jorge', 'Herrera Quispe', 'Universitario'),
('Andres', 'Sanchez Flores', 'Alianza Lima'),
('Diego', 'Navarro Paredes', 'Sport Boys'),
('Fernando', 'Gutierrez Salas', 'ADT'),
('Ricardo', 'Torres Huaman', 'Sport Huancayo');

insert into hinchas (nombre, apellidos, equipo_futbol)
values ("James", "Rodriguez Verestegui", "Colombia");

INSERT INTO equipos_primera
(nombre, cantidad_socios, localidad, categoria)
VALUES
('Universitario', 120000, 'Lima', 'Primera Division'),
('Alianza Lima', 110000, 'Lima', 'Primera Division'),
('Sporting Cristal', 85000, 'Lima', 'Primera Division'),
('Melgar', 45000, 'Arequipa', 'Primera Division'),
('Cienciano', 35000, 'Cusco', 'Primera Division'),
('Sport Boys', 25000, 'Callao', 'Primera Division'),
('ADT', 15000, 'Tarma', 'Primera Division'),
('Sport Huancayo', 18000, 'Huancayo', 'Primera Division');

select * from hinchas;
select * from equipos_primera;

-- Sentencia IN : 
-- permite verificar si un valor se encuentra dentro de una lista de valores o del resultado de una subconsulta.
select * from hinchas 
where equipo_futbol in (
	-- Subquery that returns a list / Subconsulta que retorna una lista
	select nombre from equipos_primera
);

select count(id) from equipos_primera;