#!/bin/sh

printf "%s" "waiting for MySql ..."
while ! mysqladmin ping -hmysql --silent; do
    sleep 1
done

export REPLACE_VARS='$MYSQL_ENV_MYSQL_ROOT_PASSWORD:$MYSQL_PORT_3306_TCP_PORT'
envsubst "$REPLACE_VARS" < /etc/inboxapp/config-env.json > /etc/inboxapp/config.json
envsubst "$REPLACE_VARS" < /etc/inboxapp/secrets-env.yml > /etc/inboxapp/secrets.yml
cd /opt/sync-engine
# inbox-start startup command
su - inbox -c "PYTHONPATH=/opt/sync-engine /opt/sync-engine/bin/inbox-api"
