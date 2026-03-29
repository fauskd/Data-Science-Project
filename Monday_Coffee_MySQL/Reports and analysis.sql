-- Q1. How many people in each city are estimated to consume coffee, 
-- given that 25% of the population does?

select city_name, 
round((population * 0.25)/1000000 , 2) as coffee_consumers,
city_rank
from city
order by population desc;

-- total coffee sales last quater of 2023 and find it for each city?
select s.sale_date, sum(s.total) as total_revenue, 
ci.city_name as city_name_high,
year(s.sale_date) as year,
quarter(s.sale_date) as qtr
from sales as s
join customers as c
using (customer_id)
join city as ci
using (city_id)
where year(s.sale_date) = 2023 and quarter(s.sale_date) = 4
group by s.sale_date, ci.city_name;


-- Sales count for each products
-- How many units of each coffee product have been sold?

select p.product_name as coffee_name,
count(s.sale_id) as total_orders
from products as p
left join sales as s
using (product_id)
group by 1 order by 2 desc;


-- average sales amount per city
-- What is the average sales amount per customer in each city?
select ci.city_name,
round(sum(s.total), 2) as total_sales,
count(distinct c.customer_id) as total_cus,
round(sum(s.total) / count(distinct c.customer_id), 2) as avg_sales
from city as ci
join customers as c
using (city_id)
join sales as s
using (customer_id)
group by 1 order by 2 desc;

-- City population and coffee consumers 
-- provide a list of cities along with ther populations and estimated coffee consumers.

with a as (select city_name, round(sum((population * 0.25)/1000000), 2) as total_consumers
from city
group by city_name),
b as 
(select ci.city_name, count(distinct (c.customer_id)) as unique_cus
from sales as s
join customers as c
using (customer_id)
join city as ci
using (city_id)
group by 1)

select city_name, total_consumers, unique_cus
from a join b
using (city_name);

-- Top selling products by City
-- What are the top 3 products in each city based on sales volume?

select * from (select ci.city_name,
p.product_name,
count(s.sale_id) as total_orders,
dense_rank() over(partition by city_name order by count(s.sale_id) desc) as rnk
from sales as s
join products as p
using (product_id)
join customers as c
using (customer_id)
join city as ci
using (city_id)
group by 1,2)as a
where rnk <= 3;

-- customer segmentation by city
-- How many unique customers are there in each city who have purchased coffee products?
select ci.city_name,
count(distinct c.customer_id) as unique_cus
from city as ci 
join customers as c
using (city_id)
group by 1;

-- Average sales vs Rent
-- Find each city and their average sale per customer and average rent per customer
select ci.city_name,
ci.estimated_rent,
count(distinct c.customer_id) as unique_cus,
round(sum(s.total), 2) as total_rev,
round(round(sum(s.total), 2)/count(distinct c.customer_id), 2) as avg_sale_per_cus,
round(ci.estimated_rent/count(distinct c.customer_id), 2) as avg_rent_per_cus
from city as ci
join customers as c
using (city_id)
join sales as s
using (customer_id)
group by 1,2
order by 6 desc;


-- Monthly sales growth
-- Sales growth rate: Calculate the percentage growth or decline in sales over time period (months)
-- by each city

with a as(select ci.city_name,
year(s.sale_date) as year_,
month(s.sale_date) as Month_,
sum(s.total) as curr_month_sale,
lag(sum(s.total), 1) 
over (partition by ci.city_name order by year(s.sale_date), month(s.sale_date))
as last_month_sale
from city as ci
join customers as c
using (city_id)
join sales as s
using (customer_id)
group by 1, 2,3
order by 1,2,3)
select *,
round(curr_month_sale /last_month_sale, 2) as growth_sale
from a;












