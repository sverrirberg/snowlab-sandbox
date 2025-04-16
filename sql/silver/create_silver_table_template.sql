-- Template for creating silver layer tables
CREATE OR REPLACE TABLE SNOWLAB_SANDBOX.SILVER.{table_name} (
    -- Transformed data columns will go here
    -- Add your transformed columns as needed
    
    -- Data quality metadata
    QUALITY_CHECK_TIMESTAMP TIMESTAMP_NTZ DEFAULT SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP(),
    QUALITY_CHECK_STATUS STRING,
    QUALITY_CHECK_MESSAGE STRING,
    SOURCE_LOAD_ID STRING,  -- References LOAD_ID from bronze
    PROCESSING_TIMESTAMP TIMESTAMP_NTZ DEFAULT SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP()
);

-- Create a view for data quality monitoring
CREATE OR REPLACE VIEW SNOWLAB_SANDBOX.SILVER.{table_name}_QUALITY_METRICS AS
SELECT
    QUALITY_CHECK_STATUS,
    COUNT(*) as RECORD_COUNT,
    MIN(QUALITY_CHECK_TIMESTAMP) as FIRST_CHECK,
    MAX(QUALITY_CHECK_TIMESTAMP) as LAST_CHECK
FROM SNOWLAB_SANDBOX.SILVER.{table_name}
GROUP BY QUALITY_CHECK_STATUS;

-- Create a stored procedure for data quality checks
CREATE OR REPLACE PROCEDURE SNOWLAB_SANDBOX.SILVER.{table_name}_QUALITY_CHECK()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
    // This is a template for data quality checks
    // Implement your specific data quality rules here
    return "Data quality check completed";
$$; 