create table logs_table(
	log_id serial primary key,
	ip_address text,
	time_stamp timestamptz,
	http_method varchar(50),
	requested_url text,
	protocol varchar(50),
	status integer,
	size integer
);

copy logs_table(ip_address, time_stamp, http_method,requested_url,protocol,status,size)
from 'C:/Datasets/user_logs/access_logs.csv'
with (format csv , Header true, delimiter ',');

-- How many total requests were received?
select 
count(*) as total_request
from logs_table;

-- How many unique visitors (IP addresses) accessed the website?
select 
ip_address,
count(*) as total_uniqvisitors
from logs_table
group by ip_address;

-- Which pages were visited the most?
select 
requested_url,
count(*) as most_visited
from logs_table
group by requested_url 
order by most_visited desc 
limit 10;

-- What are the top 10 IP addresses by request count?
select 
ip_address,
count(*) as most_visited
from logs_table
group by ip_address
order by most_visited desc 
limit 10;

-- How many requests resulted in each HTTP status code (200, 404, 500, etc.)?
select 
status,
count(*)
from logs_table
group by status;

-- Which day had the highest traffic?
select 
time_stamp :: Date as d_ate,
count(*) as traffic
from logs_table
group by d_ate
order by traffic desc;

-- Which hours of the day have the highest traffic?
select 
time_stamp :: time as day_hour,
count(*) as traffic
from logs_table
group by day_hour
order by traffic desc;

-- Which pages have the highest percentage of 404 errors?
select
requested_url,
count(case when status =304 then 1 end) as not_found,
round((count(case when status =304 then 1 end)/count(*) )*100 ,2) as percent_not_found
from logs_table
group by requested_url
having count(case when status =304 then 1 end) >0
order by percent_not_found desc;

-- What are the top file types requested (.html, .jpg, .css, etc.)?
select 
case
	when requested_url ~ '\.html?$' then 'HTML'
	when requested_url ~ '\.gif$' then 'GIF Image'
	when requested_url ~ '\.jpe?g$' then 'JPEG Image'
	when requested_url ~ '\.png$' then 'PNG Image'
	when requested_url ~ '\.css$' then 'CSS'
	when requested_url ~ '\.js$' then 'JavaScript'
	when requested_url ~ '\.pdf$' then 'PDF'
	when requested_url ~ '\.txt$' then 'Text File'
	else 'other'
End as file_type ,
count(*) as total_requests
from logs_table
group by file_type
order by total_requests desc;

-- Which IP addresses generated the most failed requests?
select
ip_address,
count( case when status  between 400 and 599 then 1 end) as no_error
from logs_table
group by ip_address
order by no_error desc
limit 5;

-- Which URLs consume the most bandwidth?
select 
ip_address,
sum(size) as bandwidht_consume
from logs_table
group by ip_address
order by sum(size) desc
limit 10;

-- What is the average response size per page?
select 
requested_url,
round(avg(size),2) as avg_size
from logs_table
group by requested_url
order by round(avg(size),2) desc
limit 10;

-- Which pages are rarely visited?
select 
requested_url,
count(*) as total_num_visitor
from logs_table
group by requested_url
order by total_num_visitor
limit 10;

-- Which users visited the greatest number of unique pages?
select 
ip_address,
count(distinct requested_url) as unique_pages_visit
from logs_table
group by ip_address
order by unique_pages_visit desc 
limit 10;

-- Rank the top 10 pages by traffic using window function
with page_traffic as (
	select 
	requested_url,
	count(*) as most_visitor
	from logs_table
	group by requested_url
	
)
select 
requested_url,
most_visitor,
rank() over(order by most_visitor desc) as top_pages_by_traffic
from page_traffic
limit 10;

with busy_day_hours as (
	select 
	time_stamp::date as day_date,
	Extract(Hour from time_stamp) as day_hours,
	count(requested_url) as num_of_request
	from logs_table
	group by time_stamp::date, Extract(Hour from time_stamp)
)
select
day_date,
day_hours,
num_of_request,
dense_rank() over(order by num_of_request) as busy_hours
from busy_day_hours
limit 5;

-- Calculate a 7-day moving average of website traffic.
with traffic as (
	select 
	time_stamp::date as day_date,
	count(requested_url) as num_of_request
	from logs_table
	group by time_stamp::date
)
select
day_date,
num_of_request,
round(avg(num_of_request) over(order by day_date 
rows between 6 preceding and current row) 
,2) as moving_avg
from traffic

-- Find pages whose traffic increased by more than 50% compared to the previous day using LAG().
with day_date_traffic as (
	select
	time_stamp::date as day_date,
	requested_url,
	count(*) as num_request
	from logs_table
	group by day_date, requested_url
), traffic_comparison as (
	select
	day_date,
	requested_url,
	num_request,
	lag(num_request) over(partition by requested_url order by day_date) as prev_day_request
	from day_date_traffic
)
select
day_date,
requested_url,
num_request,
prev_day_request,
((num_request-prev_day_request)/prev_day_request)*100 as percentage_increase
from traffic_comparison
WHERE prev_day_request IS NOT NULL
  AND num_request > prev_day_request*1.5
ORDER BY percentage_increase DESC;


-- Compare weekday versus weekend traffic.
SELECT 
    CASE 
        WHEN EXTRACT(ISODOW FROM time_stamp) IN (6, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
	count(*) as traffic
FROM logs_table
group by day_type;