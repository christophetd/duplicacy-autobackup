#!/bin/sh
echo "$BACKUP_SCHEDULE /app/backup.sh" > /var/spool/cron/crontabs/root
/app/backup.sh
crond -l 8 -f