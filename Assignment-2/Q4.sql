with query1 as (
select cust, prod, "month", sum(quant) as sum_qnt
from sales
	group by cust, prod, "month"
	order by cust, prod, "month"
), query2 as (
select cust, prod, sum(quant) as cust_prod_qnt
from sales
	group by cust, prod
	order by cust, prod
), query3 as (
select Q1.cust, Q1.prod, Q1."month", Q1.sum_qnt, sum(Q2.sum_qnt) as cummulative_sum
from query1 Q1
	left join query1 Q2 on Q1.cust = Q2.cust and Q1.prod = Q2.prod and Q1.month >= Q2.month
	group by Q1.cust, Q1.prod, Q1."month", Q1.sum_qnt
	order by Q1.cust, Q1.prod, Q1."month"
), query4 as (
select distinct Q1.cust, Q1.prod, Q1."month", Q1.sum_qnt, Q1.cummulative_sum,
	(case when Q1.cummulative_sum >= 0.75*Q2.cust_prod_qnt then Q1."month" else null end) as PURCHASED_75_BY_MONTH
from query3 Q1
	left join query2 Q2 on Q1.cust = Q2.cust and Q1.prod = Q2.prod
)
select cust as CUSTOMER, prod as PRODUCT, min(PURCHASED_75_BY_MONTH) as PURCHASED_75_BY_MONTH
from query4
	group by cust, prod
	order by cust, prod
;
