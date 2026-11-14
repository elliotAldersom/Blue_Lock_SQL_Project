-- SQL : Structured Query Language 
-- DDL : Data Definition Language / Lenguaje de Definición de Datos 
-- DEFINICÓN: 
-- Se utiliza para definir y administrar la estructura de la Base de Datos
-- y sus objetos (tablas, vistas, índices, etc.).

-- Principales Sentencias: 
-- CREATE : Crear Objetos 
-- ALTER : Modificar Objetos 
-- DROP : Eliminar Objetos 
-- Truncate : Vaciar tablas (reinicia el auto_increment)
-- Rename : Renombrar Objetos

-- EJM de Create : Creando una base de datos (database) 
create database bdEjemplo;
use bdEjemplo;

-- EJM Create : Creando una tabla (table) 
-- Cuando creamos una tabla, ponemos entre "(...)" estas 3 cosas 
-- nombre_columna  -  tipo_dato  -  restricciones 
create table usuarios(
	id int primary key auto_increment,
    nombre varchar(25)
);

-- ==== ==== ==== ==== 

-- EJM de ALter : Modificando una tabla (agregando un atributo => ADD) 
alter table usuarios 
add num_tel varchar(11);

-- EJM de Alter : Modificando una tabla (modificando una columna existente => MODIFY)
alter table usuarios 
modify nombre varchar(50);

-- ==== ==== ==== ==== 

-- EJM de Drop : Eliminar un atributo de una tabla 
create table libros(
	id int primary key auto_increment,
    nombre varchar(25),
    tipo varchar(25)
); 

alter table libros 
add fecha_agregado date;

alter table libros 
add disponibilidad boolean;

-- Forma A
alter table libros 
drop column fecha_agregado;

-- Forma B
alter table libros 
drop disponibilidad;

-- EJM de Drop : Eliminar una tabla 
drop table libros;

-- EJM de Drop : Eliminar una Base de Datos 
create database bdEliminar; 
use bdEliminar;
drop database bdeliminar;

-- ==== ==== ==== ==== 

-- EJM  de Truncate : Vaciar una tabla 
-- Primero vamos a insertar un dato para tener algo que vaciar. 
-- Insertar un dato => INSERT INTO  table (a1, a2, ...aN) values (v1, v2, ...vN);
insert into usuarios(nombre, num_tel)
values("Flavio Gerardo Silva Estrada", "61088098");

-- Ver los datos de la tabal "usuarios"
select * from usuarios;

-- Usar truncate table => Para vaciar una tabla
truncate table usuarios;

-- ==== ==== ==== ==== 

-- EJM de Rename : Renombrar una tabla
-- Forma A:
rename table usuarios to users;

-- Forma B: 
alter table users 
rename to  usuarios;

-- EJM de Rename : Renombrar un atributo de una tabla 
alter table usuarios 
rename column num_tel to telefono;
