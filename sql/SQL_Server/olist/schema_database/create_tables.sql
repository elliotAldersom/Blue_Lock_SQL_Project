-- SQL Server schema for the Olist SQLite database
-- Tables are created without primary/foreign keys so all rows can be imported first.
-- ZIP/postal prefixes are NVARCHAR to preserve leading zeros.

CREATE DATABASE Olist;
GO

USE Olist;
GO

IF OBJECT_ID(N'dbo.[customers]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[customers] (
    [customer_id] NVARCHAR(52) NULL,
    [customer_unique_id] NVARCHAR(52) NULL,
    [customer_zip_code_prefix] NVARCHAR(10) NULL,
    [customer_city] NVARCHAR(52) NULL,
    [customer_state] NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[geolocation]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[geolocation] (
    [geolocation_zip_code_prefix] NVARCHAR(10) NULL,
    [geolocation_lat] FLOAT NULL,
    [geolocation_lng] FLOAT NULL,
    [geolocation_city] NVARCHAR(58) NULL,
    [geolocation_state] NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[leads_closed]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[leads_closed] (
    [mql_id] NVARCHAR(52) NULL,
    [seller_id] NVARCHAR(52) NULL,
    [sdr_id] NVARCHAR(52) NULL,
    [sr_id] NVARCHAR(52) NULL,
    [won_date] NVARCHAR(50) NULL,
    [business_segment] NVARCHAR(51) NULL,
    [lead_type] NVARCHAR(50) NULL,
    [lead_behaviour_profile] NVARCHAR(50) NULL,
    [has_company] INT NULL,
    [has_gtin] INT NULL,
    [average_stock] NVARCHAR(50) NULL,
    [business_type] NVARCHAR(50) NULL,
    [declared_product_catalog_size] FLOAT NULL,
    [declared_monthly_revenue] FLOAT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[leads_qualified]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[leads_qualified] (
    [mql_id] NVARCHAR(52) NULL,
    [first_contact_date] NVARCHAR(50) NULL,
    [landing_page_id] NVARCHAR(52) NULL,
    [origin] NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[order_items]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[order_items] (
    [order_id] NVARCHAR(52) NULL,
    [order_item_id] INT NULL,
    [product_id] NVARCHAR(52) NULL,
    [seller_id] NVARCHAR(52) NULL,
    [shipping_limit_date] NVARCHAR(50) NULL,
    [price] FLOAT NULL,
    [freight_value] FLOAT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[order_payments]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[order_payments] (
    [order_id] NVARCHAR(52) NULL,
    [payment_sequential] INT NULL,
    [payment_type] NVARCHAR(50) NULL,
    [payment_installments] INT NULL,
    [payment_value] FLOAT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[order_reviews]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[order_reviews] (
    [review_id] NVARCHAR(52) NULL,
    [order_id] NVARCHAR(52) NULL,
    [review_score] INT NULL,
    [review_comment_title] NVARCHAR(MAX) NULL,
    [review_comment_message] NVARCHAR(MAX) NULL,
    [review_creation_date] NVARCHAR(50) NULL,
    [review_answer_timestamp] NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[orders]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[orders] (
    [order_id] NVARCHAR(52) NULL,
    [customer_id] NVARCHAR(52) NULL,
    [order_status] NVARCHAR(50) NULL,
    [order_purchase_timestamp] NVARCHAR(50) NULL,
    [order_approved_at] NVARCHAR(50) NULL,
    [order_delivered_carrier_date] NVARCHAR(50) NULL,
    [order_delivered_customer_date] NVARCHAR(50) NULL,
    [order_estimated_delivery_date] NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[product_category_name_translation]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[product_category_name_translation] (
    [product_category_name] NVARCHAR(66) NULL,
    [product_category_name_english] NVARCHAR(59) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[products]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[products] (
    [product_id] NVARCHAR(52) NULL,
    [product_category_name] NVARCHAR(66) NULL,
    [product_name_lenght] FLOAT NULL,
    [product_description_lenght] FLOAT NULL,
    [product_photos_qty] FLOAT NULL,
    [product_weight_g] FLOAT NULL,
    [product_length_cm] FLOAT NULL,
    [product_height_cm] FLOAT NULL,
    [product_width_cm] FLOAT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.[sellers]', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[sellers] (
    [seller_id] NVARCHAR(52) NULL,
    [seller_zip_code_prefix] NVARCHAR(10) NULL,
    [seller_city] NVARCHAR(60) NULL,
    [seller_state] NVARCHAR(50) NULL
    );
END;
GO