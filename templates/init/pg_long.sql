\set id random(1, {{ recordcount }})

select * from (select * from test_short_long limit 100000) q
order by time;
