Data Catalog for Gold Layer
Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.

1. gold.dim_customers
Purpose: Stores customer details enriched with demographic and geographic data.
Columns:
| Column Name     | Data Type    | Description                                                                          |
| --------------- | ------------ | ------------------------------------------------------------------------------------ |
| customer_key    | INT          | Surrogate key uniquely identifying each customer record in the dimension table       |
| customer_id     | INT          | Unique numerical identifier assigned to each customer                                |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing |
| first_name      | NVARCHAR(50) | Customer’s first name as recorded in the system                                      |
| last_name       | NVARCHAR(50) | Customer’s last or family name                                                       |
| country         | NVARCHAR(50) | Country of residence of the customer (e.g., Australia)                               |
| marital_status  | NVARCHAR(50) | Marital status of the customer (e.g., Married, Single)                               |
| gender          | NVARCHAR(50) | Gender of the customer (e.g., Male, Female, n/a)                                     |
| birthdate       | DATE         | Customer’s date of birth in `YYYY-MM-DD` format                                      |
| create_date     | DATE         | Date when the customer record was created                                            |

Purpose: Provides information about the products and their attributes.
Columns:
| Column Name          | Data Type    | Description                                                  |
| -------------------- | ------------ | ------------------------------------------------------------ |
| product_key          | INT          | Surrogate key uniquely identifying each product record       |
| product_id           | INT          | Unique identifier assigned to the product                    |
| product_number       | NVARCHAR(50) | Structured alphanumeric code used for tracking and inventory |
| product_name         | NVARCHAR(50) | Descriptive product name including type, color, and size     |
| category_id          | NVARCHAR(50) | Identifier for the product category                          |
| category             | NVARCHAR(50) | High-level product classification (e.g., Bikes, Components)  |
| subcategory          | NVARCHAR(50) | Detailed classification within the category                  |
| maintenance_required | NVARCHAR(50) | Indicates if maintenance is required (Yes / No)              |
| cost                 | INT          | Base cost of the product in monetary units                   |
| product_line         | NVARCHAR(50) | Product line or series (e.g., Road, Mountain)                |
| start_date           | DATE         | Date when the product became available                       |

3. gold.fact_sales
Purpose: Stores transactional sales data for analytical purposes.
Columns:
| Column Name   | Data Type    | Description                                                         |
| ------------- | ------------ | ------------------------------------------------------------------- |
| order_number  | NVARCHAR(50) | Unique alphanumeric identifier for each sales order (e.g., SO54496) |
| product_key   | INT          | Surrogate key referencing `gold.dim_products`                       |
| customer_key  | INT          | Surrogate key referencing `gold.dim_customers`                      |
| order_date    | DATE         | Date when the order was placed                                      |
| shipping_date | DATE         | Date when the order was shipped                                     |
| due_date      | DATE         | Payment due date for the order                                      |
| sales_amount  | INT          | Total monetary value of the sale per line item                      |
| quantity      | INT          | Number of units ordered                                             |
| price         | INT          | Price per unit for the product                                      |
