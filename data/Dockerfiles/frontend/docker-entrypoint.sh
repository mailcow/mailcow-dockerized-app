#!/bin/sh
sed -i 's|__TIMEZONE__|'${TZ}'|g' /usr/share/nginx/html/js/*
nginx -g 'daemon off;'