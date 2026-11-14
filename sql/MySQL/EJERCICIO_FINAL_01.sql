create database academia_idioma;
use academia_idioma;

create table idiomas(
	id_idioma int primary key auto_increment, 
    nombre varchar(50) not null, 
    nivel varchar(50) not null default 'Básico'
);

create table alumnos(
	id_alumno int primary key auto_increment, 
    nombre varchar(50) not null, 
    apellido varchar(65) not null, 
    dni varchar(15) not null,
    id_idioma int not null, 
    foreign key (id_idioma) references idiomas(id_idioma)
);

alter table alumnos 
modify dni varchar(15) not null unique;

insert into idiomas(nombre, nivel) 
values 
('Inglés', default), 
('Inglés', 'Intermedio'),
('Inglés', 'Avanzado'), 
('Alemán', 'Básico'),
('Alemán', 'Intermedio'),
('Alemán', 'Avanzado');

insert into alumnos(nombre, apellido, dni, id_idioma)
values
("Flavio", "Silva", "61088098", 3),
("Luis", "Del Piero", "12345678", 4),
("Ana", "García", "87654321", 1),
("María", "López", "23456789", 2),
("Carlos", "Ramírez", "34567890", 5),
("Sofía", "Torres", "45678901", 6),
("Diego", "Fernández", "56789012", 1),
("Lucía", "Vargas", "67890123", 2),
("Andrés", "Mendoza", "78901234", 3),
("Valeria", "Castro", "89012345", 4);

-- SELECT GENERAL
select * from idiomas;
select * from alumnos;

-- INNER JOIN (LISTA DE ALUMNOS CON SUS CURSOS DE IDIOMA)
select * 
from alumnos 
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma
order by alumnos.id_alumno;

-- INGLÉS
select * 
from alumnos 
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma
where idiomas.nombre = 'Inglés'
order by alumnos.id_alumno;

select count(id_alumno) as cantidad_alumnos_inglés
from alumnos
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma 
where idiomas.nombre = 'Inglés';

-- FRANCÉS
select * 
from alumnos 
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma
where idiomas.nombre = 'Francés'
order by alumnos.id_alumno;



select count(id_alumno) as cantidad_alumnos_francés
from alumnos
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma 
where idiomas.nombre = 'Francés';

-- ALEMÁN
select * 
from alumnos 
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma
where idiomas.nombre = 'Alemán'
order by alumnos.id_alumno;

select count(id_alumno) as cantidad_alumnos_alemán
from alumnos
inner join idiomas 
on alumnos.id_idioma = idiomas.id_idioma 
where idiomas.nombre = 'Alemán';