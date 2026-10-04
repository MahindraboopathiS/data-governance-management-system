-- 02_data_quality_rules.sql
-- Purpose: Data Quality checks (completeness, uniqueness, validity, timeliness, referential integrity).

-- R1: Missing critical fields
SELECT COUNT(*) AS missing_critical_fields
FROM property_transactions
WHERE transaction_id IS NULL
   OR property_id IS NULL
   OR transaction_date IS NULL;

-- R2: Duplicate transaction_id
SELECT transaction_id, COUNT(*) AS cnt
FROM property_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- R3: Invalid sale_price (<= 0)
SELECT COUNT(*) AS invalid_sale_price
FROM property_transactions
WHERE sale_price <= 0;

-- R4: Future-dated transactions
SELECT COUNT(*) AS future_dated_transactions
FROM property_transactions
WHERE DATE(transaction_date) > DATE('now');

-- R5: Orphan property_id
SELECT COUNT(*) AS orphan_property_fk
FROM property_transactions t
LEFT JOIN property_registry p ON p.property_id = t.property_id
WHERE p.property_id IS NULL;

-- R6: Orphan buyer_owner_id
SELECT COUNT(*) AS orphan_buyer_fk
FROM property_transactions t
LEFT JOIN property_owners o ON o.owner_id = t.buyer_owner_id
WHERE t.buyer_owner_id IS NOT NULL
  AND o.owner_id IS NULL;

-- R7: Mortgage amount > sale price
SELECT COUNT(*) AS invalid_mortgage_amount
FROM property_transactions
WHERE mortgage_flag = 1
  AND mortgage_amount > sale_price;
