USE TiendaLogistica; 
GO

-- FUNCIONES DE TEXTO 

-- CONCAT(column1, column2, columnN) : Unir N columnas y texto 
SELECT TOP 5 
    nombre_producto, 
    precio_unitario,
    CONCAT('El producto ',nombre_producto, ' cuesta ', precio_unitario) AS descripcion
FROM 
    dbo.productos; 
GO 

-- UPPER(column) : Mayúsculas 
SELECT TOP 5
    nombre_producto, 
    UPPER(nombre_producto) AS nombre_mayuscula
FROM 
    dbo.productos;
GO

-- LOWER(column) : Convierte a minúsculas 
SELECT TOP 5
    nombre_producto, 
    LOWER(nombre_producto) AS nombre_minuscula
FROM 
    dbo.productos;
GO
-- LEN(columna) : Devuelve el número exacto de caracteres (no cuenta espacios finales)
SELECT TOP 5
    nombre_producto, 
    LEN(nombre_producto) AS total_caracteres
FROM 
    dbo.productos;
GO

-- SUBSTRING(columna, inicio, longitud): Extra una posición específica de una columna 
SELECT TOP 5
    nombre_producto, 
    SUBSTRING(nombre_producto, 1, 3) AS abreviatura 
FROM 
    dbo.productos;
GO

-- REPLACE(columna, "texto_buscar", "texto_nuevo"): Reemplaza una subcadena dentro de un texto por otro
SELECT TOP 5
    nombre, 
    email AS email_old, 
    REPLACE(email, '@email.com', '@tiendalogistica.com.pe') AS email_new
FROM 
    dbo.clientes;
GO 


-- LTRIM(colum) / RTRIM(column) : QUitar espacios L (Left) y R (Right)
-- CON ESPACIOS EXTRAS
SELECT TOP 5 
    nombre_producto, 
    precio_unitario,
    CONCAT('     El producto ',nombre_producto, ' cuesta ', precio_unitario, '    ') AS descripcion
FROM 
    dbo.productos; 
GO 

-- SIN ESPACIOS EXTRAS EN LEFT
SELECT TOP 5 
    nombre_producto, 
    precio_unitario,
    LTRIM(CONCAT('     El producto ',nombre_producto, ' cuesta ', precio_unitario, '    ')) AS descripcion
FROM 
    dbo.productos; 
GO 

-- SIN ESPACIOS EXTRAS EN RIGHT
SELECT TOP 5 
    nombre_producto, 
    precio_unitario,
    RTRIM(CONCAT('     El producto ',nombre_producto, ' cuesta ', precio_unitario, '    ')) AS descripcion
FROM 
    dbo.productos; 
GO 

-- LEFT(columna, n) / RIGHT(columna, n): Extraer una cantidad específica de caracteres 
SELECT 
    nombre, 
    email, 
    RIGHT(email, 3) AS dominio_corto
FROM 
    dbo.clientes; 
GO 

-- FUNCIONES NUMÉRICAS y Metemáticas 
-- ROUND(columna, decimales): Redondear un valor al número de decimale especifícado
SELECT TOP 5
    nombre_producto,
    precio_unitario, 
    ROUND(precio_unitario * 1.18, 2) AS precio_igv
FROM 
    dbo.productos; 
GO

-- Si el ROUND no se da por el tipo de dato, forzar con CAST(columna AS tipo_dato)
SELECT TOP 5
    nombre_producto,
    precio_unitario, 
    CAST((precio_unitario * 1.18) AS decimal(10,2)) AS precio_igv
FROM 
    dbo.productos; 
GO

-- POWER(column, exponete): Elevar a un exponente 
SELECT TOP 5
    nombre_producto, 
    precio_unitario, 
    POWER(precio_unitario, 3) as precio_cubo
FROM 
    dbo.productos;
GO

-- ABS(numero): devuelve el valor absoluto (positivo) de un número 
SELECT ABS(-12) AS number_abs;
GO

-- CEILING(numero) : Redondea hacia arriba (entero más cercano)
SELECT CEILING(1.1) AS result;
GO

-- FLOOR(numero) : Redondea hacia abajo (entero más cercano)
SELECT FLOOR(-1.2) AS result;
GO 

-- TRUNCAR UN NUMERO 
SELECT CAST(12.990 AS int) AS result_integer
GO