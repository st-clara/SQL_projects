	-- EXPLORATORY DATA ANALYSIS

	-- olist_customers_dataset
	-- How many customers are in each city and state?
	-- Oder by dec
select 
	customer_city,
    customer_state,
    count(*) as city_count 
from 
	olist_customers_dataset
group by
	customer_city,
    customer_state
    order by
    3 desc;
    
    
    -- olist_orders_dataset
    -- Number of oder ordered each day?
    --  order by desc
select 
	order_purchase_timestamp,
	count(*) as ordered_item
from
	olist_orders_dataset
group by
	order_purchase_timestamp
order by 2 desc;
    
    
    --  olist_products_dataset
    -- What categories have the most number ordered?
    -- we can get the product category name from the order_item tables 
    -- Therefore, we do an inner join for the name
select *
from olist_products_dataset
join olist_order_items_dataset;

select 
    p.product_category_name,
    count(*) as category_count
from
	olist_products_dataset as p
join
	olist_order_items_dataset as o 
on
	p.product_id = o.product_id
group by
	 p.product_category_name,
    o.order_id
order by
	2 desc;
		
        
	-- olist_orders_dataset
	-- our date column is havining a text datatype instead of a date so we have to change it first
    -- Here we look at the difference between two dates and the average for each month
    
select *
from olist_orders_dataset;

desc
	olist_orders_dataset;
    
UPDATE 
	olist_orders_dataset
SET 
	order_delivered_customer_date = NULL
WHERE
	order_delivered_customer_date = ''
and 
	order_estimated_delivery_date = '';
    
alter table 
	olist_orders_dataset
modify
	order_delivered_customer_date timestamp;
	
alter table
	olist_orders_dataset
modify 
	order_estimated_delivery_date timestamp;

select 
    order_id,
    order_status,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    sum(order_estimated_delivery_date - order_delivered_customer_date) as date_diff
from
    olist_orders_dataset
where order_status = 'delivered'
group by
	order_id,
    order_status,
    order_delivered_customer_date,
    order_estimated_delivery_date;
    
select
	order_purchase_timestamp,
	dayofyear(order_purchase_timestamp) as order_year,
	dayofmonth(order_purchase_timestamp) as order_month,
	round(avg(order_estimated_delivery_date - order_delivered_customer_date),1)as date_diff
from 
	 olist_orders_dataset
where 
	order_status = 'delivered'
AND 
	order_purchase_timestamp is not null
AND
	order_purchase_timestamp != ''
group by
		order_purchase_timestamp,
        order_year,
        order_month
order by 
	2,3 asc;
    
    
	

    
    
    