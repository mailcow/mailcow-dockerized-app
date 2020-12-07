#!/bin/bash

ACCOUNT_ID=$1

cd /opt/sync-engine/bin
./start-stop-account --stop --id $ACCOUNT_ID --softdelete
echo yes | ./delete-account-data $ACCOUNT_ID

echo "RESULT_CODE: $?"
