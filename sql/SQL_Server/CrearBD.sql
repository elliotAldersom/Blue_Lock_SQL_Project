-- VER LA VERSIÓN DE SQL SERVER
SELECT @@VERSION AS Version_SQL_Server;

-- CREAR UNA BASE DE DATOS 
CREATE DATABASE SQL_Practicas; 

-- SELECCIONAR LA BASE DE DATOS A UTILIZAR 
USE SQL_Practicas;

-- CREAR UNA TABLA 
CREATE TABLE Productos (
    id INT PRIMARY KEY IDENTITY(1,1), 
    nombre VARCHAR(75) NOT NULL, 
    categoria VARCHAR(50) NOT NULL, 
    stock INT NOT NULL  DEFAULT 0,
    precio DECIMAL(10, 2) NOT NULL  DEFAULT 0.00,

    CONSTRAINT OK_Producto_Stock CHECK (stock >= 0), 
    CONSTRAINT OK_Producto_Price CHECK (precio >= 0.00)
);

-- INSERTAR UN DATO EN LA TABLA 
INSERT INTO Productos(nombre, categoria, stock, precio) 
VALUES 
('Cort G290 Modern', 'Guitarras Eléctricas', 10, 499.99);

-- INSERTAR VARIOS REGISTROS  
INSERT INTO Productos(nombre, categoria, stock, precio) 
VALUES 
('Fender Stratocaster', 'Guitarras Eléctricas', 5, 699.99),
('Gibson Les Paul Standard', 'Guitarras Eléctricas', 3, 1199.99),
('Yamaha FG800', 'Guitarras Acústicas', 15, 199.99),
('Ibanez RG550', 'Guitarras Eléctricas', 7, 899.99),
('Taylor 214ce', 'Guitarras Acústicas', 4, 999.99);

-- INSERTAR SIN STOCK Y PRECIO 
INSERT INTO Productos(nombre, categoria) 
VALUES 
('Epiphone Les Paul Standard', 'Guitarras Eléctricas'); 

-- MOSTRAR LOS DATOS DE LA TABLA 
SELECT * FROM Productos;

-- ELIMINAR TODOS LOS DATOS DE LA TABLA SIN BORRAR LA TABLA Y REINICAR EL ID DESDE 1 
TRUNCATE TABLE Productos; 

-- ELIMINAR LA TABLA COMPLETAMENTE 
DROP TABLE Productos;