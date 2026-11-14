-- ==========================================================
-- 1. CREAR Y SELECCIONAR LA BASE DE DATOS
-- ==========================================================
CREATE DATABASE TiendaLogistica;
GO

USE TiendaLogistica;
GO

-- ==========================================================
-- 2. CREACIÓN DE TABLAS (ESTRUCTURA RELACIONAL)
-- ==========================================================

-- Tabla de Categorías
CREATE TABLE categorias (
    categoria_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);
GO

-- Tabla de Productos
CREATE TABLE productos (
    producto_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(150) NOT NULL,
    categoria_id INT FOREIGN KEY REFERENCES categorias(categoria_id),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);
GO

-- Tabla de Clientes
CREATE TABLE clientes (
    cliente_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    ciudad VARCHAR(100),
    pais VARCHAR(50),
    fecha_registro DATE
);
GO

-- Tabla de Pedidos (Cabecera)
CREATE TABLE pedidos (
    pedido_id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT FOREIGN KEY REFERENCES clientes(cliente_id),
    fecha_pedido DATETIME NOT NULL,
    estado VARCHAR(50) NOT NULL,
    total_pedido DECIMAL(10, 2)
);
GO

-- Tabla de Detalle de Pedidos
CREATE TABLE detalle_pedidos (
    detalle_id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT FOREIGN KEY REFERENCES pedidos(pedido_id),
    producto_id INT FOREIGN KEY REFERENCES productos(producto_id),
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10, 2) NOT NULL
);
GO

-- ==========================================================
-- 3. INSERCIÓN DE DATOS DE PRUEBA
-- ==========================================================

-- Insertar Categorías
INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Tecnología', 'Dispositivos electrónicos, computo y accesorios'),
('Línea Blanca', 'Electrodomésticos grandes para el hogar'),
('Audio y Video', 'Televisores, equipos de sonido y consolas'),
('Oficina', 'Muebles, escritorios y accesorios de papelería');
GO

-- Insertar Productos
INSERT INTO productos (nombre_producto, categoria_id, precio_unitario, stock) VALUES
('Laptop Gamer 15.6"', 1, 1250.00, 45),
('Mouse Inalámbrico Ergonómico', 1, 25.50, 150),
('Teclado Mecánico RGB', 1, 85.00, 80),
('Refrigeradora Inverter 400L', 2, 850.00, 15),
('Lavadora Automática 18kg', 2, 620.00, 20),
('Smart TV 65" 4K UHD', 3, 750.00, 30),
('Barra de Sonido Dolby Atmos', 3, 290.00, 50),
('Escritorio Ejecutivo en L', 4, 210.00, 25),
('Silla Ergonómica de Malla', 4, 180.00, 40);
GO

-- Insertar Clientes
INSERT INTO clientes (nombre, apellido, email, ciudad, pais, fecha_registro) VALUES
('Carlos', 'Mendoza', 'carlos.mendoza@email.com', 'Lima', 'Perú', '2025-01-15'),
('Lucía', 'Fernández', 'lucia.fernandez@email.com', 'Arequipa', 'Perú', '2025-02-10'),
('Mateo', 'Silva', 'mateo.silva@email.com', 'Bogotá', 'Colombia', '2025-03-01'),
('Sofía', 'Rojas', 'sofia.rojas@email.com', 'Santiago', 'Chile', '2025-03-20'),
('Alejandro', 'Vargas', 'alejandro.vargas@email.com', 'Lima', 'Perú', '2025-04-05');
GO

-- Insertar Pedidos
INSERT INTO pedidos (cliente_id, fecha_pedido, estado, total_pedido) VALUES
(1, '2026-03-10 14:20:00', 'Completado', 1335.00),
(2, '2026-03-12 09:15:00', 'Procesando', 850.00),
(3, '2026-03-15 18:40:00', 'Completado', 1040.00),
(1, '2026-03-18 11:05:00', 'Enviado', 290.00),
(4, '2026-03-20 16:30:00', 'Completado', 390.00);
GO

-- Insertar Detalle de Pedidos
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_venta) VALUES
(1, 1, 1, 1250.00),
(1, 2, 3, 25.50),
(2, 4, 1, 850.00),
(3, 6, 1, 750.00),
(3, 3, 3, 85.00),
(4, 7, 1, 290.00),
(5, 8, 1, 210.00),
(5, 9, 1, 180.00);
GO

-- ==== ==== ==== ==== ==== ==== ==== ==== 