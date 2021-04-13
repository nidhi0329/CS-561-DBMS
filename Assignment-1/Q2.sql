with jan_min as
(
	select cust, 
		   prod, 
		   min(quant) min_jan
 	from sales s
 	where year > 1999 and month = '1'
 	group by cust, prod
),
jan as 
( 
	select j.cust, 
		   j.prod, 
		   j.min_jan, s.day jan_day, s.month jan_month, s.year jan_year
 	from jan_min j, sales s
 	where j.cust = s.cust and 
		  j.prod = s.prod and 
		  j.min_jan = s.quant
),
feb_max as
( 
	select cust, 
		   prod, 
		   max(quant) max_feb
 	from sales s
 	where month = '2'
 	group by cust,prod
),
feb as
(
	select f.cust, 
		   f.prod, 
	       f.max_feb, 
	       s.day feb_day, s.month feb_month, s.year feb_year
 	from sales s, feb_max f
 	where f.cust = s.cust and 
		  f.prod = s.prod and 
		  f.max_feb = s.quant
),
mar_max as
( 
	select cust, prod, max(quant) max_mar
 	from sales s
 	where month = '3'
 	group by cust, prod
 ),
 mar as
 ( 
	 select ma.cust, 
	 		ma.prod, 
	 		ma.max_mar, 
	 		s.day mar_day, s.month mar_month, s.year mar_year
  	 from sales s, mar_max ma
     where ma.cust = s.cust and 
	 	   ma.prod = s.prod and 
	 	   ma.max_mar = s.quant
 )
 select cust,
 		prod,
		jan.min_jan, jan.jan_month, jan.jan_day, jan.jan_year,
  		feb.max_feb, feb.feb_month, feb.feb_day, feb.feb_year,
		mar.max_mar, mar.mar_month,mar.mar_day, mar.mar_year
 from (jan full outer join feb using (cust,prod)) 
 		   full outer join mar using(cust,prod)