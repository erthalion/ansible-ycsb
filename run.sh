#!/bin/bash

set -eu

EXPERIMENTS=4
declare -a THREADS=(1 10 20 30 40 50 60 70 80 90 100)

for thread in "${THREADS[@]}"
do
    echo "Run experiments for ${thread} threads"

    for i in $(seq 1 $EXPERIMENTS)
    do
        echo "Run ${i} experiment"

        ansible-playbook benchmark.yml\
            -e "pgbench_clients=${thread}"\
            -e "INSTANCE_TYPE=m4.xlarge"\
            -e "@${1}" || failed=1

        # Forced cleanup even if there were errors before
        #
        ansible-playbook cleanup.yml -e "@${1}"

        ansible-playbook benchmark.yml\
            -e "pgbench_clients=${thread}"\
            -e "INSTANCE_TYPE=m4.xlarge"\
            -e "tsc=true"\
            -e "@${1}" || failed=1
        ansible-playbook cleanup.yml -e "@${1}"

        ansible-playbook benchmark.yml\
            -e "pgbench_clients=${thread}"\
            -e "INSTANCE_TYPE=m5.xlarge"\
            -e "@${1}" || failed=1
        ansible-playbook cleanup.yml -e "@${1}"

        ansible-playbook benchmark.yml\
            -e "pgbench_clients=${thread}"\
            -e "INSTANCE_TYPE=m5.xlarge"\
            -e "tsc=true"\
            -e "@${1}" || failed=1
        ansible-playbook cleanup.yml -e "@${1}"

        if [[ ${failed:+x} ]]; then
           exit 1
        fi

        sleep 10
    done
done
