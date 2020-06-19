#!/bin/bash
set -e

echo "Executing worker.py fundamentals"

until python /app/src/worker.py --mode fundamentals --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT;
do
    echo "Fundamentals scraper exited with code $?.  Restarting in 10 seconds..."
    sleep 10
done