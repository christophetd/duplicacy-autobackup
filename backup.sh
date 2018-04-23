#!/bin/sh

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
  duplicacy backup $DUPLICACY_BACKUP_OPTIONS
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

if [[ ! -d .duplicacy ]]; then
  do_init
fi

do_backup