-- import table from files 

SELECT * 
FROM sales_data.retail_sales_dataset;

-- In other not to temper with raw data a stagging table was created to carry out cleaning and exploratory functions

create table sales_staging
like sales_data.retail_sales_dataset;

-- Insert into the new table the data entries from the original table

insert into sales_staging
select *
from sales_data.retail_sales_dataset;


SELECT * 
FROM sales_data.sales_staging;

 -- checking for duplicates by using row_number which asigns a number to a row
 
		select*, row_number() over 
		(partition by 
       `Transaction ID`, 
            `Date`, 
            `Customer ID`,
            `Gender`,
            `Age`,
            `Product Category`,
            `Quantity`,
            `Price per Unit`,
            `Total Amount`
       ) as row_num
       from sales_data.sales_staging;
       
       -- Used a common table expression to check if there were duplicates
       
       with duplicate_data as
       (
       select*, row_number() over 
		(partition by 
       `Transaction ID`, 
            `Date`, 
            `Customer ID`,
            `Gender`,
            `Age`,
            `Product Category`,
            `Quantity`,
            `Price per Unit`,
            `Total Amount`
       ) as row_num
       from sales_data.sales_staging
       )
       select*
       from duplicate_data
       where row_num >1;
       
     -- there were no dupplicates in this data set but if there was i would use a copy statement to create another table and adding an extra column for the row numbers so that they can be deleted



CREATE TABLE `sales_staging2` (
  `Transaction ID` int DEFAULT NULL,
  `Date` text,
  `Customer ID` text,
  `Gender` text,
  `Age` int DEFAULT NULL,
  `Product Category` text,
  `Quantity` int DEFAULT NULL,
  `Price per Unit` int DEFAULT NULL,
  `Total Amount` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from sales_staging2;

insert into sales_staging2
select*,  ROW_NUMBER() OVER (
        PARTITION BY 
            `Transaction ID`, 
            `Date`, 
            `Customer ID`, 
            `Gender`, 
            `Age`, 
            `Product Category`, 
            `Quantity`, 
            `Price per Unit`, 
            `Total Amount`
    ) AS row_num
    from sales_staging;
    
    select *
from sales_staging2;

-- noticed that the date was in text format , it was then changed to a date formt 
SELECT `Date`, 
       STR_TO_DATE(`Date`, '%Y-%m-%d') AS `Dates`
FROM sales_staging2;

update  sales_staging2
set `Date` = STR_TO_DATE(`Date`, '%Y-%m-%d')  ;

Alter table sales_staging2
modify column `Date` date;
 
 -- Checked each columns for abnormalies, nulls , blanks
 
select distinct `product category`
from sales_staging2 ;
 
 
select* 
from sales_staging2
where `product category` is null;

select* 
from sales_staging2
where Quantity is null;

select* 
from sales_staging2
where `Transaction ID` is null ;

select* 
from sales_staging2
where `product category` = ' ';

select* 
from sales_staging2
where `age` is null;

-- Exploration
-- Found the company's key primary indicators total_transactions, total_units_sold, total_revenue, earliest_date, latest_date
SELECT 
    COUNT(`Transaction ID`) AS total_transactions,
    SUM(`Quantity`) AS total_units_sold,
    SUM(`Total Amount`) AS total_revenue,
    MIN(`Date`) AS earliest_date,
    MAX(`Date`) AS latest_date
FROM sales_data.sales_staging2;

-- Got  revenue amount from each product that was bought

select  `product category` , `total amount` 
from sales_staging2
order by 2 desc
;
-- The sum total of revenue generated from the three products
select  `product category` ,  sum(`total amount`) as total_revenue
from sales_staging2
group by `product category`
order by 2 desc
;
-- The sum total of quantity of the three products that was bought

select  `product category` ,  sum(`Quantity`) as total_quantity_sold
from sales_staging2
group by `product category`
order by 2 desc;

-- The  countof transactions generated from the three products
select  `product category` ,  count(`transaction id`) as total_transaction
from sales_staging2
group by `product category`
order by 2 desc;

SELECT 
    `Product Category`,
    COUNT(`Transaction ID`) AS transaction_count,
    SUM(`Quantity`) AS units_sold,
    SUM(`Total Amount`) AS total_revenue,
    ROUND(AVG(`Price per Unit`), 2) AS avg_unit_price
FROM sales_data.sales_staging2
GROUP BY `Product Category`
ORDER BY total_revenue DESC;

-- MOnthly Sales trend
SELECT 
    SUBSTRING(`Date`, 1, 7) AS sales_month,
    SUM(`Total Amount`) AS monthly_revenue,
    COUNT(`Transaction ID`) AS monthly_transactions
FROM sales_data.sales_staging2 
GROUP BY sales_month
ORDER BY sales_month ASC;

-- Demographics: getting the number of products bought by customers by their genders
SELECT 
    `Gender`,
    `Product Category`,
    count(`Transaction ID`) AS total_bought
FROM sales_data.sales_staging2
GROUP BY `Gender`, `Product Category`
ORDER BY `Gender`;

-- Doing a monthly rolling sum of total revenue of the copany using a common table expression
select substr(`date`, 1,7) as `dates`, sum(`total amount`) as total_revenue
from sales_staging2
group by `dates`
order by 2 desc;

with month_rolling_total as 
(
select 
substr(`date`, 1,7) as `dates`, 
sum(`total amount`) as Monthly_revenue
from sales_staging2
group by `dates`
order by 2 desc
)
select *, 
sum(Monthly_revenue) over ( order by `dates`) as rolling_total
from month_rolling_total;

-- Ranking the revenue generated by each product

WITH category_revenue AS (
    SELECT 
        `Product Category`,
        SUM(`Total Amount`) AS total_category_revenue
    FROM sales_staging2
    GROUP BY `Product Category`
)
SELECT 
    `Product Category`,
    total_category_revenue,
    DENSE_RANK() OVER (ORDER BY total_category_revenue DESC) as category_rank
FROM category_revenue;







select *
from sales_staging2;

