# Data Quality Rules (Mini)

R1 Completeness: transaction_id, property_id, transaction_date not NULL
R2 Uniqueness: transaction_id unique
R3 Validity: sale_price > 0
R4 Timeliness: no future dates
R5 Refer. integrity: property_id exists in registry
R6 Refer. integrity: buyer_owner_id exists in owners
R7 Mortgage validity: mortgage_amount <= sale_price when mortgage_flag = 1
