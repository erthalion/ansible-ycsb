# ansible-ycsb

Ansible-ycsb is a simple tool, created for [Highload++ 2016](http://www.highload.ru/2016/abstracts/2351.html), to perform a lot of
different benchmarks for PostgreSQL(jsonb), MySQL(json) and MongoDB(bson) on
AWS EC2 using my [fork](https://github.com/erthalion/YCSB) of
[YCSB](https://github.com/brianfrankcooper/YCSB). Warning: work in progress.

List of available options:

### Databases

* postgresql - perform tests for PostgreSQL jsonb
* mysql - perform tests for MySQL json
* mongodb - perform tests for MongoDB
* prevent_cleanup - keep all instances after a test (for debugging purposes)
* field_index - use functional index over jsonb
* postgresql_from_deb - install PostgreSQL from ubuntu repositories
* postgresql_from_source - install PostgreSQL directly from source (master
  branch)
* journaled - set write concern level to `journaled` for MongoDB
* jsonb_check - add constraints for jsonb documents
* toast_check - change column storage type for PostgreSQL
* sql - test relation instead of document for PostgreSQL

### AWS

* subnet_id - VPC subnet id
* keypair - your AWS keypair
* generator_ami - prepared snapshot for workload generator
* postgresql_ami - prepared snapshot for PostgreSQL
* mysql_ami - prepared snapshot for MySQL
* mongodb_ami - prepared snapshot for MongoDB
* image - default image to use when creating instances (when not
  overridden with `generator_ami`, `postgresql_ami`, `mysql_ami`, or
  `mongodb_ami`).
* region - AWS region ('us-west-2' by default)
* availability_zone - AWS Availability Zone ('us-west-2c' by default)
* placement_group - EC2 Placement Group ('ycsb' by default)

### YCSB

* workload - YCSB [workload type](https://github.com/brianfrankcooper/YCSB/wiki/Core-Workloads)
* threads - amount of clients/threads for workload
* custom_size - allows to use documents of custom size
* field_count - if `custom_size` is True, allows to set amount of fields inside
  document
* field_length - if `custom_size` is True, allows to set a lenght for each
  field in document

```shell
# perform benchmarks
ansible-playbook benchmark.yml -i "localhost," -e "option1=True option2=..."

# clean up just in case there were an errors in the previous script run
ansible-playbook cleanup.yml -i "localhost," -e "options..."
```
