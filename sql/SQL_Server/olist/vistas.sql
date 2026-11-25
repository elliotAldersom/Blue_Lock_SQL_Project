USE  Olist; 
GO 

-- Clase: Funciones de Agrupación y agrupaciones 
-- Funciones de Agregación 
-- SUM() => sum values
-- COUNT() => count rows 
-- AVG() => promedios 
-- MAX() => value maximun 
-- MIN() => value minium 

-- Sumar ventas 
SELECT 
    SUM(price) AS total_ventas 
FROM 
    dbo.order_items;

-- Productos vendidos
SELECT 
    COUNT(*) AS productos_vendidos
FROM 
    dbo.order_items ;
GO

-- Precio promedio 
SELECT 
    AVG(price) AS precio_promedio
FROM 
    dbo.order_items ;
GO

-- Precio mínimo
SELECT 
    MIN(price) AS precio_minimo
FROM 
    dbo.order_items ;
GO

-- Precio máximo 
SELECT 
    MAX(price) AS precio_maximo
FROM 
    dbo.order_items ;
GO

-- Agrupar 
-- Total de ventas por categoria 
SELECT TOP 30
    p.product_category_name, 
    COUNT(*) AS total_productos,
    ROUND(SUM(oi.price), 2) AS total_ventas
FROM 
    dbo.products AS p
INNER JOIN dbo.order_items as oi
    ON oi.product_id = p.product_id 
GROUP BY p.product_category_name
ORDER BY total_ventas DESC

-- 
SELECT 
    c.customer_city AS ciudad,
    -- contar pedidos únicos
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    -- contar los clientes distintos 
    COUNT(DISTINCT c.customer_id) AS total_clients
FROM 
    dbo.customers AS c
INNER JOIN dbo.orders AS o 
    ON c.customer_id = o.customer_id 
GROUP BY 
    c.customer_city
ORDER BY 
    ciudad ASC


-- Total de ventas y pagos por método de pago 
SELECT 
    ROUND(SUM(payment_value),2) AS total_pago, 
    COUNT(*) AS cantidad_pago
FROM 
    dbo.order_payments  
GROUP BY 
    payment_type 
ORDER BY
    total_pago DESC


-- VISTAS: Permite guardar una consulta con un NOMBRE y utilizarla después como si fuera una tabla guardad
GO 
CREATE OR ALTER VIEW dbo.vw_olist_ventas 
AS 
SELECT 
    o.order_id,
	o.order_status,
	o.order_purchase_timestamp,
	c.customer_id,
	c.customer_city,
	c.customer_state,
	p.product_id,
	p.product_category_name,
	s.seller_id,
	s.seller_city,
	s.seller_state,
	oi.price,
	oi.freight_value
FROM 
    dbo.orders AS o
INNER JOIN dbo.order_items AS oi 
    ON oi.order_id = o.order_id 
INNER JOIN dbo.customers AS c 
    ON c.customer_id = o.customer_id
INNER JOIN dbo.products AS p 
    ON p.product_id = oi.product_id 
INNER JOIN dbo.sellers AS s  
    ON s.seller_id = oi.seller_id 
GO 

-- Consultar la vista 
SELECT TOP 10 
    * 
FROM 
    dbo.vw_olist_ventas;
GO