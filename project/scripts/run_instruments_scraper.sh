#!/bin/sh
set -e

echo "Executing scrape_instruments.py"

/usr/local/bin/python /app/src/scrape_instruments.py --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT --scrape-fundamentals;