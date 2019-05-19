#!/bin/sh

if [[ ! -z $DUPLICACY_VERSION ]]; then
    wget https://github.com/gilbertchen/duplicacy/releases/download/v$DUPLICACY_VERSION/duplicacy_linux_x64_$DUPLICACY_VERSION -O /usr/bin/duplicacy
    chmod +x /usr/bin/duplicacy
fi

duplicacy | grep VERSION -A 1

echo "$BACKUP_SCHEDULE /app/duplicacy-autobackup.sh backup" > /var/spool/cron/crontabs/root
/app/duplicacy-autobackup.sh init

if [[ $BACKUP_IMMEDIATLY == "yes" ]] || [[ $BACKUP_IMMEDIATELY == "yes" ]]; then # two spellings for retro-compatibility
    echo "Running a backup right now"
    /app/duplicacy-autobackup.sh backup
fi

crond -l 8 -f
