# Data Governance Management System

## Project Overview

This project simulates the responsibilities of a Data Governance Analyst working in a property registry environment similar to organizations such as Teranet.

The objective is to ensure that enterprise data is accurate, well-documented, and properly governed throughout its lifecycle.

This project demonstrates practical governance tasks including:

* Data quality monitoring using SQL
* Metadata management (catalog, glossary, lineage)
* Governance documentation
* Automated data quality checks using Python
* Governance metrics tracking

---

# Dataset Overview

The SQLite database contains three core tables.

### Property Owners

Stores information about property owners.

Key fields:

* owner_id
* owner_name
* email
* phone
* created_at

---

### Property Registry

Stores registered property records.

Key fields:

* property_id
* address_line1
* city
* province
* postal_code
* property_type
* assessed_value

---

### Property Transactions

Stores property sale transactions.

Key fields:

* transaction_id
* property_id
* buyer_owner_id
* seller_owner_id
* transaction_date
* sale_price
* mortgage_amount
* status

---

# Data Quality Assessment

Data quality rules were executed using SQL to identify issues affecting data reliability.

These checks simulate the monitoring performed within enterprise Data Governance Programs.

---

# Data Quality Metrics

The governance metrics table produced the following results:

| Metric                     | Result |
| -------------------------- | ------ |
| Total Transactions         | 658    |
| Missing Critical Fields    | 0      |
| Duplicate Transaction IDs  | 19     |
| Invalid Sale Prices        | 23     |
| Future-Dated Transactions  | 13     |
| Orphan Property References | 6      |
| Orphan Buyer References    | 10     |
| Invalid Mortgage Amounts   | 15     |

---

# Interpretation of Data Quality Issues

### Duplicate Transactions

19 duplicate transaction IDs were detected.

This violates the uniqueness requirement for transaction identifiers.

Possible causes include:

* duplicate data ingestion
* ETL pipeline retries
* system integration issues

Recommended remediation:

* enforce primary key constraints
* implement deduplication logic in ingestion pipelines

---

### Invalid Sale Prices

23 transactions contain sale prices less than or equal to zero.

This violates financial validation rules.

Recommended remediation:

* enforce validation during transaction capture
* apply validation checks during data ingestion

---

### Future Transaction Dates

13 transactions contain future transaction dates.

Possible causes include:

* system clock issues
* manual entry errors
* testing data entering production environments

Recommended remediation:

* implement validation preventing future transaction dates.

---

### Orphan Property Records

6 transactions reference property IDs that do not exist in the property registry table.

This violates referential integrity.

Recommended remediation:

* enforce foreign key constraints
* validate property existence before transaction registration

---

### Orphan Buyer Records

10 buyer IDs do not exist in the owner table.

This indicates possible synchronization issues between systems.

Recommended remediation:

* implement validation during transaction creation
* synchronize owner records across systems

---

### Invalid Mortgage Amounts

15 transactions contain mortgage values greater than the property sale price.

This violates financial validation rules.

Recommended remediation:

* enforce mortgage ≤ sale price rule
* implement validation checks within ingestion pipelines

---

# Governance View Example

A curated SQL view was created to simplify downstream analysis.

Example output from the curated view shows top property transaction markets:

| City     | Province | Transactions | Total Sale Value |
| -------- | -------- | ------------ | ---------------- |
| Calgary  | NS       | 18           | 13,612,782       |
| Waterloo | BC       | 15           | 11,981,304       |
| London   | AB       | 15           | 11,531,959       |
| Ottawa   | ON       | 13           | 9,017,266        |
| Brampton | AB       | 12           | 8,125,247        |

This demonstrates how governed datasets can support analytics and reporting.

---

# Metadata & Governance Documentation

The project includes several governance artifacts typically maintained by enterprise data governance teams.

### Metadata Artifacts

* Data Catalog
* Business Glossary
* Data Lineage

### Governance Artifacts

* Governance Framework
* Data Stewardship Model
* Data Quality Rules

These artifacts improve data discoverability and governance accountability.

---

# Automation

Two Python scripts automate governance monitoring.

### Data Profiling

Generates a profiling report showing:

* null rates
* column types
* distinct values

Output file:

dashboards/profile_report.csv

---

### Data Quality Pipeline

Automatically runs governance checks and generates a metrics snapshot.

Output file:

dashboards/dq_metrics_snapshot.csv

This file can be visualized in BI tools such as Tableau or Power BI.

---

# Technologies Used

* SQLite
* SQL
* Python
* GitHub

---

# Key Governance Outcomes

This project demonstrates the following capabilities:

* Identification of enterprise data quality risks
* Implementation of automated data validation rules
* Documentation of metadata and governance policies
* Monitoring of governance KPIs
* Creation of curated data views for analytics

---

# Future Improvements

Possible extensions include:

* Data Quality Dashboard in Power BI
* Data Lineage Visualization
* Data Governance Maturity Assessment

---

# Author

MahindraboopathiS