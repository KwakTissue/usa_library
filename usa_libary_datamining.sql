with
visits_rate_usa as (
	select 
	p8.libname as libname,
	p8.city as city,
	p8.stabr as stabr,
	((p8.visits - p7.visits) / p7.visits::numeric) * 100 as visits_rate_2017_to_2018,
	((p7.visits - p6.visits) / p6.visits::numeric) * 100 as visits_rate_2016_to_2017,
	((p8.visits - p6.visits) / p6.visits::numeric) * 100 as visits_rate_total
	from pls_fy2018_libraries p8
	left outer join pls_fy2017_libraries p7 on p8.fscskey = p7.fscskey
	left outer join pls_fy2016_libraries p6 on p8.fscskey = p6.fscskey
	where p8.stataddr = '00' and p7.stataddr = '00' and p6.stataddr = '00' and 
	p8.visits > 0 and p7.visits > 0 and p6.visits > 0
)
, stabr_visits_rate as (
	select stabr, 
	avg(visits_rate_2016_to_2017) as avg_visits_rate_2016_to_2017,
	avg(visits_rate_2017_to_2018) as avg_visits_rate_2017_to_2018, 
	avg(visits_rate_total) as visits_rate_total
	from visits_rate_usa
	group by stabr
)
select *
from stabr_visits_rate
order by visits_rate_total