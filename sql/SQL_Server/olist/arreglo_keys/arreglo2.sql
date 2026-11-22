USE Olist;
GO

ALTER TABLE dbo.leads_closed
WITH NOCHECK
ADD CONSTRAINT FK_leads_closed_sellers
FOREIGN KEY (seller_id)
REFERENCES dbo.sellers(seller_id);
GO