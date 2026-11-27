USE TiendaLogistica;
GO


-- PRÁCTICA INTEGRADORA

-- CASO 1 (Exploración, cálculos y ordenamiento):
-- Enunciado:
-- Gerencia de Inventario pide un listado de productos ordenado de mayor a menor
-- según su 'valor_inventario' (precio_unitario * stock). Muestra 'nombre_producto',
-- 'categoria_id', 'precio_unitario', 'stock' y 'valor_inventario' (redondeado o
-- con 2 decimales).

SELECT 
    nombre_producto,
    categoria_id,
    precio_unitario,
    stock,
    CAST((stock * precio_unitario)AS decimal(10,2)) AS valor_inventario 
FROM 
    dbo.productos 
ORDER BY valor_inventario DESC;
GO

-- CASO 2 (Filtros complejos, patrones y exclusiones):
-- Enunciado:
-- Comercial necesita revisar pedidos que estén en estado 'Completado' o 'Enviado',
-- cuyo 'total_pedido' esté entre 200.00 y 2000.00 (incluidos) y que NO
-- correspondan al 'cliente_id' 1. Muestra 'pedido_id', 'cliente_id',
-- 'fecha_pedido', 'estado' y 'total_pedido', ordenados por 'fecha_pedido'.
SELECT 
    * 
FROM 
    dbo.pedidos
WHERE 
    (LOWER(estado) IN ('completado', 'enviado')) AND 
    (total_pedido BETWEEN 200 AND 2000) AND 
    (cliente_id <> 1)
GO

-- CASO 3 (Limpieza y estandarización de datos con funciones de texto y fecha):
-- Enunciado:
-- Marketing solicita una vista de 'dbo.clientes' con:
--   * 'cliente_upper': nombre en mayúsculas
--   * 'dominio_correo': correo con '@email.com' reemplazado por '@tiendalogistica.pe'
--   * 'ubicacion': concatenación de ciudad, ', ' y país (ej. 'Lima, Perú')
--   * 'anio_registro': año de 'fecha_registro'
--   * 'dias_desde_registro': días transcurridos desde 'fecha_registro' hasta hoy (DATEDIFF)
-- Filtra solo clientes cuyo nombre tenga 'a' en la segunda posición (LIKE '_a%').
SELECT 
    UPPER(nombre) AS cliente_upper, 
    REPLACE(email, '@email.com', '@tiendalogistica.pe') AS dominio_correo,
    CONCAT(ciudad, ', ', pais) AS ubicacion,
    YEAR(fecha_registro) AS anio_registro,
    DATEDIFF(DAY, fecha_registro, GETDATE()) AS dias_desde_registro
FROM 
    dbo.clientes
WHERE nombre LIKE '_a%'
GO

-- CASO 4 (Paginación de reportes operativos):
-- Enunciado:
-- Operaciones revisa los pedidos en lotes de 3 registros ordenados por
-- 'total_pedido' de mayor a menor. Escribe la consulta para obtener el SEGUNDO
-- lote (es decir, omitir los 3 primeros y traer los siguientes 3) usando
-- OFFSET y FETCH. Muestra 'pedido_id', 'estado' y 'total_pedido'.
SELECT 
    pedido_id,
    estado,
    total_pedido
FROM 
    dbo.pedidos
ORDER BY total_pedido DESC
OFFSET 3 ROWS 
FETCH NEXT 3 ROWS ONLY;
GO

-- CASO 5 (Reglas de negocio y descuentos con CASE):
-- Enunciado:
-- Finanzas quiere simular una campaña sobre 'dbo.pedidos'. Muestra 'pedido_id',
-- 'estado', 'total_pedido' y dos columnas calculadas:
--   * 'total_ajustado' (2 decimales): si estado = 'Completado' y total_pedido >= 800,
--     aplica 15% de descuento (0.85); si total_pedido >= 400, aplica 8% (0.92);
--     en otro caso conserva 'total_pedido'.
--   * 'segmento_ticket': 'Alto' (>= 800), 'Medio' (>= 300), 'Bajo' (< 300).
SELECT 
    pedido_id,
    estado, 
    total_pedido,
    CAST(CASE
        WHEN (LOWER(estado) = 'completado' AND total_pedido >= 800) THEN total_pedido * 0.85
        WHEN (total_pedido >= 400) THEN total_pedido * 0.92 
        ELSE total_pedido
        END AS decimal(10,2)) AS total_ajustado, 
    CASE 
        WHEN (total_pedido >= 800) THEN 'Alto' 
        WHEN (total_pedido >= 300) THEN 'Medio' 
        ELSE 'Bajo'
        END AS segmento_ticket
