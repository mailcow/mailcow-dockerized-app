#!/bin/bash
COLOR_GREEN="\033[92m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[93m"
COLOR_DEFAULT="\033[39m"

print_warn()
{
    echo -ne "$COLOR_YELLOW\n$1\n$COLOR_DEFAULT"
}

print_err()
{
    echo -ne "$COLOR_RED\n$1\n$COLOR_DEFAULT"
}

print_ok()
{
    echo -ne "$COLOR_GREEN\n$1\n$COLOR_DEFAULT"
}

# Wait for db come up
cd /opt/sync-engine && bin/wait-for-it.sh mysql:3306

FILE_TO_CHECK="/var/log/supervisor/sync_engine_inbox.log"
LINE_TO_CONTAIN="Use CTRL-C to stop."
SLEEP_TIME=10

# Start the supervisord in foreground
/usr/bin/supervisord -n &
echo '' > $FILE_TO_CHECK

while true
do
	CHECK_STATUS=""
	while [ -z "${CHECK_STATUS}" ]
	do
		echo -ne "Waiting for the sync-engine to be ready...\n"
		sleep ${SLEEP_TIME}
		CHECK_STATUS=$(cat $FILE_TO_CHECK | grep "${LINE_TO_CONTAIN}")
	done
	print_ok "sync-engine is up!"

	sync_engine_dbs=( "inbox" "inbox_1" "inbox_2" "inbox_3" )
	created_dbs=()
	all_dbs_created=false
	echo -ne "Checking whether sync-engine dbs have been created...\n"
	for db_name in "${sync_engine_dbs[@]}"
	do
		if mysql -hmysql -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD "$db_name" -e exit > /dev/null 2>&1; then
			print_ok "DB $db_name is exist."
			created_dbs[${#created_dbs[@]}]="$db_name"
			all_dbs_created=true
		else
			print_err "DB $db_name does not exist."
			all_dbs_created=false
			break
		fi
	done

	if $all_dbs_created; then
		print_ok "All dbs has been created. sync-engine is ready!"
		break
	else
		print_warn "Some dbs was not be created. Retrying..."
		for db in "${created_dbs[@]}"
		do
			mysql -hmysql -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -e "DROP DATABASE $db;"
		done
		echo '' > $FILE_TO_CHECK
		supervisorctl restart sync_engine_inbox
		supervisorctl restart sync_engine_api
	fi

	sleep ${SLEEP_TIME}
done

wait