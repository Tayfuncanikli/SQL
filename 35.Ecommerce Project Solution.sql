/*1. Join all the tables and create a new table with all of the columns, called combined_table. 
(market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen) 
*/

SELECT *
INTO combined_table
FROM (

	SELECT cd.Cust_id, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment, 
			mf.Ord_id, mf.Prod_id, mf.Sales, mf.Discount, mf.Order_Quantity, mf.Product_Base_Margin,
			od.Order_Date, od.Order_Priority,
			pd.Product_Category, pd.Product_Sub_Category,
			sd.Ship_id, sd.Ship_Mode, sd.Ship_Date
	FROM market_fact mf
	INNER JOIN cust_dimen cd on cd.Cust_id=mf.Cust_id
	INNER JOIN orders_dimen od on od.Ord_id=mf.Ord_id
	INNER JOIN prod_dimen pd on pd.Prod_id=mf.Prod_id
	INNER JOIN shipping_dimen sd on sd.Ship_id=mf.Ship_id
	) A


	
	
SELECT * 
FROM combined_table
ORDER BY Ord_id

--2. Find the top 3 customers who have the maximum count of orders.

SELECT  TOP 3 Cust_id, Customer_Name, COUNT(DISTINCT Ord_id) AS COUNT_ORDER
FROM combined_table
GROUP BY Cust_id, Customer_Name
ORDER BY 3 DESC

--3. Create a new column at combined_table as DaysTakenForDelivery 
--that contains the date difference of Order_Date and Ship_Date.

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT

UPDATE combined_table
SET DaysTakenForDelivery=DATEDIFF(DAY,Order_Date,Ship_Date)

--4. Find the customer whose order took the maximum time to get delivered.

SELECT MAX(DaysTakenForDelivery)
FROM combined_table

SELECT TOP 1 Customer_name ,Ord_id, DaysTakenForDelivery
FROM combined_table
ORDER BY DaysTakenForDelivery DESC

--5. Count the total number of unique customers in January and how many of them 
--came back every month over the entire year in 2011

SELECT cust_id,COUNT( DISTINCT Cust_id) AS Unique_Customer
FROM combined_table
WHERE YEAR(Order_Date)= 2011
and MONTH (Order_Date)=01
group by Cust_id

SELECT MONTH(Order_date)  [Month],
		COUNT(DISTINCT Cust_id)  COUNT_CUST
FROM combined_table A
WHERE
EXISTS (
		SELECT Cust_id
		FROM combined_table B
		Where a.Cust_id=B.Cust_id
			AND YEAR(Order_Date)= 2011
			and MONTH (Order_Date)=01
		)
and YEAR(Order_Date)= 2011
group by MONTH(oRDER_DATE)

---or

SELECT MONTH(Order_date)  [Month],
		COUNT(DISTINCT Cust_id)  COUNT_CUST
FROM combined_table

where cust_id in (SELECT distinct cust_id
			FROM combined_table
			WHERE YEAR(Order_Date)= 2011
			and MONTH (Order_Date)=01
			) and YEAR(Order_Date)= 2011

group by MONTH(Order_date)

--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID

SELECT Cust_id, MIN(oRDER_DATE) first_purchase
FROM combined_table
GROUP BY cust_id



SELECT DISTINCT Cust_id,
		Order_date as ThirdPurchase,
		DENSE_DATE,
		first_purchase,
		DATEDIFF(DAY,first_purchase,ORDER_DATE) AS day_ELAPSED
FROM(
	SELECT	Cust_id,
		Order_Date,
		ord_id,
		MIN (Order_date) OVER (Partition BY Cust_id) first_purchase,
		DENSE_RANK() OVER (Partition BY Cust_id ORDER by Order_Date) DENSE_DATE 
	FROM combined_table
) A
WHERE dense_date =3


SELECT *
FROM combined_table
WHERE	Cust_id = 'Cust_1000'
ORDER BY order_date 


--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.


WITH T1 AS (
SELECT	cust_id,
		SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity else 0 end ) as P11,
		SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity else 0 end ) as P14,
		SUM(order_quantity) TOTAL_Prod
FROM combined_table
GROUP BY cust_id
HAVING SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity else 0 end ) >=1  AND
		SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity else 0 end ) >=1
)

