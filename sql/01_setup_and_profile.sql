-- 01_setup_and_profile.sql
-- Purpose: Confirm tables, basic profiling, and row counts.

.tables

SELECT 'property_owners' AS table_name, COUNT(*) AS row_count FROM property_owners
UNION ALL
SELECT 'property_registry', COUNT(*) FROM property_registry
UNION ALL
SELECT 'property_transactions', COUNT(*) FROM property_transactions;

SELECT * FROM property_owners LIMIT 5;
SELECT * FROM property_registry LIMIT 5;
SELECT * FROM property_transactions LIMIT 5;
