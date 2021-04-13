with sum_cnt_qnt1 as(
	select
		cust, prod, month, state,
		sum(quant) as sum_qnt,
		count(quant)as cnt_qnt
		--cast(avg(quant) as decimal(10,3)) as avg_qnt
	from sales
		group by cust, prod, month, state
		order by cust, prod, month, state
)
select
	Q1.cust, Q1.prod, Q1.month as mo, Q1."state",
	cast(Q1.sum_qnt/Q1.cnt_qnt as decimal(10,3)) as CUST_AVG,
	cast(sum(Q2.sum_qnt)/sum(Q2.cnt_qnt) as decimal(10,3))as OTHER_PROD_AVG,
	cast(sum(Q3.sum_qnt)/sum(Q3.cnt_qnt) as decimal(10,3))as OTHER_MO_AVG,
	cast(sum(Q4.sum_qnt)/sum(Q4.cnt_qnt) as decimal(10,3))as OTHER_STATE_AVG
	
from sum_cnt_qnt1 Q1
	left join sum_cnt_qnt1 Q2 on Q1.cust = Q2.cust and Q1.prod <> Q2.prod and Q1.state = Q2.state and Q1.month = Q2.month
	left join sum_cnt_qnt1 Q3 on Q1.cust = Q3.cust and Q1.prod = Q3.prod and Q1.state = Q3.state and Q1.month <> Q3.month
	left join sum_cnt_qnt1 Q4 on Q1.cust = Q4.cust and Q1.prod = Q4.prod and Q1.state <> Q4.state and Q1.month = Q4.month
	group by Q1.cust, Q1.prod, Q1.month, Q1."state", CUST_AVG
	order by Q1.cust, Q1.prod, Q1.month, Q1."state"
;