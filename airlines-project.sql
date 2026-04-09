-- -------------------------------------------------------------------------------Project-2-----------------------------------------------------------------------------------------------------------------------------

create database Airlines;
use Airlines;

select * from `maindata-airline`;

show tables;

-- 1.Date
select
str_to_date(concat(year,'-',month,'-',day),'%Y-%m-%d') As full_date
from `maindata-airline`;

-- 2.Year & Year-Month
select 
year(full_date) as year
from `maindata-airline`;

select
date_format(full_date, '%Y-%m') as YearMonth
from `maindata-airline`;

-- 3. Monthname

select
month(full_date) as month_no,
monthname(full_date) as month_fullname
from `maindata-airline`;

-- 4. Weekdayname

select
weekday(full_date) + 1 as weekday_no,
dayname(full_date) as weekday_name
from `maindata-airline`;

-- 5. Financial month

select
case
when month(full_date) >=4 then month(full_date) -3
else month(full_date) +9
end as financial_month
from `maindata-airline`;

-- 6. FinancialQuarter

select
case 
when month(full_date) between 4 and 6 then 'FQ1'
when month(full_date) between 7 and 9 then 'FQ2'
when month(full_date) between 10 and 12 then 'FQ3'
else 'FQ4'
end as financial_quarter
from `maindata-airline`;

-- 7. Load factor

select
(sum(`transported passengers`) * 100.0 / sum(`available seats`)) as load_factor
from `maindata-airline`;

-- 8. load factor by year 

select year(full_date) as "Year", sum(`Transported Passengers`) as "Passengers", sum(`Available Seats`) as "Seats",
	concat(round((sum(`Transported Passengers`) / sum(`Available Seats`) *100),2),"%") as "Load factor %"
from `maindata-airline`
group by 1;

-- 9. Load factor by month

select month(full_date) as "Month", sum(`Transported Passengers`) as "Passengers", sum(`Available Seats`) as "Seats",
	concat(round((sum(`Transported Passengers`) / sum(`Available Seats`) *100),2),"%") as "Load factor %"
from `maindata-airline`
group by 1
order by 1;

-- 10. Load factor by Quarter

select concat("Q", quarter(full_date)) as "Quarter", sum(`Transported Passengers`) as "Passengers", sum(`Available Seats`) as "Seats",
	concat(round((sum(`Transported Passengers`) / sum(`Available Seats`) *100),2),"%") as "Load factor %"
from `maindata-airline`
group by 1
order by 1;

-- 11. Carrier name wise load factor

select
`carrier name`,
(sum(`transported passengers`) * 100.0 / sum(`available seats`)) as load_factor
from `maindata-airline`
group by `carrier name`
order by load_factor desc;

-- 12. Carrier name by transported passengers

select
`carrier name`,
sum(`transported passengers`) as total_passengers
from `maindata-airline`
group by `carrier name`
order by total_passengers desc
limit 10;

-- 13. Load factor by daytype

SELECT
    CASE
        WHEN DAYOFWEEK(full_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROUND(
        SUM(`transported passengers`) * 100.0 /
        (SELECT SUM(`transported passengers`) FROM `maindata-airline`),
        2
    ) AS passenger_share_pct
FROM `maindata-airline`
GROUP BY day_type;
 
-- 14. Load factor by distance group

SELECT
    CASE
        WHEN distance <= 500 THEN 'Short Haul'
        WHEN distance BETWEEN 501 AND 1500 THEN 'Medium Haul'
        WHEN distance BETWEEN 1501 AND 3000 THEN 'Long Haul'
        ELSE 'Ultra Long Haul'
    END AS distance_group,
    COUNT(*) AS flights,
    ROUND(
        SUM(`transported passengers`) * 100.0 / SUM(`available seats`),
        2
    ) AS load_factor
FROM `maindata-airline`
GROUP BY distance_group;

-- 15. Top Routes by No.of Flights(from - city)

SELECT
    CONCAT(`from - to city`) AS route,
    COUNT(*) AS no_of_flights
FROM `maindata-airline`
GROUP BY `from - to city`
ORDER BY no_of_flights DESC
LIMIT 10;









