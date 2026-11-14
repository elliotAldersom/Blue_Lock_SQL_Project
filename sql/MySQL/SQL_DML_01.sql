use bdEjemplo;
-- SQL : Structured Query Language 
-- DML : Data Manipulation Language / Lenguaje de Manipulación de Datos 
-- DEFINICIÓN: 
-- Se utiliza para gestionar los datos dentro de los objetos de la Base de Datos 
-- (insertar, actualizar, eliminar y consultar datos). 

-- Principales Sentencias: 
-- SELECT : Consultar datos 
-- INSERT : Insertar datos 
-- UPDATE : Actualizar datos 
-- DELTE : Eliminar datos 

-- EJM de SELECT : Seleccionar datos de una tabla 
select * from empleados where id=1;
select * from empleados; 
select nombre, costo, stock, descripcion, categoria from productos;
select * from productos;
select nombre, stock, descripcion, costo, categoria from productos where (costo > 1000) and (stock >= 30);

-- ==== ==== ==== ====

-- EJM de INSERT : Insertar datos a una tabla 
insert into empleados(nombre, edad, estado, email, num_telefono, cargo) 
values("Luis", 18, 1, "luisOficial@gmail.com", "123456123", default);

insert into empleados(nombre, edad, estado, email, num_telefono, cargo) 
values
("Ana", 19, 1, "AnaOficial@gmail.com", "123456125", "secretaria"),
("José", 22, 1, "JosesitoYolo@gmail.com", 345123678, "gerente");

insert into productos(nombre, costo, stock, descripcion, categoria) 
values ("Valeton GP200X", 1850.75, 25, "Pedalera Multiefectos", "Multiefectos");

insert into productos(nombre, costo, stock, descripcion, categoria) 
values ("Nux MG30", 1150, 50, "Pedalera Multiefectos", "Multiefectos");

insert into productos(nombre, costo, stock, descripcion, categoria) 
values 
("Les Paul Standart", 7150, 590, "Guitarra Les Paul Gibson Original", "Guitarra"),
("Alvaro N20", 850, 75, "Guitarra Española", "Guitarra");

-- ==== ==== ==== ====

-- EJM de UPDATE : Actualizar un registro de una tabla 
update productos set stock = 120 where id = 2;

update productos
set stock = 600, costo = 4750.90 
where id = 1;

-- Hice esto para usar el backup que es mi copia de seguridad
update productos 
set costo = 1000;

-- EJM de DELETE : Eliminar un registro 
-- Vaciar la tabla, pero el ID no vuelve a comenzar desde el 1 
-- sino desde donde se quedó el último registro 
delete from productos; 

-- Eliminar un registro de tabla
delete from productos where id = 3; 

use bdejemplo;
alter table productos rename column costo to precio;

INSERT INTO productos (nombre, precio, stock, descripcion, categoria)
VALUES 
  ('Laptop', 899.99, 10, 'Laptop de alto rendimiento', 'Electrónica'),
  ('Mouse inalámbrico', 25.50, 50, 'Mouse óptico con conexión inalámbrica', 'Accesorios'),
  ('Teclado mecánico', 79.99, 25, 'Teclado mecánico retroiluminado', 'Accesorios'),
  ('Monitor 24"', 150.75, 15, 'Monitor Full HD 24 pulgadas', 'Electrónica'),
  ('Silla ergonómica', 199.90, 5, 'Silla ergonómica con soporte lumbar', 'Mobiliario'),
  ('Impresora láser', 249.99, 8, 'Impresora láser de alta velocidad', 'Oficina'),
  ('Webcam HD', 45.00, 30, 'Webcam con resolución HD', 'Accesorios'),
  ('Disco SSD 512GB', 120.00, 12, 'Disco SSD rápido', 'Almacenamiento'),
  ('Cámara deportiva', 199.99, 20, 'Cámara compacta resistente al agua', 'Electrónica'),
  ('Parlantes Bluetooth', 65.75, 40, 'Parlantes inalámbricos Bluetooth', 'Accesorios'),
  ('Router WiFi', 89.99, 18, 'Router dual band WiFi', 'Oficina'),
  ('Auriculares gaming', 59.99, 25, 'Auriculares con micrófono para gaming', 'Accesorios'),
  ('Tablet 10"', 299.99, 12, 'Tablet de 10 pulgadas con Android', 'Electrónica'),
  ('Lámpara LED', 35.99, 22, 'Lámpara LED de escritorio', 'Mobiliario'),
  ('Ratón gamer', 49.99, 15, 'Ratón gamer con iluminación RGB', 'Accesorios');
  
INSERT INTO productos (nombre, precio, stock, descripcion, categoria)
VALUES 
  ('Guitarra acústica', 150.00, 10, 'Guitarra acústica de madera', 'Música'),
  ('Piano digital', 550.00, 5, 'Piano digital con múltiples sonidos', 'Música'),
  ('Batería electrónica', 400.00, 7, 'Batería electrónica con pads sensibles', 'Música'),
  ('Violín eléctrico', 300.00, 8, 'Violín eléctrico con amplificación', 'Música'),
  ('Saxofón alto', 250.00, 6, 'Saxofón alto de latón', 'Música'),
  ('Trompeta', 180.00, 12, 'Trompeta clásica de latón', 'Música'),
  ('Acordeón', 220.00, 4, 'Acordeón con botones cromáticos', 'Música'),
  ('Flauta traversa', 120.00, 15, 'Flauta de metal cromada', 'Música'),
  ('Guitarra eléctrica', 250.00, 9, 'Guitarra eléctrica con pastillas activas', 'Música'),
  ('Bajo eléctrico', 300.00, 10, 'Bajo eléctrico de 4 cuerdas', 'Música'),
  ('Cajón peruano', 80.00, 20, 'Cajón de percusión tradicional', 'Música'),
  ('Arpa', 700.00, 3, 'Arpa de concierto con cuerdas de nylon', 'Música'),
  ('Batería acústica', 450.00, 6, 'Batería acústica completa', 'Música'),
  ('Teclado Casio', 220.00, 10, 'Teclado portátil Casio con ritmos', 'Música'),
  ('Trombón', 260.00, 7, 'Trombón con varas de latón', 'Música'),
  ('Ocarina', 45.00, 25, 'Ocarina de cerámica decorada', 'Música'),
  ('Banjo', 300.00, 5, 'Banjo de 5 cuerdas', 'Música'),
  ('Clarinete', 190.00, 12, 'Clarinete de madera con llave', 'Música'),
  ('Tambores africanos', 120.00, 18, 'Tambores djembe de origen africano', 'Música'),
  ('Ukelele', 90.00, 20, 'Ukelele de 4 cuerdas', 'Música'),
  ('Armónica', 35.00, 30, 'Armónica cromática de 10 hoyos', 'Música');


select * from productos;

