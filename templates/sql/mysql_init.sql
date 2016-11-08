create table usertable (
    data json,
    ycsb_key char(100) generated always as (json_extract(data, '$.YCSB_KEY')),
    index usertable_data_idx (ycsb_key)
);
