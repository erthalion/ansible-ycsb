create table jsonb_test (id integer primary key, data jsonb);

insert into jsonb_test
select s.id, ('["' ||
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
from generate_series(1, {{ recordcount }}) as s(id);

vacuum analyze;

-- alter table jsonb_test set (autovacuum_vacuum_scale_factor = 0.0);
-- alter table jsonb_test set (autovacuum_vacuum_threshold = {{ recordcount / 10 }});
-- alter table jsonb_test set (autovacuum_analyze_scale_factor = 0.0);
-- alter table jsonb_test set (autovacuum_analyze_threshold = {{ recordcount / 10 }});
