"""data_profiling.py
Create a simple profiling report for governance (null rates, distinct counts).
Run:
python python/data_profiling.py --db data/property_registry.db --out dashboards/profile_report.csv
"""

import argparse
import sqlite3
import pandas as pd

def main(db_path: str, out_path: str) -> None:
    con = sqlite3.connect(db_path)
    tables = ["property_owners", "property_registry", "property_transactions"]

    rows = []
    for t in tables:
        df = pd.read_sql_query(f"SELECT * FROM {t}", con)
        for col in df.columns:
            rows.append({
                "table": t,
                "column": col,
                "dtype": str(df[col].dtype),
                "row_count": len(df),
                "null_count": int(df[col].isna().sum()),
                "null_rate": float(df[col].isna().mean()),
                "distinct_count": int(df[col].nunique(dropna=True)),
            })

    pd.DataFrame(rows).to_csv(out_path, index=False)
    con.close()
    print(f"Saved profile report to {out_path}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    main(args.db, args.out)
