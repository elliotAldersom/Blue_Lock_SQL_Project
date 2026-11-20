USE TiendaLogistica;
GO

-- YEAR, MONTH, DAY: Extraen como número entero el año, mes y día 
SELECT 
    pedido_id, 
    fecha_pedido, 
    YEAR(fecha_pedido) AS anio, 
    MONTH(fecha_pedido) AS mes, 
    DAY(fecha_pedido) AS dia
FROM 
    dbo.pedidos;

-- DATEDIFF(intervalo, fecha_inicio, fecha_final) : Calcular la diferencia de tiempo entre dos fechas (DAY, MONTH, YEAR, HOUR, MINUTE, SECOND)
SELECT 
    pedido_id, 
    fecha_pedido, 
    DATEDIFF(DAY, fecha_pedido, GETDATE()) AS dias_transcurridos
FROM 
    dbo.pedidos;

-- DATEADD(intervalo, cantidad, fecha) : Suma o resta unidades de tiempo a una fecha específica (YEAR, MONTH, DAY, HOUR, MINUTE, SECOND)
SELECT 
    pedido_id,
    fecha_pedido, 
    DATEADD(DAY, 14, fecha_pedido) AS fin_garantia
FROM 
    dbo.pedidos; 

-- CASE 
--     WHEN (expresion1) THEN 'valor si cumple'
--     WHEN (expresion2) THEN 'valor si cumple'
--     WHEN (expresionN) THEN 'valor si cumple'
--     ELSE 'valor si ninguno cumple' 
-- END  AS Column_name

SELECT 
    pedido_id,
    cliente_id,
    fecha_pedido,
    estado,
    total_pedido AS monto_original, 
    CAST( CASE 
        WHEN total_pedido >= 1000 THEN total_pedido * 0.85 
        WHEN total_pedido >= 500 THEN total_pedido * 0.9 
        ELSE total_pedido
        END AS decimal(10, 2)) AS precio_final
FROM 
    dbo.pedidos;

SELECT 
    *, 
    CAST(cantidad * precio_venta AS decimal(10, 2)) AS subtotal_linea, 
    CASE 
        WHEN (cantidad * precio_venta) >= 1000 THEN 'Venta Mayorista'
        WHEN (cantidad * precio_venta) >= 250 THEN 'Venta intermedia' 
        ELSE 'Venta menor'
    END  AS tipo_venta
FROM 
    dbo.detalle_pedidos; 

SELECT 
    pedido_id,
    cliente_id,
    fecha_pedido,
    estado,
    total_pedido AS monto_original, 
    CAST( CASE 
        WHEN  (total_pedido >= 1000) AND (LOWER(estado) = 'completado') THEN total_pedido * 0.85 
        WHEN (total_pedido >= 500) AND (LOWER(estado) = 'Completado') THEN total_pedido * 0.9 
        ELSE total_pedido
        END AS decimal(10, 2)) AS precio_final
FROM 
    dbo.pedidos;

