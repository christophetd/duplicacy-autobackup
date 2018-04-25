#!/bin/sh

PRE_BACKUP_SCRIPT="/scripts/pre-backup.sh"
POST_BACKUP_SCRIPT="/scripts/post-backup.sh"

cd /data

do_init() {
  : ${BACKUP_NAME:?'Missing BACKUP_NAME'}
  : ${BACKUP_LOCATION:?'Missing BACKUP_LOCATION'}

  if [[ ! -z "$BACKUP_ENCRYPTION_KEY" ]]; then
    echo "This backup will be encrypted."
    export DUPLICACY_INIT_OPTIONS="-encrypt $DUPLICACY_INIT_OPTIONS"
  fi

  duplicacy init $DUPLICACY_INIT_OPTIONS $BACKUP_NAME "$BACKUP_LOCATION"
  if [[ $? != 0 ]]; then
    echo "duplicacy init command failed. Aborting" >&2
    rm -rf .duplicacy
    exit 1
  fi
}

do_backup() {
  status=0
  if [[ -f $PRE_BACKUP_SCRIPT ]]; then
    echo "Running pre-backup script"
    sh $PRE_BACKUP_SCRIPT
    status=$?
  fi
  if [[ $status != 0 ]]; then
    echo "Pre-backup script exited with status code $status. Not performing backup." >&2
    return
  fi

  duplicacy backup $DUPLICACY_BACKUP_OPTIONS

  if [[ -f $POST_BACKUP_SCRIPT ]]; then
    echo "Running post-backup script"
    sh $POST_BACKUP_SCRIPT
    status=$?
    echo "Post-backup script exited with status $status"
  fi
}

export DUPLICACY_PASSWORD=$BACKUP_ENCRYPTION_KEY
export DUPLICACY_S3_ID=$AWS_ACCESS_KEY_ID
export DUPLICACY_S3_SECRET=$AWS_SECRET_KEY
export DUPLICACY_B2_ID=$B2_ID
export DUPLICACY_B2_KEY=$B2_KEY
export DUPLICACY_HUBIC_TOKEN=$HUBIC_TOKEN_FILE
export DUPLICACY_SSH_PASSWORD=$SSH_PASSWORD
export DUPLICACY_SSH_KEY_FILE=$SSH_KEY_FILE
export DUPLICACY_DROPBOX_TOKEN=$DROPBOX_TOKEN
export DUPLICACY_AZURE_KEY=$AZURE_KEY
export DUPLICACY_GCD_TOKEN=$GCD_TOKEN
export DUPLICACY_GCS_TOKEN=$GCS_TOKEN_FILE
export DUPLICACY_ONE_TOKEN=$ONEDRIVE_TOKEN_FILE

if [[ "$1" == "init" ]]; then
  if [[ ! -d .duplicacy ]]; then
    do_init
  else
    echo 'This folder has already been initialized with duplicacy. Not initializing again'
  fi
elif [[ "$1" == "backup" ]]; then
  do_backup
else 
  echo "Unknown command: $1" >&2
fi