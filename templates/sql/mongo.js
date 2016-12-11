use ycsb

{% if nested %}
db.usertable.createIndex({"{% for i in range(9, 0, -1) %}ycsb_key{{i}}.{% endfor %}ycsb_key": 1})
{% endif %}
