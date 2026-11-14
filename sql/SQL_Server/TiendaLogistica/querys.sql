-- SELECT BD FOR WORKING 
USE TiendaLogistica;
GO

-- QUERYS 
-- Seleccionar todo de clientes.
SELECT * 
FROM clientes;
GO

-- Seleccionar todo de productos.
SELECT * 
FROM productos; 
GO

-- Seleccionar todo de categorias.
SELECT * 
FROM categorias; 
GO 

-- Seleccionar todo de pedidos-
SELECT * 
FROM pedidos; 
GO 

-- Seleccionar todo de detalle_pedidos.
SELECT * 
FROM detalle_pedidos; 

-- COLOCAR UN ALIAS A COLUMNAS (column_original AS alias_column) 
SELECT  
    nombre_producto AS Name, 
    precio_unitario AS Price, 
    stock,
    (precio_unitario * stock) AS Total_Value_Stock
FROM productos;
GO

-- dbo = Database Owner (propietario de la Base de Datos).

-- Seleccionar fecha_pedido, estado y total_pedido de la tabla pedidos.
SELECT 
    fecha_pedido AS Order_Date, 
    estado AS Order_Status, 
    total_pedido AS Total_Order_Amount
FROM pedidos;
GO

