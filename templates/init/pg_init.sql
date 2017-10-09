{% if sql is not defined %}
    {% if json_type is defined %}
    create table if not exists usertable(data json);
    {% elif separate_id is defined %}
    create table if not exists usertable(ycsb_key text primary key, data jsonb);
    {% else %}
    create table if not exists usertable(data jsonb);
    {% endif %}
{% endif %}

{% if sql is defined %}
create table if not exists usertable (
	YCSB_KEY VARCHAR(255),
	FIELD0 TEXT, FIELD1 TEXT,
	FIELD2 TEXT, FIELD3 TEXT,
	FIELD4 TEXT, FIELD5 TEXT,
	FIELD6 TEXT, FIELD7 TEXT,
	FIELD8 TEXT, FIELD9 TEXT
);

{% if separate_id is not defined %}
create index if not exists usertable_ycsb_key_idx on usertable (YCSB_KEY);
{% endif %}

-- create view usertable_view as
    -- select r.*
    -- from usertable,
         -- jsonb_populate_record(NULL::ycsb_row, data) r;
{% endif %}

{% if field_index is defined and nested is defined %}
create index if not exists usertable_data_idx on usertable ((data->>{% for i in range(9, 0, -1) %}'YCSB_KEY{{i}}'->>{% endfor %}'YCSB_KEY'));
{% elif field_index is defined %}
create index if not exists usertable_data_idx on usertable ((data->>'YCSB_KEY'));
{% else %}
create index if not exists usertable_data_idx on usertable using gin(data jsonb_path_ops);
{% endif %}

alter table usertable set (autovacuum_vacuum_scale_factor = 0.0);
alter table usertable set (autovacuum_vacuum_threshold = 10000);
alter table usertable set (autovacuum_analyze_scale_factor = 0.0);
alter table usertable set (autovacuum_analyze_threshold = 10000);

{% if jsonb_check is defined %}
alter table usertable add constraint field_constrains check (data ? 'FIELD2');
{% endif %}

{% if jsonb_check_multiple is defined %}
alter table usertable add constraint field_constrains
check (data ? 'FIELD0' {% for i in range(1, 9) %} and data ? 'FIELD{{i}}'{% endfor %});
{% endif %}

{% if sql_check is defined %}
alter table usertable add constraint field_constrains check (FIELD0 is not null);
{% endif %}

{% if sql_check_multiple is defined %}
alter table usertable add constraint field_constrains
check (FIELD0 is not null {% for i in range(1, 9) %} and FIELD{{i}} is not null{% endfor %});
{% endif %}

{% if toast_check is defined %}
alter table usertable alter column data set storage {{ toast_check }};
{% endif %}
