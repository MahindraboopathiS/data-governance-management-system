-- 04_governance_views.sql
-- Purpose: Create a curated view for easier consumption + example analytics.

DROP VIEW IF EXISTS v_curated_transactions;

CREATE VIEW v_curated_transactions AS
SELECT
    t.transaction_id,
    t.property_id,
    p.city,
    p.province,
    p.property_type,
    DATE(t.transaction_date) AS transaction_date,
    t.sale_price,
    t.mortgage_flag,
    t.mortgage_amount,
    t.status,
    t.buyer_owner_id,
    bo.owner_name AS buyer_name,
    t.seller_owner_id,
    so.owner_name AS seller_name
FROM property_transactions t
LEFT JOIN property_registry p ON p.property_id = t.property_id
LEFT JOIN property_owners bo ON bo.owner_id = t.buyer_owner_id
LEFT JOIN property_owners so ON so.owner_id = t.seller_owner_id;

SELECT
    city,
    province,
    COUNT(*) AS txn_count,
    ROUND(SUM(sale_price), 2) AS total_sale_value
FROM v_curated_transactions
WHERE sale_price > 0
  AND city IS NOT NULL
GROUP BY city, province
ORDER BY total_sale_value DESC
LIMIT 10;
