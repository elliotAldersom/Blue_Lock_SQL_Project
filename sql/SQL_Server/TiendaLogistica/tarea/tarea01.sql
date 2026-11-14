-- ==============================================================================
-- TAREA 01: CONSULTAS BÁSICAS (SELECT, FROM, ALIAS Y COLUMNAS CALCULADAS)
-- Base de Datos: TiendaLogistica
-- Instrucción: Lee cada enunciado y escribe debajo de cada comentario tu consulta SQL.
-- ==============================================================================

USE TiendaLogistica;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 1: Proyección básica y alias de columnas
-- Escribe una consulta que muestre el 'nombre_producto' y el 'precio_unitario' 
-- de la tabla 'dbo.productos'. Renombra las columnas en el resultado usando alias 
-- para que aparezcan como 'Producto' y 'PrecioActual'.
-- ------------------------------------------------------------------------------

SELECT 
    nombre_producto AS Producto,
    precio_unitario AS PrecioActual
FROM productos;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 2: Concatenación de columnas de texto
-- En la tabla 'dbo.clientes', selecciona el 'nombre' y el 'apellido'. Crea una 
-- nueva columna calculada llamada 'nombre_completo' que una ambos campos en una 
-- sola cadena de texto separada por un espacio (puedes usar el operador +).
-- ------------------------------------------------------------------------------

SELECT 
    nombre, 
    apellido, 
    (nombre + ' ' + apellido) AS nombre_completo 
FROM clientes;
GO

SELECT 
    nombre, 
    apellido, 
    CONCAT(nombre, ' ' , apellido) AS nombre_completo 
FROM clientes;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 3: Cálculo de inventario total
-- Utilizando la tabla 'dbo.productos', muestra el nombre del producto, su stock 
-- actual y crea una nueva columna llamada 'valor_inventario_teorico' que resulte 
-- de multiplicar el 'stock' por el 'precio_unitario'.
-- ------------------------------------------------------------------------------

SELECT  
    nombre_producto AS Producto, 
    stock, 
    (stock * precio_unitario) AS valor_inventario_teorico 
FROM productos;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 4: Añadir una columna estática (Literal)
-- Selecciona todos los registros de la tabla 'dbo.clientes' (mostrando nombre, 
-- apellido y ciudad), pero añade una columna adicional al final que contenga 
-- el texto estático 'Perú' renombrada con el alias 'pais_origen'.
-- ------------------------------------------------------------------------------

SELECT 
    nombre,
    apellido,
    ciudad,
    ('Perú') AS pais_origen 
FROM clientes;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 5: Proyección con simulación de aumento de precios
-- Imagina que la tienda planea subir un 15% el precio de todos sus productos. 
-- Desde la tabla 'dbo.productos', muestra el 'nombre_producto', el 'precio_unitario' 
-- actual, y crea una columna calculada llamada 'precio_futuro_15' que muestre 
-- el precio incrementado en un 15% (precio_unitario * 1.15).
-- ------------------------------------------------------------------------------

SELECT 
    nombre_producto, 
    precio_unitario AS precio_actual, 
    (precio_unitario * 1.15) AS precio_futuro_15
FROM productos;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 6: Formato de identificación de clientes
-- En la tabla 'dbo.clientes', genera una consulta que muestre el 'email' y la 
-- 'ciudad', y crea una nueva columna calculada llamada 'contacto_resumen' que 
-- concatene el correo y la ciudad con un texto intermedio 
-- (por ejemplo: email + ' - Reside en: ' + ciudad).
-- ------------------------------------------------------------------------------

SELECT 
    email, 
    ciudad, 
    CONCAT(email, ' - Reside en: ', ciudad) AS contacto_resumen 
FROM clientes;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 7: Cálculo del subtotal por línea de detalle
-- En la tabla 'dbo.detalle_pedidos', muestra el 'pedido_id', el 'producto_id', 
-- la 'cantidad', el 'precio_venta' unitario, y añade una nueva columna calculada 
-- llamada 'subtotal_linea' que resulte de multiplicar la 'cantidad' por el 'precio_venta'.
-- ------------------------------------------------------------------------------

SELECT 
    pedido_id, 
    producto_id, 
    cantidad, 
    precio_venta, 
    (cantidad * precio_venta) AS subtotal_linea
FROM detalle_pedidos;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 8: Aplicando un descuento hipotético
-- Selecciona de la tabla 'dbo.productos' el 'nombre_producto' y el 'precio_unitario'. 
-- Crea una columna calculada llamada 'precio_con_descuento_20' que calcule el 
-- precio del producto aplicando un descuento del 20% (precio_unitario * 0.80).
-- ------------------------------------------------------------------------------

SELECT 
    nombre_producto, 
    precio_unitario, 
    (precio_unitario * 0.8) AS precio_con_descuento_20
FROM productos;
GO

-- ------------------------------------------------------------------------------
-- Ejercicio 9: Alias complejos en cabeceras de pedidos
-- De la tabla 'dbo.pedidos', muestra los campos 'pedido_id', 'fecha_pedido' y 
-- 'total_pedido'. Utiliza alias en todas las columnas para que el resultado se 
-- muestre con las cabeceras: 'CodigoPedido', 'FechaRealizacion' y 'MontoTotal'.
-- ------------------------------------------------------------------------------

SELECT 
    pedido_id AS CodigoPedido, 
    fecha_pedido AS FechaRealizacion, 
    total_pedido AS MontoTotal
FROM pedidos; 
GO 

-- ------------------------------------------------------------------------------
-- Ejercicio 10: Reto integral de columnas y constantes
-- Construye una consulta sobre la tabla 'dbo.detalle_pedidos' que devuelva:
-- 1. El identificador del detalle ('detalle_id').
-- 2. Una columna calculada llamada 'unidades_vendidas' igual a la 'cantidad'.
-- 3. Una columna calculada llamada 'total_recaudado' que multiplique 'cantidad' por 'precio_venta'.
-- 4. Una columna estática con el texto 'Transaccion Valida' y el alias 'estado_verificacion'.
-- ------------------------------------------------------------------------------

SELECT 
    detalle_id, 
    cantidad AS unidades_vendidas,
    (cantidad * precio_venta) AS total_recaudado,
    ('Transaccion Valida') AS estado_verificacion
FROM detalle_pedidos; 
GO