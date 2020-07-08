#!/bin/sh
set -e

echo "$(date "+%m/%d/%Y %r") :::: Executing mongo_clear.py"

/usr/local/bin/python /app/src/mongo_clear.py;