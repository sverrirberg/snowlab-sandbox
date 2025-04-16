# Data Ingestion Process

## Overview
This document describes the process of loading CSV files into the Snowflake bronze layer tables using the Snowflake web interface.

## Source Data Files
Six CSV files from two source systems:

### CRM System Files
1. Customer Information (`CRM_CUST_INFO`)
2. Product Information (`CRM_PRD_INFO`)
3. Sales Details (`CRM_SALES_DETAILS`)

### ERP System Files
1. Customer Data (`ERP_CUST_AZ12`)
2. Log Data (`ERP_LOG_A101`)
3. Product Categories (`ERP_PX_CAT_G1V2`)

## Ingestion Process

### Step 1: Access Snowflake UI
1. Log into Snowflake web interface
2. Ensure you have the appropriate roles and permissions

### Step 2: Navigate to Data Loading Interface
1. Click on "Data" in the main navigation
2. Select "Databases" → "SNOWLAB_SANDBOX" → "BRONZE"
3. Click "Load Data" button

### Step 3: File Upload
1. Select "Load from files" option
2. Choose the warehouse: `SNOWLAB_WH`
3. Click "Select files" and choose your CSV file
4. Wait for file upload to complete

### Step 4: Configure Load Settings
1. Select target table from dropdown or create new
2. Configure file format settings:
   - File format: CSV
   - Field delimiter: Comma (,)
   - Skip header: 1 (if headers present)
   - Trim spaces: Yes
   - Date format: AUTO (adjust if needed)
   - Timestamp format: AUTO (adjust if needed)
   - Number format: AUTO (adjust if needed)

### Step 5: Column Mapping
1. Review auto-detected column mappings
2. Adjust data types if necessary
3. Ensure source columns map to correct target columns

### Step 6: Load Data
1. Click "Load" button
2. Monitor load progress
3. Review results and any error messages

### Step 7: Verify Load
1. Execute basic row count check
2. Verify data types are correct
3. Run validation queries from `sql/validation/bronze_validation.sql`

## Load Status Summary

| Table Name | Row Count | Load Date | Status |
|------------|-----------|-----------|---------|
| CRM_CUST_INFO | 18,494 | 2024-04-16 | Success |
| CRM_PRD_INFO | 397 | 2024-04-16 | Success |
| CRM_SALES_DETAILS | 60,398 | 2024-04-16 | Success |
| ERP_CUST_AZ12 | 18,484 | 2024-04-16 | Success |
| ERP_LOG_A101 | 18,485 | 2024-04-16 | Success |
| ERP_PX_CAT_G1V2 | 37 | 2024-04-16 | Success |

## Data Quality Notes
- CRM_SALES_DETAILS: Date fields stored as NUMBER format
- ERP_CUST_AZ12: 1,476 NULL values in BDATE field
- ERP_LOG_A101: 337 NULL values in C2 field

## Alternative Loading Methods
For future loads or automation, consider:
1. SnowSQL command line
2. Snowflake COPY INTO command
3. Snowpipe for automated ingestion

## Next Steps
1. Run validation queries
2. Review data quality metrics
3. Plan silver layer transformations

## Related Files
- Table creation scripts: `sql/bronze/create_*_tables.sql`
- Validation queries: `sql/validation/bronze_validation.sql` 