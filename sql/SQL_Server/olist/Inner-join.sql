USE Olist;
GO

-- CLASE DE JOIN 
-- Que clientes realizaron compras? 
-- Que productos compraron? 

-- INNER JOIN: Dvuelve únicamente los regisotrs que tienen coincidencia entra las tablas (2 o más) 
SELECT TOP 10
    *
FROM
    dbo.customers c 
INNER JOIN dbo.orders o
ON c.customer_id = o.customer_id;

-- RIGHT JOIN: Conserva todos los registros de la tabla que aparece a la derecha (la 2da que declaras) y la coincidencias y las que no tiene sale null 
-- LEFT JOIN: Conserva todos los registros de la tabla que aparece a la izquierda (la 1ra que declaras) y la coincidencias y las que no tiene sale null 

SELECT TOP 30
    * 
FROM 
    dbo.leads_closed lc 
RIGHT JOIN dbo.sellers s 
ON lc.seller_id = s.seller_id
GO

-- Conocer que clientes realizaron pedidos y en que ciudad viven 
SELECT TOP 20
    c.customer_id, 
    c.customer_city,
    c.customer_state, 
    o.order_id, 
    o.order_status
FROM 
    dbo.customers AS c
INNER JOIN dbo.orders AS o
ON c.customer_id = o.customer_id;

-- Queremos conocer que productos se vendieron en cada pedidos y precio 
SELECT TOP 10
    * 
FROM dbo.order_items AS oi
INNER JOIN dbo.orders AS o
ON oi.order_id = o.order_id

-- Queremos identificar que vendedor comercializó cada producto 
SELECT TOP 20
    s.seller_id,
    s.seller_city,
    p.product_category_name,
    oi.seller_id,
    oi.price
FROM 
    dbo.order_items AS oi 
-- RELACIONAR EL DETALLE CON LOS PRODUCTOS  
INNER JOIN dbo.products AS p 
    ON p.product_id = oi.product_id 
INNER JOIN  dbo.sellers AS s
    ON oi.seller_id = s.seller_id
GO

-- QUEREMOS SABER QUE CLIENTE REALIZÓ UN PEDIDO, CUANTO PAGÓ Y QUE MÉTODO UTILIZÓ 
SELECT TOP 30
    c.customer_id, 
    c.customer_city, 
    o.order_id, 
    o.order_status, 
    op.payment_type, 
    op.payment_value 
FROM 
    dbo.customers AS c 
INNER JOIN dbo.orders AS o 
    ON c.customer_id = o.customer_id 
INNER JOIN dbo.order_payments AS op
    ON op.order_id = o.order_id
GO

-- Queremos conocer que cliente compró un producto, cual fue su precio, y el vendedor 
SELECT TOP 30
    c.customer_id, 
    c.customer_city, 
    s.seller_id, 
    s.seller_city,
    p.product_id, 
    oi.price
FROM 
    dbo.customers AS c
INNER JOIN dbo.orders AS o 
    ON c.customer_id = o.customer_id 
INNER JOIN dbo.order_items AS oi
    ON oi.order_id = o.order_id 
INNER JOIN dbo.sellers AS s 
    ON s.seller_id = oi.seller_id
INNER JOIN dbo.products AS p 
    ON p.product_id = oi.product_id;
GO

-- El gerente quiere conocer todos los vendedores, incluso los que todavía no tienen ventas registradas
SELECT TOP 100
    s.seller_id, 
    s.seller_city, 
    oi.order_id, 
    oi.product_id, 
    oi.price, 
    oi.order_id,
    oi.order_item_id
FROM 
    dbo.order_items AS oi 
RIGHT JOIN dbo.sellers AS s
    ON s.seller_id = oi.seller_id;

-- Los clientes registrados incluso sin compra
SELECT TOP 100
    c.customer_id, 
    c.customer_city,
    o.order_id, 
    o.order_status
FROM 
    dbo.customers AS c
LEFT JOIN dbo.orders AS o
    ON c.customer_id = o.customer_id;
GO 

-- El departamente financiero necesita revisar todos los pedidos aunque no tengas pagos registrados
SELECT 
    op.order_id, 
    op.payment_type 
FROM 
    dbo.order_payments AS op 
RIGHT JOIN dbo.orders AS o
    ON o.order_id = op.order_id

-- Mostrar todas los vendedores y productos relacionados con ellos 
SELECT TOP 30
    s.seller_id, 
    s.seller_city ,
    oi.order_id, 
    oi.product_id, 
    p.product_category_name 
FROM 
    dbo.order_items AS oi 
INNER JOIN dbo.products AS p
    ON p.product_id = oi.product_id
RIGHT JOIN dbo.sellers AS s 
    ON s.seller_id = oi.seller_id

-- USER 'WHERE' y 'ORDER BY'
SELECT TOP 30
    s.seller_id, 
    s.seller_city ,
    oi.order_id, 
    oi.product_id, 
    p.product_category_name 
FROM 
    dbo.order_items AS oi 
INNER JOIN dbo.products AS p
    ON p.product_id = oi.product_id
RIGHT JOIN dbo.sellers AS s 
    ON s.seller_id = oi.seller_id
WHERE LOWER(s.seller_city) = 'sao paulo'
ORDER BY oi.price DESC;