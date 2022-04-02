

--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

select *
into combined_table
from
(
select mf.Cust_id,mf.Discount,mf.Order_Quantity,mf.Product_Base_Margin,mf.Sales,
sd.Ship_id,sd.Ship_Date,sd.Ship_Mode,
cd.Customer_Name,cd.Customer_Segment,cd.Province,cd.Region,
od.Ord_id,od.Order_Date,od.Order_Priority,
pd.Prod_id,pd.Product_Category,pd.Product_Sub_Category
from market_fact mf, cust_dimen cd, prod_dimen pd,shipping_dimen sd, orders_dimen od
where mf.Ord_id=od.Ord_id and mf.Cust_id=cd.Cust_id and mf.Ship_id=sd.Ship_id and mf.Prod_id=pd.Prod_id) A;

select * from combined_table

SELECT *
FROM combined_view;

--2. Find the top 3 customers who have the maximum count of orders.

select top 3 Cust_id, count(ord_id) total_order
from combined_table
group by Cust_id
order by 2 desc

select Cust_id,Customer_Name, Order_Date,Order_Quantity 
from combined_table

---3.Create a new column at combined_table as DaysTakenForDelivery that contains 
--the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

-- DATEIFF fonksiyonu ile gün farklarini bulalim ve alter update ile sutun olarak kalici ekleyelim:

select Order_Date,Ship_Date, DATEDIFF(Day,Order_Date,Ship_Date) DaysTakenForDelivery
from combined_table

ALTER TABLE combined_table
ADD DaysTakenForDelivery2 INT;

UPDATE combined_table
SET DaysTakenForDelivery2 = DATEDIFF(Day, Order_Date, Ship_Date)

select * from combined_table

--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"
select top 1 Cust_id,Customer_Name,max(DATEDIFF(Day, Order_Date, Ship_Date)) over()
from combined_table

--5. Count the total number of unique customers in January and how many of them came back every month 
--over the entire year in 2011
--You can use such date functions and subqueries
select month(order_date) [Month], count(distinct cust_id) monthly_num_of_cust
from combined_table
where cust_id in(
			select distinct cust_id num_of_cust
			from combined_table
			where Month(Order_Date)=1 and year(Order_Date)=2011) and year(Order_Date)=2011
group by month(order_date)

SELECT Month(Order_date) [month], count(distinct Cust_id) month_num_of_cus
				
FROM combined_table
WHERE cust_id IN (
					SELECT DISTINCT (Cust_id) 
					FROM combined_table
					WHERE MONTH(Order_Date) = 1
					AND YEAR(Order_Date) = 2011
				 )
AND YEAR(Order_Date) = 2011
group by  Month(Order_date)


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing,
--in ascending order by Customer ID
--Use "MIN" with Window Functions

with T1 as 
(
SELECT *
from(select cust_id,order_date,min(order_date) OVER (PARTITION BY cust_id ORDER BY order_date) [min],
DENSE_RANK () OVER (PARTITION BY cust_id ORDER BY order_date) DENSE_RANK_NUM

FROM	combined_table)  t
)

select distinct cust_id, DATEDIFF(D,[min],order_date) diff_third_first_ord
from T1
where DENSE_RANK_NUM=3
order by diff_third_first_ord

 ---or

 select distinct cust_id, DATEDIFF(D,[min],order_date) diff_third_first_ord
 from (
	   select cust_id,order_date,min(order_date) OVER (PARTITION BY cust_id ORDER BY order_date) [min],
		DENSE_RANK () OVER (PARTITION BY cust_id ORDER BY order_date) DENSE_RANK_NUM

		FROM	combined_table) t
where DENSE_RANK_NUM=3
order by diff_third_first_ord

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions
with T1 as
(
select  *
from combined_table
where Cust_id in(
select Cust_id
from combined_table
where Prod_id='prod_11'
intersect
select Cust_id
from combined_table
where Prod_id='prod_14')
)
select Cust_id, COUNT(prod_id) Total_order,
SUM(CASE WHEN prod_id = 'Prod_11' or prod_id = 'Prod_14' THEN 1 ELSE 0 END) Selected_order,
100*sum(case when prod_id = 'Prod_11' or prod_id = 'Prod_14' THEN 1 ELSE 0 END)/count(prod_id) Rate
from T1
group by Cust_id

