#!/bin/bash

if [ "$#" -ne 2 ]; then
    exit 1
fi

url=$1
max_attempts=$2
attempt=0

while [ $attempt -lt $max_attempts ]; do
    health_status=$(curl -s --max-time 5 -o /dev/null -w "%{http_code}" $url)

    if [ "$health_status" -eq 200 ]; then
        echo "OK"
        exit 0
    fi

    sleep 5
    ((attempt++))
done

echo "ERROR"
exit 1
