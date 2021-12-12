FROM alpine:3.15.0
MAINTAINER Christophe Tafani-Dereeper <christophe@tafani-dereeper.me>

#--
#-- Build variables
#--
ARG DUPLICACY_VERSION=2.7.2

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
    WASABI_KEY='' \
    WASABI_SECRET='' \
    B2_ID='' \
    B2_KEY='' \
    HUBIC_TOKEN_FILE='' \
    SSH_PASSWORD='' \
    SSH_KEY_FILE='' \
    DROPBOX_TOKEN='' \
    AZURE_KEY='' \
    GCD_TOKEN='' \
    GCS_TOKEN_FILE='' \
    ONEDRIVE_TOKEN_FILE='' \
    PRUNE_SCHEDULE='0 0 * * *' \
    DUPLICACY_PRUNE_OPTIONS=''

#--
#-- Other steps
#--
RUN apk --no-cache add ca-certificates && update-ca-certificates
RUN ARCH="$(uname -m)";\
    if [ "$ARCH" == "x86_64" ]; then \
        DUPLICACY_ARCH="x64"; \
    elif [ "$ARCH" == "aarch64" ]; then \
        DUPLICACY_ARCH="arm64"; \
    elif [ "$ARCH" == "armv7l" ]; then \
        DUPLICACY_ARCH="arm"; \
    fi; \
    wget https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_${DUPLICACY_ARCH}_${DUPLICACY_VERSION} -O /usr/bin/duplicacy && \
    chmod +x /usr/bin/duplicacy

RUN mkdir /app
WORKDIR /app

ADD *.sh ./
RUN chmod +x *.sh

RUN mkdir /wd
WORKDIR /wd

VOLUME ["/data"]
ENTRYPOINT ["/app/entrypoint.sh"]
