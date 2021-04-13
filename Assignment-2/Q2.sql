with q1 as
(
	select cust, prod, state, round(avg(quant),0) as quant 
	from sales 
	where month between 1 and 3 group by cust, prod, state
), 

q2 as 
(
	select cust, prod, state, round(avg(quant),0) as quant 
	from sales 
	where month between 4 and 6 group by cust, prod, state
),

q3 as 
(
	select cust, prod, state, round(avg(quant),0) as quant 
	from sales 
	where month between 7 and 9 group by cust, prod, state
), 

q4 as 
(
	select cust, prod, state, round(avg(quant),0) as quant 
	from sales 
	where month between 10 and 12 group by cust, prod, state
), 

base as
(
 select cust, prod, state 
 from sales 
 group by cust, prod, state
), 

t1 as 
( 
	select b.cust, b.prod, b.state, cast('1' as int) as q, cast(null as numeric) as before_avg, q2.quant as after_avg 
	from base as b left join q2 using(cust, prod, state)
), 

t2 as 
(
	select b.cust, b.prod, b.state, cast('2' as int) as q, q1.quant as before_avg, q3.quant as after_avg 
	from base as b left join q1 using(cust, prod, state) left join q3 using(cust, prod, state)
), 

t3 as 
(
	select b.cust, b.prod, b.state, cast('3' as int) as q, q2.quant as before_avg, q4.quant as after_avg 
	from base as b left join q2 using(cust, prod, state) left join q4 using(cust, prod, state)
), 

t4 as 
(
	select b.cust, b.prod, b.state, cast('4' as int) as q, q3.quant as before_avg, cast(null as numeric) as after_avg 
	from base as b left join q3 using(cust, prod, state)
),

t5 as
(
	select * from t1 union select * from t2 union select * from t3 union select * 
	from t4
)

select * 
from t5 
order by cust,prod,q, state