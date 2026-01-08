use DataWarehouse;
--change over the time trends
select datetrunc(month,sales_order_date) as year,
sum(sales)as total_sales,
count(distinct customer_key) as total_cutsomer,
sum(quantity) as total_quantity
from gold.fact_sales
where sales_order_date is not null 
group by datetrunc(month,sales_order_date)
order by datetrunc(month,sales_order_date)

--Cumulative Analysis
--calculate the total sales per month and the running total of sales over the time 
select 
order_date,
total_sales,
sum(total_sales) over( partition by order_date order by order_date) as running_total
from
(
select datetrunc(year,sales_order_date) as order_date ,
sum(sales) as total_sales
from gold.fact_sales
where sales_order_date is not null 
group by datetrunc(year,sales_order_date)
)t;

--performance analysis
/* analyze the yearly perfromnace of the products by comparing their sales to both 
the average sales performance of the product and the previous years sales */
WITH yearly_performance AS (
    SELECT 
        YEAR(f.sales_order_date) AS order_year,
        p.product_name,
        SUM(f.sales) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.sales_order_date IS NOT NULL
    GROUP BY YEAR(f.sales_order_date), p.product_name
)
SELECT 
    order_year,
    product_name,
    total_sales,

    AVG(total_sales) OVER (PARTITION BY product_name) AS average_sales,

    total_sales 
    - AVG(total_sales) OVER (PARTITION BY product_name) AS diff_average,

    CASE 
        WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) < 0 
            THEN 'Below Average'
        WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) > 0 
            THEN 'Above Average'
        ELSE 'Average'
    END AS average_change,

    LAG(total_sales) OVER (
        PARTITION BY product_name 
        ORDER BY order_year
    ) AS previous_year_sales,

    total_sales 
    - LAG(total_sales) OVER (
        PARTITION BY product_name 
        ORDER BY order_year
    ) AS previous_year_difference,

    CASE 
        WHEN total_sales - LAG(total_sales) OVER (
                PARTITION BY product_name 
                ORDER BY order_year
             ) > 0 THEN 'Increase'
        WHEN total_sales - LAG(total_sales) OVER (
                PARTITION BY product_name 
                ORDER BY order_year
             ) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS previous_year_change

FROM yearly_performance
ORDER BY product_name, order_year;

--part of whole 
--find the product which are contributing the most 
with category_sales as (
select 
p.category ,
sum(f.sales) as total_sales 
from gold.fact_sales f left join gold.dim_products p 
on f.product_key=p.product_key
group by category) 

select category,
total_sales ,
sum(total_sales) over() as overall_sales,
concat(round((cast(total_sales as float)/sum(total_sales) over())*100,2),'%') as percentage_of_total
from category_sales
order by total_sales desc

--data segmentation
--segment the products  into cost range and count howe many products fall into each segment 
with product_category as (
select 
product_key,
product_name,
cost,
case when cost < 100  then ' below 100'
     when cost between 100 and 500 then '100-500'
     when cost between 500 and 1000 then '500-1000'
     else 'above 1000'
end as 'cost_range'
from gold.dim_products)

select cost_range,
count(product_key) as total_product_count
from product_category
group by cost_range
order by total_product_count desc


--group the customer based on their spending behaviour
--vip: at least 12 month of history and spending of atleast $5,000
--regular:atleast 12 month of hostory and spending atleast $5,000 or less
--new:lifespan leass than 12 months 
with customer_spending as (
select 
c.customer_key,
sum(f.sales) as total_spending,
min(f.sales_order_date) as min_order_date,
max(f.sales_order_date) as max_order_date,
datediff(month,min(f.sales_order_date),max(sales_order_date)) as lifespan
from gold.fact_sales f left join gold.dim_customers c
on f.customer_key=c.customer_key
group by c.customer_key)

select customer_segment,
count(customer_key) as customer_count from (
select customer_key,total_spending,lifespan,
case when  lifespan>= 12 and total_spending >=5000 then 'VIP'
     WHEN lifespan >= 12 and total_spending <= 5000 then 'Regular'
     else 'New'
end as 'customer_segment'
from customer_spending)t 
group by customer_segment
order by customer_count desc
