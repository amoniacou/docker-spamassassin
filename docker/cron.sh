#!/usr/bin/with-contenv sh

touch /etc/crontab /etc/cron.*/*
echo "0 0 * * * root s6-envuidgid spamassassin sa-update && kill -HUP `cat /var/run/spamassassin/spamd.pid` >/dev/null 2>&1" > /etc/crontab
exec cron -f
