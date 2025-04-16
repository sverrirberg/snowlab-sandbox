# Naming Conventions

## Overview
This document outlines the naming standards used in the Snowlab Sandbox project across different layers of the data warehouse.

## General Principles
1. Use UPPERCASE for all database objects
2. Use underscores (_) to separate words
3. Avoid special characters and spaces
4. Keep names concise but descriptive
5. Use consistent prefixes and suffixes

## Source System Prefixes
- `CRM_`: Customer Relationship Management system
- `ERP_`: Enterprise Resource Planning system

## Layer-Specific Conventions

### Bronze Layer
- Raw tables maintain source system prefix
- Example: `CRM_CUST_INFO`, `ERP_LOG_A101`
- No transformations or renaming from source

### Silver Layer
- Prefix: `SIL_`
- Cleaned and standardized names
- Example: `SIL_CUSTOMER`, `SIL_PRODUCT`

### Gold Layer
- Prefix: `GOLD_`
- Business-specific names
- Example: `GOLD_CUSTOMER_360`, `GOLD_SALES_METRICS`

## Column Naming

### Bronze Layer
- Maintain original source names
- CRM columns:
  - `CST_`: Customer-related
  - `PRD_`: Product-related
  - `SLS_`: Sales-related
- ERP columns: Keep original naming

### Silver Layer
- Standardized column names
- Date columns end with `_DT`
- ID columns end with `_ID`
- Key columns end with `_KEY`
- Amount columns end with `_AMT`
- Quantity columns end with `_QTY`

### Gold Layer
- Business-friendly names
- Metric columns end with appropriate units
- Example: `REVENUE_USD`, `QUANTITY_SOLD`

## File Naming Conventions

### SQL Scripts
- Use lowercase with underscores
- Format: `<purpose>_<object>_<action>.sql`
- Example: `create_crm_tables.sql`, `validate_bronze_tables.sql`

### Documentation
- Use lowercase with underscores
- Format: `<topic>_<subtopic>.md`
- Example: `data_ingestion.md`, `naming_conventions.md`

## Schema Naming
- `BRONZE`: Raw data layer
- `SILVER`: Cleaned data layer
- `GOLD`: Business layer
- `UTILS`: Utility objects

## Object Types
- Tables: Noun or noun phrases
- Views: Prefix `VW_`
- Functions: Prefix `FN_`
- Stored Procedures: Prefix `SP_`
- Streams: Suffix `_STREAM`
- Tasks: Suffix `_TASK`

## Examples

### Tables
```sql
-- Bronze Layer
BRONZE.CRM_CUST_INFO
BRONZE.ERP_LOG_A101

-- Silver Layer
SILVER.SIL_CUSTOMER
SILVER.SIL_PRODUCT

-- Gold Layer
GOLD.GOLD_CUSTOMER_360
GOLD.GOLD_SALES_METRICS
```

### Columns
```sql
-- Bronze Layer (original names)
CST_ID, PRD_KEY, SLS_ORDER_DT

-- Silver Layer (standardized)
CUSTOMER_ID, PRODUCT_KEY, ORDER_DATE_DT

-- Gold Layer (business-friendly)
CUSTOMER_SEGMENT, TOTAL_REVENUE_USD
```

## Validation Rules
1. All database objects must follow these conventions
2. New objects must be reviewed for naming compliance
3. Legacy names should be updated when moving between layers
4. Exceptions must be documented and approved

## Related Documentation
- `data_ingestion.md`: Data loading process
- `sql/bronze/create_*_tables.sql`: Table creation scripts
- `sql/validation/bronze_validation.sql`: Validation queries 