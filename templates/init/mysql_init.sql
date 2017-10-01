create table usertable (
    data json,
    ycsb_key varchar(255) generated always as (json_extract(data, '$.YCSB_KEY')) stored primary key
);
