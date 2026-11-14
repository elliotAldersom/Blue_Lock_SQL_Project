use bdejemplo;

create table departamento(
	id int primary key auto_increment, 
    nombre varchar(50) not null,
    edificio varchar(50) not null,
    piso int not null default 1
);

truncate table empleados;

alter table empleados 
add id_departamento int not null,
add foreign key (id_departamento) references departamento(id);

alter table empleados 
add column dni varchar(15) not null unique;

insert into departamento(nombre, edificio, piso) 
values ("Comida", "Edificio B", 8);

-- INSERT departamento
INSERT INTO departamento (nombre, edificio, piso) VALUES
('Recursos Humanos', 'Edificio Central', 3),
('Contabilidad', 'Edificio Central', 2),
('Finanzas', 'Torre Norte', 5),
('Marketing', 'Edificio A', 4),
('Ventas', 'Edificio A', 6),
('Sistemas', 'Torre Tecnológica', 8),
('Soporte Técnico', 'Torre Tecnológica', 2),
('Logística', 'Almacén Central', 1),
('Compras', 'Edificio B', 3),
('Dirección General', 'Torre Ejecutiva', 10);

-- INSERT empleados 
INSERT INTO empleados 
(nombre, edad, estado, email, num_telefono, cargo, id_departamento, dni) 
VALUES
('Carlos Rojas', 29, TRUE, 'crojas2@empresa.com', '987650001', 'Analista', 1, '74251896'),
('María López', 34, TRUE, 'mlopez2@empresa.com', '987650002', 'Asistente', 2, '71548963'),
('José Ramírez', 41, FALSE, 'jramirez2@empresa.com', '987650003', 'Contador', 2, '70123654'),
('Ana Torres', 26, TRUE, 'atorres2@empresa.com', '987650004', 'RRHH', 1, '74589632'),
('Luis García', 38, TRUE, 'lgarcia2@empresa.com', '987650005', 'Finanzas', 3, '70984512'),

('Pedro Sánchez', 45, TRUE, 'psanchez2@empresa.com', '987650006', 'Gerente', 10, '69874512'),
('Lucía Fernández', 30, FALSE, 'lfernandez2@empresa.com', '987650007', 'Marketing', 4, '71236589'),
('Miguel Díaz', 27, TRUE, 'mdiaz2@empresa.com', '987650008', 'Vendedor', 5, '73451289'),
('Elena Vargas', 32, TRUE, 'evargas2@empresa.com', '987650009', 'Vendedora', 5, '72145698'),
('Jorge Castillo', 36, FALSE, 'jcastillo2@empresa.com', '987650010', 'Supervisor', 5, '70891234'),

('Sofía Morales', 25, TRUE, 'smorales2@empresa.com', '987650011', 'Soporte Técnico', 7, '74561239'),
('Raúl Peña', 40, TRUE, 'rpena2@empresa.com', '987650012', 'Administrador Sistemas', 6, '70123458'),
('Daniela Cruz', 28, FALSE, 'dcruz2@empresa.com', '987650013', 'Logística', 8, '73214589'),
('Fernando Ortiz', 31, TRUE, 'fortiz2@empresa.com', '987650014', 'Compras', 9, '71984563'),
('Andrea Salazar', 29, TRUE, 'asalazar2@empresa.com', '987650015', 'Logística', 8, '74512368'),

('Kevin Reyes', 24, TRUE, 'kreyes2@empresa.com', '987650016', 'Soporte', 7, '73498512'),
('Valeria Jiménez', 33, FALSE, 'vjimenez2@empresa.com', '987650017', 'Marketing', 4, '71239845'),
('Ricardo Medina', 37, TRUE, 'rmedina2@empresa.com', '987650018', 'Analista', 3, '70127845'),
('Paola Núñez', 26, TRUE, 'pnunez2@empresa.com', '987650019', 'RRHH', 1, '74561287'),
('Héctor Flores', 42, FALSE, 'hflores2@empresa.com', '987650020', 'Jefe Área', 2, '69871234'),

