use TiendaLogistica; 
GO 

-- Manejo de Valores NULOS 
-- Operados IS 

-- IS NULL -> Te dará los nulos 
-- IS NOT NULL -> Te dará los NO nulos 

-- Obtener clientes con ciudad NULL 
SELECT 
    * 
FROM 
    dbo.clientes 
WHERE 
    ciudad IS NULL;
GO

-- Obtener clientes con ciudad NO NULL 
SELECT 
    * 
FROM  
    dbo.clientes 
WHERE
    ciudad IS NOT NULL;
GO

-- Precedencia de los OPERADORES LÓGICOS 
-- AND > OR (Mayor prioridad)
-- BUT: NO usas '()' para separar expresiones 
-- se evaluará de Izquierda -> Derecha 

-- ==============================================

-- Seleccionar a todos los productos que no sean categoria_id ni 3 ni la 4 
SELECT 
    * 
FROM 
    dbo.productos 
WHERE 
    categoria_id NOT IN (3, 4);
GO

-- Seleccionar a los pedidos cuyos total_pedido no esté entre 300 a 1000
SELECT 
    * 
FROM  
    dbo.pedidos 
WHERE 
    total_pedido NOT BETWEEN 300 AND 1000;
GO

-- De la tabla 'detalle_pedidos', extrae la columna 'precio_venta' dónde  NO debe 
-- encontrarse entre 10 y 100
SELECT 
    precio_venta 
FROM  
    dbo.detalle_pedidos 
WHERE 
    precio_venta NOT BETWEEN 10 AND 100

-- Productos cuyo precio_unitario no esté entre 100 a 500
SELECT 
    nombre_producto,
    categoria_id,
    precio_unitario 
FROM    
    dbo.productos
WHERE 
    precio_unitario NOT BETWEEN 100 AND 500


-- | TOP |  ORDER BY
SELECT TOP 5 -- Primeros 5
    * 
FROM  
    detalle_pedidos;


-- OBTENER LOS ÚLTIMOS 5 de precio_venta de forma ascendente 
SELECT  TOP 5 -- Primeros 5 de la consulta
    * 
FROM 
    detalle_pedidos
ORDER BY precio_venta DESC -- Orden Descendente de mayor a menor 

