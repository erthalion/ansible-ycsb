#!/bin/bash

EXPERIMENTS=4
declare -a THREADS=(1 10 20 30 40 50 60 70 80 90 100)

for thread in "${THREADS[@]}"
do
    echo "Run experiments for ${thread} threads"

    for i in $(seq 1 $EXPERIMENTS)
    do
        echo "Run ${i} experiment"

        ansible-playbook benchmark.yml -i "localhost," -e "threads=${thread}" -e "@read.json"

        # Forced cleanup even if there were an errors before
        #
        ansible-playbook cleanup.yml -i "localhost," -e "postgresql=True keypair=erthalion_oregon subnet_id=subnet-83cea8da ssh_key=/home/erthalion/.ssh/erthalion_oregon.pem workload=workloadc threads=${thread} field_index=True postgres_from_source=True journaled=True prevent_cache=True generator_ami=ami-cd8e80b4 mongodb_ami=ami-d1e989b1 mysql_ami=ami-05e98965"
        sleep 10
    done
done
