"""data_quality_pipeline.py
Run repeatable DQ checks and output a dashboard-ready snapshot.
Run:
python python/data_quality_pipeline.py --db data/property_registry.db --out dashboards/dq_metrics_snapshot.csv
"""

import argparse
import sqlite3
import pandas as pd

DQ_QUERIES = {
    "total_transactions": "SELECT COUNT(*) AS v FROM property_transactions;",
    "missing_critical_fields": """SELECT COUNT(*) AS v
        FROM property_transactions
        WHERE transaction_id IS NULL OR property_id IS NULL OR transaction_date IS NULL;""",
    "duplicate_transaction_ids": """SELECT COUNT(*) AS v FROM (
        SELECT transaction_id
        FROM property_transactions
        GROUP BY transaction_id
        HAVING COUNT(*) > 1
    );""",
    "invalid_sale_price": "SELECT COUNT(*) AS v FROM property_transactions WHERE sale_price <= 0;",
    "future_dated_transactions": "SELECT COUNT(*) AS v FROM property_transactions WHERE DATE(transaction_date) > DATE('now');",
    "orphan_property_fk": """SELECT COUNT(*) AS v
        FROM property_transactions t
        LEFT JOIN property_registry p ON p.property_id = t.property_id
        WHERE p.property_id IS NULL;""",
    "orphan_buyer_fk": """SELECT COUNT(*) AS v
        FROM property_transactions t
        LEFT JOIN property_owners o ON o.owner_id = t.buyer_owner_id
        WHERE t.buyer_owner_id IS NOT NULL AND o.owner_id IS NULL;""",
    "invalid_mortgage_amount": """SELECT COUNT(*) AS v
        FROM property_transactions
        WHERE mortgage_flag = 1 AND mortgage_amount > sale_price;""",
}

def main(db_path: str, out_path: str) -> None:
    con = sqlite3.connect(db_path)
    metrics = {}
    for name, q in DQ_QUERIES.items():
        metrics[name] = int(pd.read_sql_query(q, con)["v"].iloc[0])

    snapshot = pd.DataFrame([metrics])
    snapshot.insert(0, "run_timestamp", pd.Timestamp.now().isoformat(timespec="seconds"))
    snapshot.to_csv(out_path, index=False)
    con.close()
    print(f"Saved DQ metrics snapshot to {out_path}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    main(args.db, args.out)
