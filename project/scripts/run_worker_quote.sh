#!/bin/bash
set -e

echo "Executing worker.py quote"

until python /app/src/worker.py --mode quote --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT;
do
    echo "Quotes scraper exited with code $?.  Restarting in 10 seconds..."
    sleep 10
done