('Camila Ríos', 27, TRUE, 'crios2@empresa.com', '987650021', 'Ventas', 5, '73459812'),
('Andrés Vargas', 35, TRUE, 'avargas2@empresa.com', '987650022', 'Supervisor', 6, '70129845'),
('Natalia Herrera', 30, FALSE, 'nherrera2@empresa.com', '987650023', 'Marketing', 4, '71234567'),
('Sebastián León', 39, TRUE, 'sleon2@empresa.com', '987650024', 'Finanzas', 3, '70987654'),
('Gabriela Paredes', 28, TRUE, 'gparedes2@empresa.com', '987650025', 'RRHH', 1, '74567891'),

('Diego Castro', 31, FALSE, 'dcastro2@empresa.com', '987650026', 'Soporte', 7, '73456789'),
('Laura Mendoza', 29, TRUE, 'lmendoza2@empresa.com', '987650027', 'Compras', 9, '71234987'),
('Francisco Vega', 44, TRUE, 'fvega2@empresa.com', '987650028', 'Director', 10, '69874532'),
('Isabel Romero', 26, TRUE, 'iromero2@empresa.com', '987650029', 'Logística', 8, '74561230'),
('Carlos Huamán', 32, FALSE, 'chuaman2@empresa.com', '987650030', 'Ventas', 5, '70124567'),

('Brenda Soto', 27, TRUE, 'bsoto2@empresa.com', '987650031', 'Marketing', 4, '73451267'),
('Óscar Díaz', 38, TRUE, 'odiaz2@empresa.com', '987650032', 'Finanzas', 3, '70981234'),
('Mariana Quispe', 25, FALSE, 'mquispe2@empresa.com', '987650033', 'RRHH', 1, '74561234'),
('José Pacheco', 41, TRUE, 'jpacheco2@empresa.com', '987650034', 'Contador', 2, '70123469'),
('Elías Rojas', 36, TRUE, 'erojas2@empresa.com', '987650035', 'Supervisor', 6, '71234589'),

('Karen Huerta', 29, FALSE, 'khuerta2@empresa.com', '987650036', 'Soporte', 7, '73451290'),
('Miguel Flores', 33, TRUE, 'mflores2@empresa.com', '987650037', 'Logística', 8, '70129876'),
('Sergio Aguilar', 40, TRUE, 'saguilar2@empresa.com', '987650038', 'Compras', 9, '71239876'),
('Luciana Vega', 27, FALSE, 'lvega2@empresa.com', '987650039', 'Marketing', 4, '74569812'),
('Alberto Núñez', 45, TRUE, 'anunez2@empresa.com', '987650040', 'Gerente General', 10, '69871290'),

('Paulo Rojas', 28, TRUE, 'projas2@empresa.com', '987650041', 'Ventas', 5, '73451234'),
('Valentina Cruz', 31, FALSE, 'vcruz2@empresa.com', '987650042', 'RRHH', 1, '74561298'),
('Javier Peña', 37, TRUE, 'jpena2@empresa.com', '987650043', 'Finanzas', 3, '70127890'),
('Nicolás Torres', 30, TRUE, 'ntorres2@empresa.com', '987650044', 'Soporte', 7, '71234560'),
('Estefanía Ruiz', 26, FALSE, 'eruiz2@empresa.com', '987650045', 'Asistente', 2, '73459876'),

('Tomás Rivas', 28, TRUE, 'trivas2@empresa.com', '987650046', 'Analista Sistemas', 6, '71234599'),
('Diana Salinas', 32, FALSE, 'dsalinas2@empresa.com', '987650047', 'Marketing', 4, '74561299'),
('Erick Mendoza', 35, TRUE, 'emendoza2@empresa.com', '987650048', 'Logística', 8, '70123999'),
('Patricia León', 29, TRUE, 'pleon2@empresa.com', '987650049', 'RRHH', 1, '73459999'),
('Bruno Cabrera', 41, TRUE, 'bcabrera2@empresa.com', '987650050', 'Finanzas', 3, '70989999');

