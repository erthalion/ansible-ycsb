\set id random(1, {{ recordcount }})

select data[1] from array_test where id = :id;
select data[38] from array_test where id = :id;

select * from array_test where id = :id;

update array_test set data[1] = 'test' where id = :id;
update array_test set data[38] = 'test' where id = :id;
