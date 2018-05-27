set work_mem = 64;

insert into test_nvme
select s.id, 'name' || s.id, current_timestamp - (s.id || ' hour')::interval, ('["' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text || '", "' ||
    md5(random()::text)::text ||
'"]')::jsonb
from generate_series(1, 1) as s(id);

select * from (select * from test_nvme limit 10000) q order by time ;