-- Desactivar Verificación de FK para agregar IDs de departamentos que no existen 
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO empleados
(nombre, edad, estado, email, num_telefono, cargo, id_departamento, dni)
VALUES
('Mario Pineda', 30, TRUE, 'mpineda@empresa.com', '987660001', 'Analista', 11, '80000001'),
('Rosa Chávez', 27, TRUE, 'rchavez@empresa.com', '987660002', 'Asistente', 12, '80000002'),
('Julio Vega', 35, FALSE, 'jvega@empresa.com', '987660003', 'Supervisor', 13, '80000003'),
('Patricia Ruiz', 29, TRUE, 'pruiz@empresa.com', '987660004', 'Marketing', 14, '80000004'),
('César León', 41, TRUE, 'cleon@empresa.com', '987660005', 'Ventas', 15, '80000005'),
('Verónica Soto', 32, FALSE, 'vsoto@empresa.com', '987660006', 'Contadora', 16, '80000006'),
('Jhon Mendoza', 25, TRUE, 'jmendoza@empresa.com', '987660007', 'Soporte', 17, '80000007'),
('Natalia Castro', 38, TRUE, 'ncastro@empresa.com', '987660008', 'Logística', 18, '80000008'),
('Renzo Flores', 33, TRUE, 'rflores@empresa.com', '987660009', 'Compras', 19, '80000009'),
('Silvia Torres', 45, FALSE, 'storres@empresa.com', '987660010', 'Gerente', 20, '80000010');

-- Volver Activar la verificación de FK (ES MEJOR POR INTEGRIDAD DE DATOS) 
SET FOREIGN_KEY_CHECKS = 1;

update empleados set id_departamento = 21 where id = 51;

select * from departamento;
select * from empleados;

-- JOIN 
-- INNER JOIN 
-- Muestra los datos que coinciden en cada tabla (INTERSECCIÓN) 
-- FORMAS: Implícita / Explícita 

-- Explícita 
select 
empleados.id as id_empleado,
empleados.nombre as nombre_empleado,
empleados.dni, 
empleados.edad, 
empleados.estado,
empleados.email,
empleados.num_telefono as telefono,
empleados.cargo,
departamento.id as id_departamento,
departamento.nombre as nombre_departamento, 
departamento.edificio,
departamento.piso
from empleados 
inner join departamento 
on empleados.id_departamento = departamento.id
-- where empleados.estado = 0
order by id_departamento asc , empleados.edad asc;

-- IMPLÍCITO 
select * from empleados, departamento 
where empleados.id_departamento = departamento.id
order by empleados.id desc;


-- LEFT JOIN 
select 
empleados.id as id_empleado,
empleados.nombre as nombre_empleado,
empleados.dni, 
empleados.edad, 
empleados.estado,
empleados.email,
empleados.num_telefono as telefono,
empleados.cargo,
departamento.id as id_departamento,
departamento.nombre as nombre_departamento, 
departamento.edificio,
departamento.piso
from empleados 
left join departamento 
on empleados.id_departamento = departamento.id
-- where empleados.estado = 0
order by id_departamento asc , empleados.edad asc, nombre_empleado asc;

-- RIGHT JOIN 
select 
empleados.id as id_empleado,
empleados.nombre as nombre_empleado,
empleados.dni, 
empleados.edad, 
empleados.estado,
empleados.email,
empleados.num_telefono as telefono,
empleados.cargo,
departamento.id as id_departamento,
departamento.nombre as nombre_departamento, 
departamento.edificio,
departamento.piso
from empleados 
right join departamento 
on empleados.id_departamento = departamento.id
-- where empleados.estado = 0
order by id_departamento asc , empleados.edad asc, nombre_empleado asc;


-- UNION (SIMULAR EL FULL OUTER JOIN)
select 
empleados.id as id_empleado,
empleados.nombre as nombre_empleado,
empleados.dni, 
empleados.edad as edad_empleado, 
empleados.estado,
empleados.email,
empleados.num_telefono as telefono,
empleados.cargo,
departamento.id as id_departamento,
departamento.nombre as nombre_departamento, 
departamento.edificio,
departamento.piso
from empleados 
left join departamento 
on empleados.id_departamento = departamento.id
-- where empleados.estado = 1
union
select 
empleados.id as id_empleado,
empleados.nombre as nombre_empleado,
empleados.dni, 
empleados.edad edad_empleado, 
empleados.estado,
empleados.email,
empleados.num_telefono as telefono,
empleados.cargo,
departamento.id as id_departamento,
departamento.nombre as nombre_departamento, 
departamento.edificio,
departamento.piso
from empleados 
right join departamento 
on empleados.id_departamento = departamento.id
-- where empleados.estado = 1
order by id_departamento asc , edad_empleado asc;
