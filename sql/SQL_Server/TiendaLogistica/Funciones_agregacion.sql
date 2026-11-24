USE TiendaLogistica;
GO

-- FUNCIONES RESUMEN 
-- COUNT , SUM, AVG, MIN, MAX 
SELECT 
    COUNT(*) AS total_pedidos, 
    SUM(total_pedido) AS ingresos_totales,
    CAST(AVG(total_pedido) AS DECIMAL(10,2)) AS ticket_promedio,
    MIN(total_pedido) AS pedido_minimo,
    MAX(total_pedido) AS pedido_maximo
FROM
    dbo.pedidos;
GO

-- Tabla de productos
SELECT * FROM dbo.productos;

SELECT 
    categoria_id,
    COUNT(*) AS cantidad_productos,
    SUM(stock) AS unidates_almacen,
    CAST(AVG(precio_unitario) AS decimal(10, 2)) AS precio_promedio
FROM
    dbo.productos
GROUP BY categoria_id
ORDER BY precio_promedio DESC; 
GO

-- WHERE (filas) vs HAVING (grupos)
SELECT * FROM pedidos;

SELECT 
    estado,
    COUNT(*) AS num_pedidos, 
    SUM(total_pedido) AS monto_acumulado
FROM 
    dbo.pedidos 
WHERE 
    total_pedido >= 300
GROUP BY 
    estado 
HAVING SUM(total_pedido) > 1000 

-- AGRUPACION DE CANTIDAD DE CLIENTES POR PASI Y CIUDAD 
SELECT * FROM dbo.clientes;

SELECT 
    pais, 
    ciudad,
    COUNT(*) AS cantidad_clientes, 
    MIN(fecha_registro) AS primer_registro, 
    MAX(fecha_registro) AS ultimo_registro
FROM 
    dbo.clientes 
GROUP BY 
    pais,  ciudad;
GO 

-- Agrupación por pedido_id con HAVING
SELECT * FROM dbo.detalle_pedidos;

SELECT 
    pedido_id, 
    COUNT(*) AS lineas_de_detalle, 
    SUM(cantidad) AS total_articulo, 
    CAST(SUM(cantidad * precio_venta) AS decimal(10,2)) AS total_calculado
FROM 
    dbo.detalle_pedidos 
GROUP BY 
    pedido_id 
HAVING 
    COUNT(*) > 1

-- AGRUPACION por nombre_categoria 
SELECT * FROM dbo.categorias;

SELECT 
    nombre_categoria, 
    COUNT(*) AS registros_categoria
FROM 
    dbo.categorias
GROUP BY 
    nombre_categoria 
ORDER BY nombre_categoria ASC

-- Agrupación por clientes recurrente o de alto valor 
SELECT * FROM dbo.pedidos; 

SELECT 
    cliente_id, 
    COUNT(*) AS pedido_realizados, 
    SUM(total_pedido) AS gasto_acumulado
FROM 
    dbo.pedidos
GROUP BY cliente_id 
HAVING 
    (COUNT(*) > 1)  OR (SUM(total_pedido) > 800)
ORDER BY 
    gasto_acumulado DESC;

-- Agrupación para medir las ventas por producto 
SELECT * FROM detalle_pedidos;

SELECT 
    producto_id, 
    COUNT(*) AS apariciones_pedidos, 
    SUM(cantidad) AS unidades_vendidas, 
    CAST(SUM(cantidad * precio_venta) AS decimal(10,2)) AS ingreso_generado 
FROM 
    dbo.detalle_pedidos
GROUP BY 
    producto_id
ORDER BY ingreso_generado DESC