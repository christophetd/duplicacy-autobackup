#!/bin/sh
echo "$BACKUP_SCHEDULE /app/duplicacy-autobackup.sh backup" > /var/spool/cron/crontabs/root
/app/duplicacy-autobackup.sh init

if [[ $BACKUP_IMMEDIATLY == "yes" ]]; then
    echo "Running a backup right now"
    /app/duplicacy-autobackup.sh backup
fi

crond -l 8 -f