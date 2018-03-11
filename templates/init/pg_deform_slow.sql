create table test_deform_slow (
    id integer primary key,
    data jsonb,
    data1 integer not null,
    data2 integer not null,
    data3 integer not null,
    data4 integer not null,
    data5 integer not null,
    data6 integer not null,
    data7 integer not null,
    data8 integer not null,
    data9 integer not null
);

insert into test_deform_slow
select s.id, '{"aaa": 1}', 1, 2, 3, 4, 5, 6, 7, 8, 9
from generate_series(1, {{ recordcount }}) as s(id);

vacuum analyze;

create extension pg_stat_statements
