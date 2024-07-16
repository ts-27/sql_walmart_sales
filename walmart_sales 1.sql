create table if not exists Walmart_sales
	(invoice_id varchar(30) not null primary key, branch varchar(5) not null,
    city varchar(30) not null, customer_type varchar(30) not null, gender varchar(30) not null, product_line varchar(100) not null, 
    unit_price decimal(10,2) not null, quantity int not null, tax float(6,4) not null, revenue decimal(12,4) not null, 
    order_date datetime not null, time text not null, payment_mode varchar(50) not null, cogs decimal(12,2) not null,
    gross_margin_pct float(11,9) , gross_profit decimal(12,4) not null, rating float(2,1)
);
select * from Walmart_sales;

-- add time_of_day --
select time, 
(case
	when time between '00:00:00' and '12:00:00' then 'Morning'
        when time between '12:00:00' and '16:00:00' then 'Afternoon'
        else 'Evening'
        end ) as time_of_day
	from walmart_sales;
    
alter table walmart_sales
add column time_of_day varchar(20);    

update walmart_sales
set time_of_day = (
case
	when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '12:00:00' and '16:00:00' then 'Afternoon'
	else 'Evening'
        end);

-- add day and month name --
select order_date, dayname(order_date)
from walmart_sales;

alter table walmart_sales
add column day_name varchar(20);

update walmart_sales
set day_name = (
	dayname(order_date)
    );
    
select order_date, monthname(order_date)
from walmart_sales;

alter table walmart_sales
add column month_name varchar(20);

update walmart_sales
set month_name = (
	monthname(order_date)
    );
    

-- EDA --

-- how many unique cities --
select distinct city
from walmart_sales;

-- which branch in which city and number of branches per city --
select distinct city, branch
from walmart_sales;

select city, count(branch)
from walmart_sales
group by city;

        
-- how many unique product lines --
select distinct product_line
from walmart_sales;

-- most common payment method --
select payment_mode, count(payment_mode) as cnt_pm
from walmart_sales
group by payment_mode 
order by cnt_pm desc;

-- most selling product line --
select product_line, count(product_line) as cnt_pl
from walmart_sales
group by product_line
order by cnt_pl desc;

-- total revenue by month -- 
select month_name, sum(revenue) as month_rev
from walmart_sales
group by month_name 
order by month_rev desc;

-- month with highest cogs --
select month_name, sum(cogs) as month_cogs
from walmart_sales
group by month_name
order by month_cogs desc;

-- product with  highest cogs --
select product_line, sum(cogs)
from walmart_sales
group by product_line
order by sum(cogs) desc;

-- product line with highest revenue --
select product_line, sum(revenue) as rev_by_pl
from walmart_sales
group by product_line
order by rev_by_pl desc;

-- product line with highest gross profit --
select product_line, sum(gross_profit) as profit
from walmart_sales
group by product_line
order by profit desc;

-- city with largest revenue --
select city, branch, sum(revenue) as rev_by_city
from walmart_sales
group by city, branch
order by rev_by_city desc;

-- product line with highest revenue per city --
select city, product_line, sum(revenue) as sum_rev
from walmart_sales
group by city, product_line
order by city, sum_rev desc;

-- product line with highest tax --
select product_line, avg(tax) as avg_tax
from walmart_sales
group by product_line
order by avg_tax desc;


-- branch with higher than avg sales(qty sold) --
select branch, sum(quantity) as qty
from walmart_sales 
group by branch
having sum(quantity) > (select avg(quantity) from walmart_sales);



-- add column showing good if above avg sales and bad if below avg sales wrt product line --
select product_line, quantity, 
(case 
	when 'quantity' > (select avg(quantity) from walmart_sales) then 'Good'
    else 'Bad'
    end) as total_sales
from walmart_sales
;

select avg(quantity) from walmart_sales;

alter table walmart_sales
add column sales varchar (10);

update walmart_sales
set sales = 
(case 
	when quantity > 5.4995 then 'Good'
    else 'Bad' 
    end);
 
-- which branch sold more than avg products --
select branch, avg(quantity)
from walmart_sales
group by branch
having avg(quantity) > 5.4995
;

-- most common product line by gender --
select product_line, gender, count(gender)
from walmart_sales
group by product_line, gender
order by count(gender) desc;

-- avg rating of each product line --
select product_line, avg(rating)
from walmart_sales
group by product_line;

-- no of sales in each time of the day per weekday --
select day_name, time_of_day, count(*)
from walmart_sales
group by day_name, time_of_day
order by count(*) desc;

-- which customer type brings most revenue --
select customer_type, sum(revenue)
from walmart_sales
group by customer_type;

-- which city has largest tax % --
select city, avg(tax)
from walmart_sales
group by city
order by avg(tax) desc;

-- which customer type pays most in tax --
select customer_type, avg(tax)
from walmart_sales
group by customer_type
order by avg(tax) desc;

-- most common sutomer type --
select customer_type, count(customer_type) as cnt_ct
from walmart_sales
group by customer_type
order by cnt_ct desc;

-- which ct buys most --
select customer_type, sum(quantity)
from walmart_sales
group by customer_type
order by sum(quantity) desc;

-- gender of most customers --
select gender, count(gender) as cnt_gen
from walmart_sales
group by gender 
order by cnt_gen desc;

-- gender distribution per branch --
select branch, gender, count(gender) as cnt_gen
from walmart_sales
group by branch, gender
order by branch;

-- Which time of the day do customers give most ratings --
select time_of_day, count(rating) as cnt_rat
from walmart_sales
group by time_of_day
order by cnt_rat desc;

-- Which time of the day do customers give most ratings per branch --
select branch, time_of_day, count(rating) as cnt_rat
from walmart_sales
group by branch, time_of_day
order by branch, cnt_rat desc;

-- Which day of the week has the best avg ratings --
select day_name, avg(rating) as avg_rat
from walmart_sales
group by day_name
order by avg_rat desc;

-- which day of the week has the best avg ratings per branch --
select branch, day_name, avg(rating) as avg_rat
from walmart_sales
group by branch, day_name
order by branch, avg_rat desc;

-- end -- 






