with Q1 as (
	select prod, 
		   cust, 
		   cast(avg(quant) as decimal(8,2)) avg_q, 
		   sum(quant) total_q, count(prod) count_q
	from sales
	group by cust, prod
	order by cust, prod
),
nj as 
(
	select al.prod, 
		   al.cust, 
		   cast(avg(s.quant) as decimal(8,2)) nj_avg
	from Q1 al, sales s
	where state like 'NJ' and 
			al.prod = s.prod and 
				al.cust = s.cust
	group by al.cust, al.prod
), 
ny as (
	select al.prod, 
		   al.cust, 
		   cast(avg(s.quant) as decimal(8,2)) ny_avg
	from Q1 al, sales s
	where state like 'NY' and 
			al.prod = s.prod and 
				al.cust = s.cust
	group by al.cust, al.prod
), 
pa as (
	select al.prod, 
		   al.cust, 
		   cast(avg(s.quant) as decimal(8,2)) pa_avg
	from Q1 al, sales s
	where state like 'PA' and 
			al.prod = s.prod and 
				al.cust = s.cust
	group by al.cust, al.prod
), 
ct as (
	select al.prod, 
		   al.cust, 
		   cast(avg(s.quant) as decimal(8,2)) ct_avg
	from Q1 al, sales s
	where state like 'CT' and 
			al.prod = s.prod and 
				al.cust = s.cust
	group by al.cust, al.prod
)
select al.prod, 
	   al.cust, 
	   ct.ct_avg, 
	   nj.nj_avg, 
	   ny.ny_avg, 
	   pa.pa_avg, 
	   al.avg_q, 
	   al.total_q, 
	   al.count_q
from Q1 al
left join nj on al.cust = nj.cust 
			and al.prod = nj.prod 
left join ny on al.cust = ny.cust 
			and al.prod = ny.prod 
left join pa on al.cust = pa.cust 
			and al.prod = pa.prod 
left join ct on al.cust = ct.cust 
			and al.prod = ct.prod 