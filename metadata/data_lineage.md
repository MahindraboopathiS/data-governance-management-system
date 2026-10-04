# Data Lineage (Mini)

property_owners + property_registry + property_transactions
        -> v_curated_transactions (SQL curated view)
        -> dq_run_metrics (historical DQ metrics)
        -> dashboards/*.csv (dashboard-ready outputs)
