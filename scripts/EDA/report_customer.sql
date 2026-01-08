/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
--base query 
--selecting the relevant bcolumns 

create view gold.report_customers as 
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.sales,
        f.quantity,
        c.customer_key,
        c.customer_id,
        f.sales_order_date,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.sales_order_date IS NOT NULL
)
--customer aggregation 
,customer_aggregation as (
SELECT
    customer_key,
    customer_id,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    max(sales_order_date) as last_order,
    datediff(month,min(sales_order_date),max(sales_order_date)) as lifespan
    
FROM base_query
GROUP BY
    customer_key,
    customer_id,
    customer_name,
    age 
)

select 
customer_key,
    customer_id,
    customer_name,
    age,
    case when age < 20 then 'under 20 '
         when age between 20 and 29 then '20-29'
         when age between  30 and 39 then '30-39'
         when age between 40 and 49 then '40-49'
         else 'above 50 '
    end as 'age_group',
    case when lifespan >=12 and total_sales>5000 then 'VIP'
         WHEN lifespan>=12 and total_sales <=5000 then 'regular'
         else 'new'
    end as 'customer_segments',
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    last_order,
    datediff(month,last_order,getdate()) as recency,
    lifespan,
  -- Compuate average order value (AVO)
     case when total_sales =0 then '0'
         else total_sales/total_orders
    end as average_order_sales,
  
  -- Compuate average monthly spend
    case when lifespan = 0 then total_sales
         else total_sales/lifespan 
    end as average_monthly_spend
    from customer_aggregation
