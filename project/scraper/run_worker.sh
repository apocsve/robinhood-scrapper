#!/bin/bash
set -e

while ! nc -z robinhood-scrapper-mongo 27017 ;
do
    echo "############# Waiting for robinhood-scrapper-mongo to start.";
    sleep 3;
done;

while ! nc -z robinhood-scrapper-redis 6379 ;
do
    echo "############# Waiting for robinhood-scrapper-redis to start.";
    sleep 3;
done;

while ! nc -z robinhood-scrapper-rabbitmq 5672 ;
do
    echo "############# Waiting for robinhood-scrapper-rabbitmq to start.";
    sleep 3;
done;

while ! nc -z robinhood-scrapper-mysql 3306 ;
do
    echo "############# Waiting for robinhood-scrapper-mysql to start.";
    sleep 3;
done;

pip install -r requirements.txt

export MONGO_HOST=${MONGO_HOST:-localhost}
export MYSQL_HOST=${MYSQL_HOST:-localhost}
export REDIS_HOST=${REDIS_HOST:-localhost}
export RABBITMQ_HOST=${RABBITMQ_HOST:-localhost}
export RABBITMQ_PORT=${RABBITMQ_PORT:-5672}
export PYTHONPATH="${PWD}/../"
export ROBINHOOD_USERNAME=${ROBINHOOD_USERNAME}
export ROBINHOOD_PASSWORD=${ROBINHOOD_PASSWORD}
export MFA_SECRET=${MFA_SECRET}


#python src/scrape_instruments.py --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT --scrape-fundamentals;
#python src/worker.py --mode popularity --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT;
#python src/worker.py --mode quote --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT;
#python src/worker.py --mode fundamentals --rabbitmq_host=$RABBITMQ_HOST --rabbitmq_port=$RABBITMQ_PORT;

#until python src/worker.py \
#	--mode popularity \
#	--rabbitmq_host=$RABBITMQ_HOST \
#	--rabbitmq_port=$RABBITMQ_PORT; do
#	echo "Popularities scraper exited with code $?.  Restarting in 10 seconds..."
#	sleep 10
#done

#until python src/worker.py \
#	--mode fundamentals \
#	--rabbitmq_host=$RABBITMQ_HOST \
#	--rabbitmq_port=$RABBITMQ_PORT; do
#	echo "Popularities scraper exited with code $?.  Restarting in 10 seconds..."
#	sleep 10
#done

until ! nc -z robinhood-scrapper-rabbitmq 5672;
do
	echo "running";
	sleep 60
done

