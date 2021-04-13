with Q1 AS 
(	
	select cust CUSTOMER, 
		   min(quant) MIN_Q, 
		   max(quant) MAX_Q, 
		   cast(avg(quant) as decimal(10,2)) AVG_Q 
	from sales 
	group by cust
),
Q2 AS
(
	select Q1.CUSTOMER, 
		   Q1.MIN_Q, 
		   s1.prod MIN_PROD, 
		   s1.day DAY_MIN, s1.month MONTH_MIN, s1.year YEAR_MIN, 
		   s1.state ST_MIN, 
		   Q1.MAX_Q, Q1.AVG_Q
	from Q1, sales S1
	where Q1.CUSTOMER = S1.cust and 
		  Q1.MIN_Q = S1.quant
)	
select Q2.CUSTOMER, 
	   Q2.MIN_Q, Q2.MIN_PROD, 
	   Q2.DAY_MIN min_day, Q2.MONTH_MIN min_month, Q2.YEAR_MIN min_year, 
	   Q2.ST_MIN,
	   
	   Q2.MAX_Q, 
	   s2.prod MAX_PROD,
	   s2.day max_day, s2.month max_month, s2.year max_year, 
	   s2.state ST_MAX, 
	   Q2.AVG_Q
	   from Q2, sales S2
	   where Q2.CUSTOMER = S2.cust and 
	   		 Q2.MAX_Q = S2.quant