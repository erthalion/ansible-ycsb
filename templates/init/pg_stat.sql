select datname, temp_files, pg_size_pretty(temp_bytes) from pg_catalog.pg_stat_database;
