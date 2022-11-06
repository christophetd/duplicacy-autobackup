#!/bin/sh
echo "$BACKUP_SCHEDULE /app/duplicacy-autobackup.sh backup" > /var/spool/cron/crontabs/root
echo "$PRUNE_SCHEDULE /app/duplicacy-autobackup.sh prune" >> /var/spool/cron/crontabs/root

/app/duplicacy-autobackup.sh init

if [[ $BACKUP_IMMEDIATLY == "yes" ]] || [[ $BACKUP_IMMEDIATELY == "yes" ]]; then # two spellings for retro-compatibility
    echo "Running a backup right now"
    /app/duplicacy-autobackup.sh backup
fi

crond -l 8 -f
