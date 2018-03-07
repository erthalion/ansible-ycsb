\set id random(1, {{ recordcount }})

select data->0 from jsonb_test where id = :id;
select data->38 from jsonb_test where id = :id;

select * from jsonb_test where id = :id;

update jsonb_test set data = jsonb_set(data, '{0}', '"test"') where id = :id;
update jsonb_test set data = jsonb_set(data, '{38}', '"test"') where id = :id;
