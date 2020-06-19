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