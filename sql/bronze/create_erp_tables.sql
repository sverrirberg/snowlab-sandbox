/*
 * SNOWLAB SANDBOX - ERP TABLES CREATION
 * 
 * Purpose:
 * This script creates the bronze layer tables for the ERP system data.
 * These tables store raw data as-is from the source system.
 *
 * Tables Created:
 * 1. ERP_CUST_AZ12: Customer information
 *    - Customer IDs
 *    - Birth dates
 *    - Gender information
 *
 * 2. ERP_LOG_A101: System logs
 *    - Log entries
 *    - System events
 *
 * 3. ERP_PX_CAT_G1V2: Product categories
 *    - Category hierarchy
 *    - Maintenance flags
 *
 * Usage:
 * Execute this script to create or replace ERP tables in the bronze layer.
 *
 * Version: 1.0
 * Created: 2024-04-16
 */

-- Customer Information Table
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.ERP_CUST_AZ12 (
    CID TEXT,
    BDATE DATE,
    GEN TEXT
);

-- Log Information Table
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.ERP_LOG_A101 (
    C1 TEXT,
    C2 TEXT
);

-- Product Categories Table
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.ERP_PX_CAT_G1V2 (
    ID TEXT,
    CAT TEXT,
    SUBCAT TEXT,
    MAINTENANCE BOOLEAN
);

-- Template for ERP tables
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.ERP_{table_name} (
    -- Add your CSV columns here
    -- Example:
    -- COLUMN1 STRING,
    -- COLUMN2 NUMBER,
    -- COLUMN3 TIMESTAMP_NTZ,
    
    -- Metadata columns (standard for all tables)
    LOAD_ID STRING DEFAULT SNOWLAB_SANDBOX.UTILS.GENERATE_UUID(),
    SOURCE_SYSTEM STRING DEFAULT 'ERP',
    SOURCE_FILE_NAME STRING,
    LOAD_TIMESTAMP TIMESTAMP_NTZ DEFAULT SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP(),
    ROW_HASH STRING,  -- For change detection
    IS_CURRENT BOOLEAN DEFAULT TRUE,
    VALID_FROM TIMESTAMP_NTZ DEFAULT SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP(),
    VALID_TO TIMESTAMP_NTZ DEFAULT NULL
);

-- Create a stream for change data capture
CREATE OR REPLACE STREAM SNOWLAB_SANDBOX.BRONZE.ERP_{table_name}_STREAM ON TABLE SNOWLAB_SANDBOX.BRONZE.ERP_{table_name};

-- Create a task to maintain the current flag
CREATE OR REPLACE TASK SNOWLAB_SANDBOX.BRONZE.ERP_{table_name}_MAINTAIN_CURRENT
    WAREHOUSE = SNOWLAB_WH
    SCHEDULE = '1 MINUTE'
AS
    UPDATE SNOWLAB_SANDBOX.BRONZE.ERP_{table_name}
    SET IS_CURRENT = FALSE,
        VALID_TO = SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP()
    WHERE IS_CURRENT = TRUE
    AND ROW_HASH IN (
        SELECT ROW_HASH
        FROM SNOWLAB_SANDBOX.BRONZE.ERP_{table_name}_STREAM
        WHERE METADATA$ACTION = 'INSERT'
    ); 