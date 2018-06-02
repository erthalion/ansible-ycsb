create table test_short_long(
    id integer,
    name text,
    time timestamp with time zone,
    data jsonb
);

insert into short_long
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
from generate_series(1, {{ recordcount }}) as s(id);

vacuum analyze;
