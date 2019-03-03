FROM alpine:3.7
MAINTAINER Christophe Tafani-Dereeper <christophe@tafani-dereeper.me>
ARG PLATFORM=x64

#--
#-- Environment variables
#--

ENV BACKUP_SCHEDULE='* * * * *' \
    BACKUP_NAME='' \
    BACKUP_LOCATION='' \
    BACKUP_ENCRYPTION_KEY='' \
    BACKUP_IMMEDIATLY='no' \
    BACKUP_IMMEDIATELY='no' \
    DUPLICACY_BACKUP_OPTIONS='-threads 4 -stats' \
    DUPLICACY_INIT_OPTIONS='' \
    AWS_ACCESS_KEY_ID='' \
    AWS_SECRET_KEY='' \
    B2_ID='' \
    B2_KEY='' \
    HUBIC_TOKEN_FILE='' \
    SSH_PASSWORD='' \
    SSH_KEY_FILE='' \
    DROPBOX_TOKEN='' \
    AZURE_KEY='' \
    GCD_TOKEN='' \
    GCS_TOKEN_FILE='' \
    ONEDRIVE_TOKEN_FILE=''

#--
#-- Other steps
#--
RUN apk --no-cache add ca-certificates && update-ca-certificates \
 && wget https://github.com/gilbertchen/duplicacy/releases/download/v2.1.2/duplicacy_linux_${PLATFORM}_2.1.2 -O /usr/bin/duplicacy \
 && chmod +x /usr/bin/duplicacy \
 && mkdir /app

WORKDIR /app

ADD *.sh ./
RUN chmod +x *.sh

VOLUME ["/data"]
ENTRYPOINT ["/app/entrypoint.sh"]
