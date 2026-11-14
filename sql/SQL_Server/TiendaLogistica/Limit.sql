USE TiendaLogistica; 
GO

-- En SQL Server no se usa la palabra 'LIMIT' sino 'TOP' 
-- Igual ambos limita a las N registros que pidas. 

-- Trae los 3 prodcutos más caros.
SELECT TOP 3
    * 
FROM 
    dbo.productos 
ORDER BY precio_unitario DESC;
GO

-- 30% de los productos con mayor stop 
SELECT TOP 30 PERCENT 
    * 
FROM 
    dbo.productos
ORDER BY precio_unitario DESC 

-- OFFSET and FETCH NEXT   => usan ROWS y ONLY
-- Ambos se usan después del ORDER BY
-- SALTARSE ALGUNOS REGISTROS COMO LOS PRIMEROS 2 O 3  
-- OFFSET: Desplazamiento 
-- FETCH NEXT: Obtener el siguiente
SELECT 
    nombre_producto,
    precio_unitario
FROM 
    dbo.productos
ORDER BY producto_id ASC
OFFSET 2 ROWS 
FETCH NEXT 3 ROWS ONLY;