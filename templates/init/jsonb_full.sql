\set id random(1, {{ recordcount }})

select data from test_jsonb where id = :id;
