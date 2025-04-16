/*
 * SNOWLAB SANDBOX - CRM TABLES CREATION
 * 
 * Purpose:
 * This script creates the bronze layer tables for the CRM system data.
 * These tables store raw data as-is from the source system.
 *
 * Tables Created:
 * 1. CRM_CUST_INFO: Customer information
 *    - Basic customer details
 *    - Demographics
 *    - Creation dates
 *
 * 2. CRM_PRD_INFO: Product information
 *    - Product details
 *    - Pricing
 *    - Product lifecycle dates
 *
 * 3. CRM_SALES_DETAILS: Sales transactions
 *    - Order information
 *    - Sales amounts
 *    - Quantities
 *    - Dates (stored as NUMBER)
 *
 * Usage:
 * Execute this script to create or replace CRM tables in the bronze layer.
 *
 * Version: 1.0
 * Created: 2024-04-16
 */

-- Customer Information Table
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.CRM_CUST_INFO (
    CST_ID NUMBER,
    CST_KEY TEXT,
    CST_FIRSTNAME TEXT,
    CST_LASTNAME TEXT,
    CST_MARITAL_STATUS TEXT,
    CST_GNDR TEXT,
    CST_CREATE_DATE DATE
);

-- Product Information Table
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.CRM_PRD_INFO (
    PRD_ID NUMBER,
    PRD_KEY TEXT,
    PRD_NM TEXT,
    PRD_COST NUMBER,
    PRD_LINE TEXT,
    PRD_START_DT DATE,
    PRD_END_DT DATE
);

-- Sales Details Table
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.CRM_SALES_DETAILS (
    SLS_ORD_NUM TEXT,
    SLS_PRD_KEY TEXT,
    SLS_CUST_ID NUMBER,
    SLS_ORDER_DT NUMBER,  -- Stored as NUMBER, will be converted in silver layer
    SLS_SHIP_DT NUMBER,   -- Stored as NUMBER, will be converted in silver layer
    SLS_DUE_DT NUMBER,    -- Stored as NUMBER, will be converted in silver layer
    SLS_SALES NUMBER,
    SLS_QUANTITY NUMBER,
    SLS_PRICE NUMBER
);

-- Template for CRM tables
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.BRONZE.CRM_{table_name} (
    -- Add your CSV columns here
    -- Example:
    -- COLUMN1 STRING,
    -- COLUMN2 NUMBER,
    -- COLUMN3 TIMESTAMP_NTZ,
    
    -- Metadata columns (standard for all tables)
    LOAD_ID STRING DEFAULT SNOWLAB_SANDBOX.UTILS.GENERATE_UUID(),
    SOURCE_SYSTEM STRING DEFAULT 'CRM',
    SOURCE_FILE_NAME STRING,
    LOAD_TIMESTAMP TIMESTAMP_NTZ DEFAULT SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP(),
    ROW_HASH STRING,  -- For change detection
    IS_CURRENT BOOLEAN DEFAULT TRUE,
    VALID_FROM TIMESTAMP_NTZ DEFAULT SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP(),
    VALID_TO TIMESTAMP_NTZ DEFAULT NULL
);

-- Create a stream for change data capture
CREATE OR REPLACE STREAM SNOWLAB_SANDBOX.BRONZE.CRM_{table_name}_STREAM ON TABLE SNOWLAB_SANDBOX.BRONZE.CRM_{table_name};

-- Create a task to maintain the current flag
CREATE OR REPLACE TASK SNOWLAB_SANDBOX.BRONZE.CRM_{table_name}_MAINTAIN_CURRENT
    WAREHOUSE = SNOWLAB_WH
    SCHEDULE = '1 MINUTE'
AS
    UPDATE SNOWLAB_SANDBOX.BRONZE.CRM_{table_name}
    SET IS_CURRENT = FALSE,
        VALID_TO = SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP()
    WHERE IS_CURRENT = TRUE
    AND ROW_HASH IN (
        SELECT ROW_HASH
        FROM SNOWLAB_SANDBOX.BRONZE.CRM_{table_name}_STREAM
        WHERE METADATA$ACTION = 'INSERT'
    ); 