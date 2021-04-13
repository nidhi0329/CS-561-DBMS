with Q1 as
(
    select month, 
		   prod , 
		   sum (quant) Total
	from sales
	group by month, prod
	order by month, sum(quant)
),
Q2 as 
(
	select month, 
		   max(Total) MOST_POP_TOTAL_Q, 
		   min(Total) LEAST_POP_TOTAL_Q
	from Q1
	group by month
)

select b.month, 
	   a1.prod MOST_POPULAR_PROD, 
	   b.MOST_POP_TOTAL_Q,
	   a2.prod LEAST_POPULAR_PROD, 
	   b.LEAST_POP_TOTAL_Q
from Q2 b, Q1 a1, Q1 a2
where (a1.month = b.month and a1.Total=b.MOST_POP_TOTAL_Q)  and 
	  (a2.month = b.month and a2.Total=b.LEAST_POP_TOTAL_Q)

