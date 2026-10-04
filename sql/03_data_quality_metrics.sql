-- 03_data_quality_metrics.sql
-- Purpose: Build a DQ metrics table and insert a run snapshot.

DROP TABLE IF EXISTS dq_run_metrics;

CREATE TABLE dq_run_metrics (
    run_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_timestamp TEXT NOT NULL,
    total_transactions INTEGER NOT NULL,
    missing_critical_fields INTEGER NOT NULL,
    duplicate_transaction_ids INTEGER NOT NULL,
    invalid_sale_price INTEGER NOT NULL,
    future_dated_transactions INTEGER NOT NULL,
    orphan_property_fk INTEGER NOT NULL,
    orphan_buyer_fk INTEGER NOT NULL,
    invalid_mortgage_amount INTEGER NOT NULL
);

INSERT INTO dq_run_metrics (
    run_timestamp,
    total_transactions,
    missing_critical_fields,
    duplicate_transaction_ids,
    invalid_sale_price,
    future_dated_transactions,
    orphan_property_fk,
    orphan_buyer_fk,
    invalid_mortgage_amount
)
SELECT
    DATETIME('now') AS run_timestamp,
    (SELECT COUNT(*) FROM property_transactions),
    (SELECT COUNT(*) FROM property_transactions
      WHERE transaction_id IS NULL OR property_id IS NULL OR transaction_date IS NULL),
    (SELECT COUNT(*) FROM (
        SELECT transaction_id
        FROM property_transactions
        GROUP BY transaction_id
        HAVING COUNT(*) > 1
    )),
    (SELECT COUNT(*) FROM property_transactions WHERE sale_price <= 0),
    (SELECT COUNT(*) FROM property_transactions WHERE DATE(transaction_date) > DATE('now')),
    (SELECT COUNT(*) FROM property_transactions t
        LEFT JOIN property_registry p ON p.property_id = t.property_id
        WHERE p.property_id IS NULL),
    (SELECT COUNT(*) FROM property_transactions t
        LEFT JOIN property_owners o ON o.owner_id = t.buyer_owner_id
        WHERE t.buyer_owner_id IS NOT NULL AND o.owner_id IS NULL),
    (SELECT COUNT(*) FROM property_transactions
        WHERE mortgage_flag = 1 AND mortgage_amount > sale_price);

SELECT * FROM dq_run_metrics ORDER BY run_id DESC LIMIT 5;