FROM 
    dbo.pedidos 
GO 

-- CASO 6 (KPIs y métricas de resumen por grupo - GROUP BY y HAVING):
-- Enunciado:
-- Dirección Comercial requiere un reporte por 'estado' en 'dbo.pedidos' que
-- muestre:
--   * 'cantidad_pedidos' (COUNT(*))
--   * 'facturacion_total' (SUM(total_pedido))
--   * 'ticket_promedio' (AVG(total_pedido) con 2 decimales)
--   * 'pedido_maximo' (MAX(total_pedido))
-- Filtra con HAVING para mostrar solo los estados cuya 'facturacion_total'
-- sea mayor a 500.00, ordenando por 'facturacion_total' descendente.
SELECT * FROM dbo.pedidos;
GO

SELECT 
    estado,
    COUNT(*) AS cantidad_pedidos,
    SUM(total_pedido) AS facturacion_total, 
    CAST((AVG(total_pedido)) AS decimal(10,2)) AS ticket_promedio, 
    MAX(total_pedido) AS pedido_maximo
FROM 
    dbo.pedidos
GROUP BY 
    estado
HAVING
    SUM(total_pedido) > 500
ORDER BY facturacion_total DESC

-- SELECT
-- FROM
-- JOIN
--		ON
-- WHERE <-
-- GROUP BY <-
-- HAVING <-
-- ORDER BY <-


-- CASO 7 (Análisis de líneas de venta y productos más vendidos):
-- Enunciado:
-- En 'dbo.detalle_pedidos', agrupa por 'producto_id' para calcular:
--   * 'veces_vendido' (COUNT(*))
--   * 'unidades_totales' (SUM(cantidad))
--   * 'ingreso_bruto' (SUM(cantidad * precio_venta) con 2 decimales)
-- Filtra solo productos con 'unidades_totales' >= 2 y ordena de mayor a menor
-- según 'ingreso_bruto'.
SELECT * FROM dbo.productos;
SELECT * FROM dbo.detalle_pedidos;

SELECT 
    producto_id, 
    COUNT(*) AS veces_vendido,
    SUM(cantidad) AS unidades_totales,
    CAST((SUM(cantidad* precio_venta)) AS decimal(10,2)) AS ingreso_bruto
FROM
    dbo.detalle_pedidos 
GROUP BY 
    producto_id 
HAVING 
    SUM(cantidad) >= 2 
ORDER BY 
    ingreso_bruto DESC;
GO

-- CASO 8 (Inserción de nuevo pedido y sus líneas de detalle - INSERT):
-- Enunciado:
-- Registra un nuevo pedido en 'dbo.pedidos' para 'cliente_id = 1', con fecha
-- actual (GETDATE()), estado 'Pendiente' y 'total_pedido = 340.00'.

-- Revisa con SELECT el 'pedido_id' asignado y luego inserta al menos una línea
-- correspondiente en 'dbo.detalle_pedidos' usando ese 'pedido_id'.

BEGIN TRANSACTION 
    GO
    INSERT INTO dbo.pedidos(cliente_id,fecha_pedido, estado, total_pedido)
    VALUES (1, GETDATE(), 'Pendiente', 340.00)
    GO
    -- Verificar el INSERT INTO 
    SELECT * FROM dbo.pedidos

    -- Insertar detalle_pedidos 
    INSERT INTO dbo.detalle_pedidos(pedido_id, producto_id, cantidad, precio_venta) 
    VALUES ((SELECT MAX(pedido_id) FROM dbo.pedidos), 1, 2, 2800)

    -- Verificar INSERT INTO 
    SELECT * FROM dbo.detalle_pedidos;
    
ROLLBACK TRANSACTION

