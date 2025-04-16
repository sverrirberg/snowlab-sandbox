# Snowlab Sandbox

A data warehouse project using Snowflake and following the medallion architecture pattern.

## Project Structure

```
snowlab-sandbox/
├── README.md
├── .gitignore
├── docs/               # Project documentation
├── sql/               # SQL scripts
│   ├── bronze/        # Raw data ingestion
│   ├── silver/        # Cleaned and transformed data
│   └── gold/          # Business-ready data
└── notebooks/         # Jupyter notebooks for analysis
```

## Medallion Architecture

This project follows the medallion architecture pattern with three layers:

1. **Bronze Layer**: Raw data ingestion
   - Preserves source data in its original form
   - Includes metadata and audit information
   - No transformations applied

2. **Silver Layer**: Cleaned and transformed data
   - Data quality checks
   - Standardized formats
   - Basic transformations
   - Data validation

3. **Gold Layer**: Business-ready data
   - Business logic applied
   - Aggregations and summaries
   - Optimized for consumption
   - Final data products

## Getting Started

1. Clone this repository
2. Set up your Snowflake environment
3. Configure your SnowSQL connection
4. Start working with the SQL scripts in the respective layers

## Contributing

Feel free to contribute to this project by submitting pull requests or opening issues. 