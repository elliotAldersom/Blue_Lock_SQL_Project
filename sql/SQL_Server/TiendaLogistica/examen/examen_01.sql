-- ==============================================================================
-- EXAMEN PRÁCTICO INTEGRAL DE SQL SERVER (10 PREGUNTAS)
-- Base de Datos: TiendaLogistica
-- Temas: SELECT, FROM, Alias, Columnas Calculadas, WHERE, LIKE, AND/OR/NOT,
--        ORDER BY, TOP, OFFSET-FETCH, Funciones de Texto/Números, Fechas y CASE.
-- Instrucción: Resuelve cada pregunta directamente en SQL Server Management Studio
--              y presenta este archivo .sql con tus consultas ejecutables.
-- ==============================================================================

USE TiendaLogistica;
GO

-- Pregunta 1 (SELECT, Alias y Columnas Calculadas):
-- De la tabla 'dbo.productos', muestra el 'nombre_producto' con el alias 'Producto', el 'precio_unitario' con el alias 'Precio', y una nueva columna llamada 'valor_total_stock' que multiplique el precio unitario por el stock disponible.
SELECT 
    nombre_producto AS 'Producto', 
    precio_unitario AS 'Precio', 
    (precio_unitario * stock) AS 'valor_total_stock'
FROM  
    dbo.productos; 
GO 

-- Pregunta 2 (WHERE y Operadores Lógicos):
-- De la tabla 'dbo.pedidos', selecciona el 'pedido_id', 'cliente_id', 'estado' y 'total_pedido' de aquellos pedidos cuyo estado sea 'Completado' o 'Enviado' (agrupados correctamente con paréntesis) y cuyo monto total sea mayor a 350.00.
SELECT 
    pedido_id, 
    cliente_id, 
    estado,
    total_pedido 
FROM 
    dbo.pedidos
WHERE 
    estado = 'Completado';
GO

-- Pregunta 3 (Patrones con LIKE y Guiones Bajos):
-- De la tabla 'dbo.clientes', muestra el 'nombre', 'apellido' y 'email' de los clientes cuyo nombre tenga exactamente la letra 'r' en su tercera posición (utilizando comodines de guion bajo y porcentaje).
SELECT 
    nombre,
    apellido,
    email 
FROM  
    dbo.clientes
WHERE nombre LIKE '__r%' 
GO 

-- Pregunta 4 (Exclusiones con NOT IN y NOT BETWEEN):
-- De la tabla 'dbo.productos', selecciona el 'nombre_producto', 'categoria_id' y 'precio_unitario' de los artículos que NO pertenezcan a las categorías 2 o 4 (usa NOT IN) y cuyo precio unitario NO esté entre 100.00 y 700.00 (usa NOT BETWEEN).
SELECT 
    nombre_producto, 
    categoria_id, 
    precio_unitario 
FROM 
    dbo.productos
WHERE 
    (categoria_id NOT IN (2,4)) AND  (precio_unitario NOT BETWEEN 100 AND 700)
GO

-- Pregunta 5 (Ordenar y Limitar con TOP):
-- De la tabla 'dbo.productos', obtén únicamente los 3 productos más caros mostrando 'nombre_producto', 'precio_unitario' y 'stock', ordenados de mayor a menor precio.
SELECT TOP 3
    nombre_producto, 
    precio_unitario, 
    stock 
FROM 
    dbo.productos
ORDER BY precio_unitario DESC

-- Pregunta 6 (Paginación con OFFSET - FETCH):
-- De la tabla 'dbo.pedidos', escribe una consulta ordenada por 'pedido_id' de forma ascendente que omita los primeros 2 pedidos y devuelva únicamente los siguientes 2 registros. Muestra 'pedido_id', 'fecha_pedido' y 'total_pedido'.
SELECT 
    pedido_id, 
    fecha_pedido,
    total_pedido
FROM 
    dbo.pedidos
ORDER BY pedido_id ASC 
OFFSET 2 ROWS
FETCH NEXT 2 ROWS ONLY

-- Pregunta 7 (Funciones de Texto - UPPER, REPLACE y SUBSTRING):
-- De la tabla 'dbo.clientes', muestra el 'nombre' en mayúsculas con el alias 'Cliente', los primeros 4 caracteres del apellido con el alias 'CodigoApellido', y el 'email' reemplazando '@email.com' por '@tiendalogistica.pe' con el alias 'CorreoCorporativo'.
SELECT 
    UPPER(nombre) AS Cliente,
    SUBSTRING(apellido, 1, 4) AS CodigoApellido,
    REPLACE(email, '@email.com', '@tiendalogistica.pe') AS CorreoCorporativo
FROM 
    dbo.clientes;
GO

-- Pregunta 8 (Funciones Numéricas y Formateo - ROUND / CAST):
-- De la tabla 'dbo.detalle_pedidos', muestra 'detalle_id', 'pedido_id', 'cantidad', 'precio_venta' 
-- y calcula el 'subtotal_con_igv' multiplicando (cantidad * precio_venta * 1.18), asegurándote de que el resultado tenga exactamente 2 decimales limpios (usa CAST o ROUND).
SELECT 
    detalle_id,
    pedido_id, 
    cantidad, 
    precio_venta,
    CAST(((cantidad * precio_venta) * 1.18) AS decimal(10,2)) AS subtotal_con_igv 
FROM 
    dbo.detalle_pedidos;
GO

-- Pregunta 9 (Funciones de Fechas - YEAR, MONTH, DATEDIFF y DATEADD):
-- De la tabla 'dbo.pedidos', muestra 'pedido_id', 'fecha_pedido', el año del pedido ('anio'), 
-- el mes del pedido ('mes'), la fecha máxima de entrega sumando 7 días a la fecha del pedido ('fecha_entrega_max'), y los días transcurridos desde el pedido hasta hoy ('dias_antiguedad').
SELECT 
    pedido_id, 
    fecha_pedido, 
    YEAR(fecha_pedido) AS anio, 
    MONTH(fecha_pedido) AS mes, 
    DATEADD(DAY, 7, fecha_pedido) AS fecha_entrega_max, 
    DATEDIFF(DAY, fecha_pedido, GETDATE()) AS dias_antiguedad
FROM 
    dbo.pedidos;
GO

-- Pregunta 10 (Lógica Condicional con CASE):
-- De la tabla 'dbo.pedidos', muestra 'pedido_id', 'estado', 'total_pedido' y crea dos columnas nuevas usando CASE:
--   a) 'monto_final': aplica un 15% de descuento (total_pedido * 0.85) si el pedido está 'Completado' y total_pedido >= 1000.00; 
--       un 10% de descuento (total_pedido * 0.90) si total_pedido >= 500.00; de lo contrario mantiene el 'total_pedido' original (formateado a 2 decimales).
--   b) 'prioridad_atencion': muestra 'Alta' si el estado es 'Procesando', 'Media' si es 'Enviado', y 'Cerrada' en cualquier otro caso.
SELECT 
    pedido_id, 
    estado, 
    total_pedido, 
    CAST(CASE 
        WHEN (LOWER(estado) = 'completado') AND (total_pedido >=1000) THEN total_pedido * 0.85 
        WHEN total_pedido >= 500 THEN total_pedido * 0.9 
        ELSE total_pedido  
        END AS decimal(10,2)) AS monto_final,
    CASE 
        WHEN LOWER(estado) = 'procesando' THEN 'Alta'
        WHEN LOWER(estado) = 'enviado' THEN 'Media'
        ELSE 'Cerrada' 
        END AS prioridad_atencion
FROM 
    dbo.pedidos;
GO