----or
select Cust_id, COUNT(prod_id) Total_order,
SUM(CASE WHEN prod_id = 'Prod_11' or prod_id = 'Prod_14' THEN 1 ELSE 0 END) Selected_order,
100*sum(case when prod_id = 'Prod_11' or prod_id = 'Prod_14' THEN 1 ELSE 0 END)/count(prod_id) Rate
from  (select  *
	   from combined_table
		where Cust_id in(
				select Cust_id
				from combined_table
				where Prod_id='prod_11'
				intersect
				select Cust_id
				from combined_table
				where Prod_id='prod_14')) as t

group by Cust_id

----order quantity ye gore yapalim
with T1 as 
(
select Cust_id, sum(case when Prod_id='Prod_11' then Order_Quantity else 0 end) prod11,
		  sum(case when Prod_id='Prod_14' then Order_Quantity else 0 end) prod14,
		  sum(Order_Quantity) TOTAL_PROD
		
from  (select  *
	   from combined_table
		where Cust_id in(
				select Cust_id
				from combined_table
				where Prod_id='prod_11'
				intersect
				select Cust_id
				from combined_table
				where Prod_id='prod_14')) as t
group by Cust_id
)
select Cust_id, prod11,  prod14, TOTAL_PROD,
		CAST (1.0*prod11/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P11,
		CAST (1.0*prod14/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P14
FROM T1


--CUSTOMER RETENTION ANALYSIS


--1. Create a view that keeps visit logs of customers on a monthly basis. 
--(For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW customer_logs AS

SELECT cust_id,
		YEAR (order_date) [YEAR],
		MONTH(order_date) [MONTH]
FROM combined_table


SELECT *
FROM customer_logs
ORDER BY 1,2,3


--2. Create a view that keeps the number of monthly visits by users. 
--(Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.

create view logs_of_basis As
select customer_name,Cust_id,Month(order_date) [month],Year(Order_date) [year],count(ord_id) order_number
from combined_table
group by customer_name,Cust_id,Month(order_date),Year(Order_date)

select *
from logs_of_basis
order by 3,4

--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
create view next_visit1 as
select *,lead(current_month) over(partition by cust_id order by current_month) next_order
from(select *,DENSE_RANK() OVER (ORDER BY [YEAR] , [MONTH]) current_month
		from logs_of_basis) as k

select *
from next_visit1

---4.CREATE VIEW : Calculate the monthly time gap between two consecutive visits by each customer.
create view timegap as
select *, next_order-current_month timegap
from next_visit1

select *
from timegap

--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--o	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--o	Labeled as regular if the customer has made a purchase every month.
--Etc.
select *, case
					when avg_gap<=6 then 'Loyal' 
					when avg_gap between 6 and 10 then 'regular'
					when avg_gap > 10 then 'Irregular'
					when avg_gap is null then 'Churn'
					else 'Unknown' end
from(
select Cust_id, Avg(timegap) avg_gap
from timegap
group by Cust_id) t

--Find month-by-month customer retention rate  since the start of the business.
--Find the number of customers retained month-wise. (You can use time gaps)
--- bir onceki ayda gelen musterilerin kac tanesi diger ay da geldi. Timegap i 1 aldik 2 ay ust uste alisverisi gormek icin.


select  DISTINCT [YEAR],
		[MONTH], next_order as retention_month,count(cust_id) over(partition by next_order) RETENTION_SUM_MONTHLY
from timegap
where timegap=1

--2. Calculate the month-wise retention rate.

--Basic formula: 	
--Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth 
--							/ Total Number of Customers in The Previous Month
---bir onceki ayda gelip next ayda da gelen musterilerin bir onceki ayda gelen toplama oranini bul
drop view next_num_of_cust
create view next_num_of_cust as
select  DISTINCT [YEAR],
		[MONTH], next_order as retention_month,count(cust_id) over(partition by next_order) RETENTION_SUM_MONTHLY
from timegap
where timegap=1 and current_month>1

select *
from next_num_of_cust

create view current_num_of_cust3 as
select DISTINCT [YEAR],
		[MONTH], current_month,count(cust_id) over(partition by current_month) retention_month_wise
from timegap

select *
from current_num_of_cust3

---- left join ile orani gerceklestirelim

select DISTINCT 
		A.[YEAR], B.RETENTION_SUM_MONTHLY, 
		A.[MONTH],A.current_month,B.retention_month,A.retention_month_wise, 1.0*B.RETENTION_SUM_MONTHLY/A.retention_month_wise Rate
from current_num_of_cust3 A left join next_num_of_cust B 
on A.current_month+1=B.retention_month
order by 3

