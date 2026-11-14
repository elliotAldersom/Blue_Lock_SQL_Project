use TiendaLogistica;
GO 

-- Ordenar los precios por precio_unitario ASC (ascendentemente)
SELECT 
    * 
FROM 
    dbo.productos 
ORDER BY precio_unitario ASC; 
GO


-- Ordenar los precios por precio_unitario DESC (descendentemente)
SELECT 
    * 
FROM 
    dbo.productos 
ORDER BY precio_unitario DESC; 
GO


-- Ordenar los precios por precio_unitario descendentemente y stock ascendentemente
SELECT 
    * 
FROM 
    dbo.productos 
ORDER BY precio_unitario DESC, stock ASC; 
GO

-- Ordenar ciduad desc y nombre asc 
SELECT 
    ciudad,
    nombre,
    apellido
FROM 
    dbo.clientes
ORDER BY ciudad DESC, nombre ASC;

-- Ordenar estado y total_pedido de forma asc 
SELECT 
    * 
FROM 
    dbo.pedidos 
ORDER BY estado ASC, total_pedido ASC

