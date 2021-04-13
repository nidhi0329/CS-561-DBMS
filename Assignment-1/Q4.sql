with Q1 as
(
	select prod, 
		   month M, 
		   sum(quant) total
	from sales
	group by prod, M
	order by prod, M
),
Q2 as
(
	select Q1.prod, 
		   max(total) max_q, 
		   min(total) min_q
	from Q1
	group by Q1.prod
	order by Q1.prod
)
select b.prod PRODUCT, 
	   a1.M MOST_FAV_MO, 
	   a2.M LEAST_FAV_MO
from Q2 b, Q1 a1, Q1 a2
where (b.prod = a1.prod and b.max_q = a1.total) and 
	  (b.prod = a2.prod and b.min_q = a2.total)