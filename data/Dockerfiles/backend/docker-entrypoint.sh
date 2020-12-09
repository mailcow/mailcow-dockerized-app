#!/bin/bash

printf "\n%s" "waiting for MySql ..."
while ! mysqladmin ping -hmysql -p --password="$DATABASE_PASSWD" --silent; do
    sleep 1
    printf "."
done

# Start the services
/usr/bin/supervisord -n

exec "$@"