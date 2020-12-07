#!/bin/bash

# Wait for db come up
cd /opt/sync-engine && bin/wait-for-it.sh mysql:3306

# Start the services
/usr/bin/supervisord -n