SELECT
		cust_id,
		P11,
		P14,
		TOTAL_Prod,
		cast (1.0*p11/TOTAL_Prod as numeric(3,2)) AS RATIOP11,
		cast (1.0*p14/TOTAL_Prod as numeric(3,2)) AS RATIOP14
FROM T1

---or

with T1 as (select distinct Cust_id,SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity else 0 end ) as P11,
		SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity else 0 end ) as P14,
		SUM(order_quantity) TOTAL_Prod
from combined_table 
where cust_id in(
		select Cust_id
		from combined_table
		where Prod_id='Prod_11'
		intersect
		select Cust_id
		from combined_table
		where Prod_id='Prod_14'  ) 
group by Cust_id
)
SELECT
		cust_id,
		P11,
		P14,
		TOTAL_Prod,
		cast (1.0*p11/TOTAL_Prod as numeric(3,2)) AS RATIOP11,
		cast (1.0*p14/TOTAL_Prod as numeric(3,2)) AS RATIOP14
FROM T1
order by cust_id

---- Customer Retention Analyse

--1.	Create a view that keeps visit logs of customers on a monthly basis. 
--(For each log, three field is kept: Cust_id, Year, Month)

CREATE VIEW CUSTOMER_LOGS AS
SELECT	Cust_id,
		YEAR(Order_date) [Year],
		MONTH(Order_date) [MOnth]
FROM combined_table

select *
from customer_logs
--ORDER BY 1,2,3

--2.Create a view that keeps the number of monthly visits by users. 
--(Separately for all months from the business beginning)

CREATE VIEW Number_of_visit AS
SELECT	Cust_id,
		[Year],
		[MOnth],
		count(*) total_visit
FROM CUSTOMER_LOGS 
group by Cust_id,
		[Year],
		[MOnth]

--3. CREATE A VIEW : For each visit of customers, create the next month of the visit as a separate column.
CREATE VIEW Next_visit AS
SELECT *,
		LEAD (Current_Month) OVER (PARTITION BY cust_id ORDER BY Current_Month) NEXT_VISIT_MONTH
FROM
	(SELECT	*,
			DENSE_RANK() over (ORDER BY [YEAR],[MONTH]) AS Current_Month
	FROM Number_of_visit
	--ORDER BY 1,2,3
	) A
select *
from Next_visit

--4.CREATE VIEW : Calculate the monthly time gap between two consecutive visits by each customer.
CREATE VIEW time_gaps AS 
SELECT *,
		NEXT_VISIT_MONTH-Current_Month AS TIME_GAP
FROM Next_visit

select *
from time_gaps 

--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--o	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--o	Labeled as regular if the customer has made a purchase every month.
--Etc.

SELECT
		Cust_id,
		AVG_TIME_GAP,
		CASE	
				WHEN AVG_TIME_GAP=1 then 'RETAINED'
				WHEN AVG_TIME_GAP>1 then 'IRREGULAR'
				WHEN AVG_TIME_GAP IS NULL then 'CHURNED'
				ELSE 'UNKNOWN'
		END
FROM (

	SELECT Cust_id,
			AVG(TIME_GAP) AVG_TIME_GAP
	FROM time_gaps
	GROUP BY Cust_id
	) A
ORDER BY 2 DESC

--- or
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

select DISTINCT [YEAR],
		[MONTH],
		NEXT_VISIT_MONTH as retention_month,
		count (cust_id) over (PARTITION BY NEXT_VISIT_MONTH) RETENTION_SUM_MONTHLY
from time_gaps
where TIME_GAP=1


--2. Calculate the month-wise retention rate.

--Basic formula: 	
--Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth 
--							/ Total Number of Customers in The Previous Month

--DROP VIEW CURRENT_NUM_OF_CUST
CREATE VIEW CURRENT_NUM_OF_CUST AS
SELECT DISTINCT
		Cust_id,
		[YEAR],
		[MONTH],
		CURRENT_MONTH,
		COUNT( Cust_id) OVER (PARTITION BY CURRENT_MONTH ) AS CURR_CUST
FROM time_gaps

select *
from CURRENT_NUM_OF_CUST


--DROP VIEW NEXT_NUM_OF_CUST
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
