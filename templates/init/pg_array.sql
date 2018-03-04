create table array_test (id integer primary key, data text[]);

insert into array_test
select s.id, ARRAY[
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text,
    md5(random()::text)::text
]
from generate_series(1, {{ recordcount }}) as s(id);

vacuum analyze;

-- alter table array_test set (autovacuum_vacuum_scale_factor = 0.0);
-- alter table array_test set (autovacuum_vacuum_threshold = {{ recordcount / 10 }});
-- alter table array_test set (autovacuum_analyze_scale_factor = 0.0);
-- alter table array_test set (autovacuum_analyze_threshold = {{ recordcount / 10 }});
