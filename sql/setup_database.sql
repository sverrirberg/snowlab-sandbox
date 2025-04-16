/*
 * SNOWLAB SANDBOX - DATABASE SETUP SCRIPT
 * 
 * Purpose:
 * This script initializes the Snowflake environment for the Snowlab Sandbox project,
 * implementing the medallion architecture pattern. It sets up the foundational
 * database structure, schemas, and utility functions needed for data warehousing.
 *
 * Architecture:
 * - Bronze Layer: Raw data ingestion and preservation
 * - Silver Layer: Cleaned and transformed data
 * - Gold Layer: Business-ready data products
 * - Utils: Shared functions and procedures
 *
 * Best Practices Implemented:
 * 1. Schema Organization: Clear separation of concerns between data layers
 * 2. Resource Management: Warehouse configured with auto-suspend to optimize costs
 * 3. Security: Explicit permissions granted to necessary roles
 * 4. Data Lineage: Utility functions for tracking timestamps and generating IDs
 * 5. Naming Conventions: Consistent and descriptive naming across all objects
 *
 * Usage:
 * 1. Execute this script with appropriate Snowflake privileges
 * 2. Review and adjust warehouse size based on workload requirements
 * 3. Modify permissions if different roles are needed
 *
 * Notes:
 * - Warehouse size is set to X-SMALL by default (adjust as needed)
 * - Auto-suspend is set to 300 seconds (5 minutes)
 * - All schemas are granted USAGE to PUBLIC role (modify for production)
 *
 * Version: 1.0
 * Created: [Current Date]
 * Author: [Your Name]
 */

-- Create the main database
CREATE OR REPLACE DATABASE SNOWLAB_SANDBOX;

-- Create schemas for each layer of the medallion architecture
CREATE OR REPLACE SCHEMA SNOWLAB_SANDBOX.BRONZE;
CREATE OR REPLACE SCHEMA SNOWLAB_SANDBOX.SILVER;
CREATE OR REPLACE SCHEMA SNOWLAB_SANDBOX.GOLD;

-- Create a utility schema for shared functions and procedures
CREATE OR REPLACE SCHEMA SNOWLAB_SANDBOX.UTILS;

-- Set up warehouse (adjust size based on your needs)
CREATE OR REPLACE WAREHOUSE SNOWLAB_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- Grant necessary permissions
GRANT USAGE ON DATABASE SNOWLAB_SANDBOX TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA SNOWLAB_SANDBOX.BRONZE TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA SNOWLAB_SANDBOX.SILVER TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA SNOWLAB_SANDBOX.GOLD TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA SNOWLAB_SANDBOX.UTILS TO ROLE PUBLIC;
GRANT USAGE ON WAREHOUSE SNOWLAB_WH TO ROLE PUBLIC;

-- Create a utility function for tracking data lineage
CREATE OR REPLACE FUNCTION SNOWLAB_SANDBOX.UTILS.GET_CURRENT_TIMESTAMP()
RETURNS TIMESTAMP_NTZ
LANGUAGE SQL
AS
$$
    SELECT CURRENT_TIMESTAMP()::TIMESTAMP_NTZ
$$;

-- Create a utility function for generating unique IDs
CREATE OR REPLACE FUNCTION SNOWLAB_SANDBOX.UTILS.GENERATE_UUID()
RETURNS STRING
AS
$$
    UUID_STRING()
$$; 