USE Ecommerce;
GO

-- Limitar a los primeros 10 rows 
SELECT TOP 10
    * 
FROM 
    dbo.products; 
GO

-- Condiciones, peso menor a 500 gramos
SELECT TOP 10
    * 
FROM 
    dbo.products
WHERE
    product_weight_g < 500
ORDER BY
    product_weight_g DESC;
GO