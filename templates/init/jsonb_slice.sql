\set id random(1, {{ recordcount }})
\set field_id1 random(1, {{ fieldcount }})
\set field_id2 random(1, {{ fieldcount }})
\set field_id3 random(1, {{ fieldcount }})
\set field_id4 random(1, {{ fieldcount }})
\set field_id5 random(1, {{ fieldcount }})
\set field_id6 random(1, {{ fieldcount }})
\set field_id7 random(1, {{ fieldcount }})
\set field_id8 random(1, {{ fieldcount }})
\set field_id9 random(1, {{ fieldcount }})
\set field_id10 random(1, {{ fieldcount }})

select
    data->('field' || :field_id1),
    data->('field' || :field_id2),
    data->('field' || :field_id3),
    data->('field' || :field_id4),
    data->('field' || :field_id5),
    data->('field' || :field_id6),
    data->('field' || :field_id7),
    data->('field' || :field_id8),
    data->('field' || :field_id9),
    data->('field' || :field_id10)
    from test_jsonb where id = :id;
