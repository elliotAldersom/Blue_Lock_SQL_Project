
USE Olist;
GO

/* =====================================================
   PASO 1: CAMBIAR COLUMNAS DE CLAVES A NOT NULL
   ===================================================== */

ALTER TABLE dbo.customers
ALTER COLUMN customer_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.orders
ALTER COLUMN order_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.products
ALTER COLUMN product_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.sellers
ALTER COLUMN seller_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.order_reviews
ALTER COLUMN review_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.order_reviews
ALTER COLUMN order_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.leads_qualified
ALTER COLUMN mql_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.leads_closed
ALTER COLUMN mql_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.order_items
ALTER COLUMN order_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.order_items
ALTER COLUMN order_item_id INT NOT NULL;
GO

ALTER TABLE dbo.order_payments
ALTER COLUMN order_id NVARCHAR(52) NOT NULL;
GO

ALTER TABLE dbo.order_payments
ALTER COLUMN payment_sequential INT NOT NULL;
GO


/* =====================================================
   PASO 2: CREAR CLAVES PRIMARIAS
   ===================================================== */

-- CUSTOMERS
ALTER TABLE dbo.customers
ADD CONSTRAINT PK_customers
PRIMARY KEY (customer_id);
GO

-- ORDERS
ALTER TABLE dbo.orders
ADD CONSTRAINT PK_orders
PRIMARY KEY (order_id);
GO

-- PRODUCTS
ALTER TABLE dbo.products
ADD CONSTRAINT PK_products
PRIMARY KEY (product_id);
GO

-- SELLERS
ALTER TABLE dbo.sellers
ADD CONSTRAINT PK_sellers
PRIMARY KEY (seller_id);
GO

-- ORDER REVIEWS
-- Clave compuesta porque review_id tiene duplicados
ALTER TABLE dbo.order_reviews
ADD CONSTRAINT PK_order_reviews
PRIMARY KEY (review_id, order_id);
GO

-- LEADS QUALIFIED
ALTER TABLE dbo.leads_qualified
ADD CONSTRAINT PK_leads_qualified
PRIMARY KEY (mql_id);
GO

-- LEADS CLOSED
ALTER TABLE dbo.leads_closed
ADD CONSTRAINT PK_leads_closed
PRIMARY KEY (mql_id);
GO

-- ORDER ITEMS
ALTER TABLE dbo.order_items
ADD CONSTRAINT PK_order_items
PRIMARY KEY (order_id, order_item_id);
GO

-- ORDER PAYMENTS
ALTER TABLE dbo.order_payments
ADD CONSTRAINT PK_order_payments
PRIMARY KEY (order_id, payment_sequential);
GO


/* =====================================================
   PASO 3: CREAR CLAVES FORANEAS
   ===================================================== */

-- CUSTOMERS -> ORDERS
ALTER TABLE dbo.orders
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (customer_id)
REFERENCES dbo.customers(customer_id);
GO

-- ORDERS -> ORDER ITEMS
ALTER TABLE dbo.order_items
ADD CONSTRAINT FK_order_items_orders
FOREIGN KEY (order_id)
REFERENCES dbo.orders(order_id);
GO

-- PRODUCTS -> ORDER ITEMS
ALTER TABLE dbo.order_items
ADD CONSTRAINT FK_order_items_products
FOREIGN KEY (product_id)
REFERENCES dbo.products(product_id);
GO

-- SELLERS -> ORDER ITEMS
ALTER TABLE dbo.order_items
ADD CONSTRAINT FK_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES dbo.sellers(seller_id);
GO

-- ORDERS -> ORDER PAYMENTS
ALTER TABLE dbo.order_payments
ADD CONSTRAINT FK_order_payments_orders
FOREIGN KEY (order_id)
REFERENCES dbo.orders(order_id);
GO

-- ORDERS -> ORDER REVIEWS
ALTER TABLE dbo.order_reviews
ADD CONSTRAINT FK_order_reviews_orders
FOREIGN KEY (order_id)
REFERENCES dbo.orders(order_id);
GO

-- LEADS QUALIFIED -> LEADS CLOSED
ALTER TABLE dbo.leads_closed
ADD CONSTRAINT FK_leads_closed_qualified
FOREIGN KEY (mql_id)
REFERENCES dbo.leads_qualified(mql_id);
GO

-- SELLERS -> LEADS CLOSED
ALTER TABLE dbo.leads_closed
ADD CONSTRAINT FK_leads_closed_sellers
FOREIGN KEY (seller_id)
REFERENCES dbo.sellers(seller_id);
GO


/* =====================================================
   PASO 4: CREAR TABLA AUXILIAR DE CODIGOS POSTALES
   ===================================================== */

IF OBJECT_ID('dbo.zip_code_prefix', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.zip_code_prefix
    (
        zip_code_prefix NVARCHAR(10) NOT NULL,
        CONSTRAINT PK_zip_code_prefix
            PRIMARY KEY (zip_code_prefix)
    );
END;
GO

-- Insertar codigos postales unicos
INSERT INTO dbo.zip_code_prefix (zip_code_prefix)
SELECT DISTINCT codigos.zip_code_prefix
FROM
(
    SELECT customer_zip_code_prefix AS zip_code_prefix
    FROM dbo.customers

    UNION

    SELECT seller_zip_code_prefix
    FROM dbo.sellers

    UNION

    SELECT geolocation_zip_code_prefix
    FROM dbo.geolocation
) AS codigos
WHERE codigos.zip_code_prefix IS NOT NULL
AND NOT EXISTS
(
    SELECT 1
    FROM dbo.zip_code_prefix z
    WHERE z.zip_code_prefix = codigos.zip_code_prefix
);
GO

-- CUSTOMERS -> ZIP CODE
ALTER TABLE dbo.customers
ADD CONSTRAINT FK_customers_zip_code
FOREIGN KEY (customer_zip_code_prefix)
REFERENCES dbo.zip_code_prefix(zip_code_prefix);
GO

-- SELLERS -> ZIP CODE
ALTER TABLE dbo.sellers
ADD CONSTRAINT FK_sellers_zip_code
FOREIGN KEY (seller_zip_code_prefix)
REFERENCES dbo.zip_code_prefix(zip_code_prefix);
GO

-- GEOLOCATION -> ZIP CODE
ALTER TABLE dbo.geolocation
ADD CONSTRAINT FK_geolocation_zip_code
FOREIGN KEY (geolocation_zip_code_prefix)
REFERENCES dbo.zip_code_prefix(zip_code_prefix);
GO