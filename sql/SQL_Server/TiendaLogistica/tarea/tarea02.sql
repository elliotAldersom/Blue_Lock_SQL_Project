USE TiendaLogistica;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 1: Filtrar nombres con comodines al final
-- En la tabla 'dbo.productos', selecciona el 'nombre_producto' y el 'precio_unitario' 
-- para aquellos productos cuyo nombre termine exactamente con la palabra "UHD" 
-- utilizando el comodín '%' con LIKE.
-- ------------------------------------------------------------------------------
SELECT 
    nombre_producto, 
    precio_unitario 
FROM  
    dbo.productos 
WHERE nombre_producto LIKE '%UHD' 
GO 

-- ------------------------------------------------------------------------------
-- Ejercicio 2: Uso de múltiples comodines y condiciones lógicas
-- En la tabla 'dbo.clientes', busca el 'nombre', 'apellido' y 'email' de los 
-- clientes cuyo correo electrónico contenga el dominio '@email.com' 
-- Y cuya ciudad sea exactamente 'Lima'.
-- ------------------------------------------------------------------------------
SELECT 
    nombre, 
    apellido,
    email AS 'correo' 
FROM  
    dbo.clientes
WHERE 
    email LIKE '%@email.com%' AND -- pude haber sido '%@email.com' => pero dice contenga
    ciudad = 'Lima';
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 3: Patrones con posición fija estricta (Tercer carácter)
-- En la tabla 'dbo.clientes', busca el 'nombre' y el 'apellido' de los clientes 
-- cuyo nombre tenga una letra específica en su tercer carácter 
-- (utiliza guiones bajos '_' para las dos primeras posiciones y '%' al final).
-- ------------------------------------------------------------------------------
SELECT 
    nombre, 
    apellido 
FROM  
    dbo.clientes 
WHERE 
    nombre LIKE '__e%'
GO 

-- ------------------------------------------------------------------------------
-- Ejercicio 4: Exclusión estricta de patrones con NOT LIKE
-- En la tabla 'dbo.productos', selecciona el 'nombre_producto' y la 'categoria_id' 
-- de todos los artículos cuyos nombres NO comiencen con la letra 'L' (mayúscula).
-- ------------------------------------------------------------------------------
SELECT 
    nombre_producto, 
    categoria_id
FROM
    dbo.productos
WHERE 
    nombre_producto NOT LIKE 'L%'
GO 


-- ------------------------------------------------------------------------------
-- Ejercicio 5: Reto integral con WHERE, IN, BETWEEN y NOT LIKE
-- En la tabla 'dbo.productos', selecciona el 'nombre_producto', 'precio_unitario' y 'stock'. 
-- Aplica el siguiente filtro complejo: 
-- El producto debe pertenecer a la categoría 1 o 3 (usa IN), 
-- su precio debe estar entre 50.00 y 1000.00 (usa BETWEEN), 
-- y su nombre NO debe contener la letra 'r' en su tercera posición (usa NOT LIKE con guiones bajos).
-- ------------------------------------------------------------------------------
SELECT 
    nombre_producto, 
    precio_unitario, 
    stock 
FROM 
    dbo.productos
WHERE 
    categoria_id IN (1, 3) AND 
    precio_unitario BETWEEN 50.00 AND 1000.00 AND 
    nombre_producto NOT LIKE '__r%'
GO