-- Run after create_tables.sql. Replace C:\\Users\\flavi\\Pictures\\Blue_Lock_SQL_Project\\sql\\SQL_Server\\olist\\csv with the folder where you extracted the CSV files.
-- SQL Server service account must have read permission to that folder.
-- CSV files include a header row and are UTF-8 with BOM; postal prefixes are padded to 5 digits.
-- Empty CSV fields are imported as empty values; check NULL/empty-string handling if exact NULL fidelity is required.

USE Olist;
GO

BULK INSERT dbo.customers
FROM '/tmp/olist_csv/customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);



-- GEOLOCATION
BULK INSERT dbo.[geolocation]
FROM '/tmp/olist_csv/geolocation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- LEADS CLOSED
BULK INSERT dbo.[leads_closed]
FROM '/tmp/olist_csv/leads_closed.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- LEADS QUALIFIED
BULK INSERT dbo.[leads_qualified]
FROM '/tmp/olist_csv/leads_qualified.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- ORDER ITEMS
BULK INSERT dbo.[order_items]
FROM '/tmp/olist_csv/order_items.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- ORDER PAYMENTS
BULK INSERT dbo.[order_payments]
FROM '/tmp/olist_csv/order_payments.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- ORDER REVIEWS
BULK INSERT dbo.[order_reviews]
FROM '/tmp/olist_csv/order_reviews.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- ORDERS
BULK INSERT dbo.[orders]
FROM '/tmp/olist_csv/orders.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO


-- PRODUCTS
BULK INSERT dbo.[products]
FROM '/tmp/olist_csv/products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

-- SELLERS
BULK INSERT dbo.[sellers]
FROM '/tmp/olist_csv/sellers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

