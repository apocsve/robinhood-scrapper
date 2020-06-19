#!/bin/bash
set -e

pip install -r requirements.txt

export MONGO_HOST=${MONGO_HOST:-localhost}
export MONGO_PORT=${MONGO_PORT}
export MONGO_USER=${MONGO_USER}
export MONGO_PASSWORD=${MONGO_PASSWORD}

export MYSQL_NAME=${MYSQL_NAME}
export MYSQL_PORT=${MYSQL_PORT}
export MYSQL_HOST=${MYSQL_HOST}
export MYSQL_USER=${MYSQL_USER}
export MYSQL_PASSWORD=${MYSQL_PASSWORD}

export REDIS_HOST=${REDIS_HOST:-localhost}
export REDIS_PORT=${REDIS_PORT}

export RABBITMQ_HOST=${RABBITMQ_HOST:-localhost}
export RABBITMQ_PORT=${RABBITMQ_PORT_1:-5672}
export PYTHONPATH="${PWD}/../"
export ROBINHOOD_USERNAME=${ROBINHOOD_USERNAME}
export ROBINHOOD_PASSWORD=${ROBINHOOD_PASSWORD}
export MFA_SECRET=${MFA_SECRET}

supervisord -c /etc/supervisord.conf