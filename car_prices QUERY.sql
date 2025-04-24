select *
from car_prices;

-- How many cars where sold in each state based on the state of registration?

select state,  count(*)
from car_prices
group by state;

-- Which kind of cars are most popular?
-- How many sales have been made for each make and model?

select make, model, count(*)
from car_prices
group by make, model
order by 3 desc;

-- Are there differences in sales prices for each state?
-- What is the avg sale price for cars in each state?
-- What is the avg sale price for cars in each month and year?

select state, avg(sellingprice)
from car_prices
group by state
order by 2 asc; 

ALTER TABLE car_prices MODIFY saledate BIGINT;
UPDATE car_prices
SET saledate = DATE(FROM_UNIXTIME(saledate));
ALTER TABLE car_prices MODIFY saledate DATE;

select state,
month(saledate)as sale_month,
year(saledate)as sale_yeah,
avg(sellingprice)as avg_selling_price
from car_prices
group by state, saledate;

-- Which month of the year has the most sales?

select month(saledate), count(*)
from car_prices
group by saledate
order by 2 desc;

-- What are the top 5 most selling cars within each body type?

select
body,
make,
model,
num,
top5
from(
	select 
	body,
	make, 
	model,
	count(*)as num,
	rank( )over(partition by body order by count(*)desc) as top5
	from car_prices
	group by body,make, model
)t
where top5 <=5
order by num desc;

-- find the sales with salling price is higher than the avg for that model and how much high it is for that average?
-- ie sale higher than the model and how much higher?

select
make,
model,
vin,
sellingprice,
saledate,
avg_model,
sellingprice/avg_model as ratio_price
from(
	select
	make,
	model,
	vin,
	sellingprice,
	saledate,
	avg(sellingprice)over(partition by make,model) as avg_model
	from car_prices)d
where make != ''
and model != ''
and sellingprice >avg_model
order by sellingprice/ avg_model desc;

-- how did the car condition impact on sales price?

select 
`condition`,
count(*) num_sales,
avg(sellingprice) as avg_sales
from car_prices
group by `condition`
order by 1 asc;

-- how did the odometer impact on price?

select 
odometer,
count(*) as num_sales,
avg(sellingprice) as avg_sales
from car_prices
group by odometer
order by 1 desc;

-- create a report on the different car brand or car make?

select
make,
count(distinct model)as num_model,
count(*) as num_sales,
min(sellingprice)as min_price,
max(sellingprice)as max_price,
avg(sellingprice) as avg_price
from car_prices
group by make
order by 2 desc;



