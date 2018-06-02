\set id random(1, {{ recordcount }})

select name from test_short_long where id = :id;
