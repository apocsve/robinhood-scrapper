#!/bin/sh
set -e

echo "$(date "+%m/%d/%Y %r") :::: Executing mongo_to_mysql.py"

/usr/local/bin/python /app/src/mongo_to_mysql.py;