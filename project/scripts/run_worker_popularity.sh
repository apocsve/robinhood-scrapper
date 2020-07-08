#!/bin/bash
set -e

echo "$(date "+%m/%d/%Y %r") :::: Executing worker.py popularity"

until python /app/src/worker.py --mode popularity --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT;
do
    echo "$(date "+%m/%d/%Y %r") :::: Popularities scraper exited with code $?.  Restarting in 10 seconds..."
    sleep 10
done