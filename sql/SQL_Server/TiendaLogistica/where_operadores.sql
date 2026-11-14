-- Usar la BD 
use TiendaLogistica; 
GO 

-- QUERYS con WHERE 
-- Agrega una condición de filtrado que ejecuta row by row 
SELECT 
    * 
FROM 
pedidos
WHERE estado = 'completado'; -- Filter all rows where the column value equals 'completado'
GO

-- OPERADORES RELACIONALES : > , < , = , != , <> , >= , <= 
-- <> y != : Distinton de

-- Clientes de paises distintos de Perú
SELECT 
    * 
FROM clientes 
WHERE
    pais <> 'Perú';
GO 

-- OPERADORES LÓGICOS : AND , OR , NOT 

-- Clientes de Perú pero con ciudad distinta a Lima
SELECT 
    * 
FROM clientes 
WHERE
    pais = 'Perú' AND ciudad != 'Lima'; 
GO 

-- Clientes de Chile o ciudad Lima 
SELECT 
    * 
FROM clientes 
WHERE
    pais = 'Chile' OR ciudad = 'Lima'; 
GO 

-- Ciudad Lima y Pais Perú y nombre Carlos 
SELECT 
    * 
FROM clientes 
WHERE
    pais = 'Perú' AND ciudad = 'Lima' AND nombre = 'Carlos'; 
GO 

-- productos con stock menor a 50 y precio_unitario mayor a 500
SELECT 
    * 
FROM  
    productos
WHERE 
    stock < 50 AND precio_unitario > 500;
GO

-- Ver clientes registrados después del 01 de febrero del 2025 

SELECT 
    * 
FROM  
    clientes
WHERE 
    fecha_registro > '2025-02-01' AND pais ='Perú';
GO

-- OPERADOR DE PERTENENCIA 'IN' y 'NOT IN'

-- clientes cuyos paises sean de Perú o Chile <<IN>>
SELECT 
    * 
FROM  
    clientes 
WHERE pais IN ('Perú', 'Chile');
GO 

-- clientes cuyo pais no sea de Perú o Chile <<NOT IN>>
SELECT 
    * 
FROM  
    clientes 
WHERE pais NOT IN ('Perú', 'Chile');
GO 

-- OPERADOR DE RANGOS 'BETWEEN' => entre
-- stock de productos entre 10 y 70 <<BETWEEN>>
SELECT 
    * 
FROM  
    productos 
WHERE stock BETWEEN 10 AND 70;
GO

-- OPERADOR PARA BUSCAR PATRONES 'LIKE' => como 
-- COMODIN '%' => cualquier caracter
-- UN CARACTER '_' => representa un caracter cualquiera

-- Search in 'productos' for rows where the 'nombre_producto' column starts with 'L'
SELECT 
    * 
FROM 
    productos 
WHERE nombre_producto LIKE 'L%'
GO

-- Search in 'productos' for rows where the 'nombre_producto' column ends with 'L'
SELECT 
    * 
FROM 
    productos 
WHERE nombre_producto LIKE '%L'
GO

-- Search in 'productos' for rows where the 'nombre_producto' column contains 'L'
SELECT 
    * 
FROM 
    productos 
WHERE nombre_producto LIKE '%L%'
GO


-- Search in 'productos' for rows where the fourth character in 'nombre_producto' is 'L'
SELECT 
    * 
FROM 
    productos 
WHERE nombre_producto LIKE '___L%'
GO

