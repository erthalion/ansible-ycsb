create table usertable(data jsonb);
create index usertable_data_idx on usertable ((data->>'YCSB_KEY'));
-- {% if field_index and nested %}
-- create index usertable_data_idx on usertable ((data->>{% for i in range(9, 0, -1) %}'YCSB_KEY{{i}}'->>{% endfor %}'YCSB_KEY'));
-- {% elif field_index %}
-- create index usertable_data_idx on usertable ((data->>'YCSB_KEY'));
-- {% else %}
-- create index usertable_data_idx on usertable using gin(data jsonb_path_ops);
-- {% endif %}
alter table usertable set (autovacuum_vacuum_scale_factor = 0.0);
alter table usertable set (autovacuum_vacuum_threshold = 10000);
alter table usertable set (autovacuum_analyze_scale_factor = 0.0);
alter table usertable set (autovacuum_analyze_threshold = 10000);
