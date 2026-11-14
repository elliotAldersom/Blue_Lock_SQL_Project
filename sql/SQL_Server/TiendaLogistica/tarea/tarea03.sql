USE TiendaLogistica; 
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 1: Manejo de valores nulos (IS NULL)
-- Supón que un cliente no tiene ciudad registrada. Escribe una consulta sobre 
-- la tabla 'dbo.clientes' que permita listar los registros donde el campo 'ciudad' 
-- sea nulo (puedes simularlo o validar la estructura). Muestra nombre y email.
-- ------------------------------------------------------------------------------
SELECT 
    nombre, 
    email 
FROM 
    dbo.clientes 
WHERE 
    ciudad IS NULL;
GO
-- ------------------------------------------------------------------------------
-- Ejercicio 2: Precedencia de operadores lógicos con paréntesis
-- En la tabla 'dbo.productos', selecciona el 'nombre_producto', 'categoria_id' 
-- y 'precio_unitario' para aquellos productos que pertenezcan a la categoría 1 
-- O a la categoría 3, PERO asegurando mediante paréntesis que ambos estén obligados 
-- a tener un stock mayor a 30 unidades (stock > 30).
-- ------------------------------------------------------------------------------
SELECT 
    nombre_producto, 
    categoria_id, 
    precio_unitario
FROM 
    dbo.productos 
WHERE 
    (categoria_id IN (1,3)) AND 
    (stock > 30); 
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 3: Uso avanzado de exclusión con NOT IN
-- En la tabla 'dbo.clientes', muestra el 'nombre', 'apellido' y 'ciudad' 
-- de los clientes cuyas ciudades NO pertenezcan al conjunto de ciudades 
-- ('Lima', 'Arequipa').
-- ------------------------------------------------------------------------------
SELECT 
    nombre, 
    apellido,
    ciudad 
FROM 
    dbo.clientes
WHERE 
    ciudad NOT IN ('Lima', 'Arequipa'); 
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 4: Filtros avanzados combinando fechas y estados con paréntesis
-- En la tabla 'dbo.pedidos', selecciona el 'pedido_id', 'fecha_pedido', 'estado' 
-- y 'total_pedido' para aquellos pedidos cuyo estado sea 'Completado' o 'Enviado' 
-- (agrupado con paréntesis) Y cuyo 'total_pedido' sea mayor a 300.00.
-- ------------------------------------------------------------------------------
SELECT 
    pedido_id, 
    fecha_pedido,
    estado,
    total_pedido 
FROM 
    dbo.pedidos
WHERE
    (estado IN ('Completado', 'Enviado')) AND 
    (total_pedido > 300);
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 5: Reto Integral Avanzado de Filtrado
-- En la tabla 'dbo.productos', muestra el 'nombre_producto', 'categoria_id', 
-- 'precio_unitario' y 'stock'. Aplica el siguiente filtro multinivel:
-- 1. El producto NO debe pertenecer a la categoría 2 (usa NOT IN o `<>`).
-- 2. Su precio unitario NO debe estar entre 100.00 y 500.00 (usa NOT BETWEEN).
-- 3. Su stock debe ser menor o igual a 80 unidades.
-- ------------------------------------------------------------------------------
SELECT 
    nombre_producto, 
    categoria_id, 
    precio_unitario,
    stock
FROM 
    dbo.productos
WHERE 
    (categoria_id NOT IN (2)) AND 
    (precio_unitario NOT BETWEEN 100 AND 500) AND 
    (stock <= 80); 
GO