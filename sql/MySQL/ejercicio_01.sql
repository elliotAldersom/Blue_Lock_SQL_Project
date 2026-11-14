create database emp_seguros;

use emp_seguros;

create table clientes(
	id int primary key auto_increment,
	nombre varchar(25),
    apellido varchar(25),
    dni varchar(15),
    fecha_nac date, 
    sueldo double
);

create table propiedades(
	id int primary key auto_increment, 
    metros_cuadrados double,
    zona varchar(45),
    valor_de_mercado double
);

create table servicios(
	codigo int primary key auto_increment,
    tipo varchar(20),
    detalle_cobertura varchar(120),
    precio double,
    idCliente int, 
    foreign key (idCliente) references clientes(id),
    
    idPropiedad int,
    foreign key (idPropiedad) references propiedades(id)
);