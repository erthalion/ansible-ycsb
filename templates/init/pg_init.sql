{% if json_type is defined %}
create table usertable(data json);
{% else %}
create table usertable(data jsonb);
{% endif %}

{% if field_index is defined and nested is defined %}
create index usertable_data_idx on usertable ((data->>{% for i in range(9, 0, -1) %}'YCSB_KEY{{i}}'->>{% endfor %}'YCSB_KEY'));
{% elif field_index is defined %}
create index usertable_data_idx on usertable ((data->>'YCSB_KEY'));
{% else %}
create index usertable_data_idx on usertable using gin(data jsonb_path_ops);
{% endif %}

alter table usertable set (autovacuum_vacuum_scale_factor = 0.0);
alter table usertable set (autovacuum_vacuum_threshold = 10000);
alter table usertable set (autovacuum_analyze_scale_factor = 0.0);
alter table usertable set (autovacuum_analyze_threshold = 10000);

{% if sql_view is defined %}
create type ycsb_row as (
	YCSB_KEY VARCHAR(255) PRIMARY KEY,
	FIELD0 TEXT, FIELD1 TEXT,
	FIELD2 TEXT, FIELD3 TEXT,
	FIELD4 TEXT, FIELD5 TEXT,
	FIELD6 TEXT, FIELD7 TEXT,
	FIELD8 TEXT, FIELD9 TEXT
);

create view usertable_view as
    select r.*
    from usertable,
         jsonb_populate_record(NULL::ycsb_row, data) r;
{% endif %}
