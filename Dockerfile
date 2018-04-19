FROM alpine:3.7
MAINTAINER Christophe Tafani-Dereeper <christophe@tafani-dereeper.me>

#--
#-- Environment variables
#--

# General purpose
ENV BACKUP_SCHEDULE '* * * * *'
ENV BACKUP_NAME ''
ENV BACKUP_LOCATION ''
ENV BACKUP_ENCRYPTION_KEY ''
ENV DUPLICACY_BACKUP_OPTIONS '-threads 4 -stats'
ENV DUPLICACY_INIT_OPTIONS ''

# S3
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_KEY ''
# Backblaze B2
ENV B2_ID ''
ENV B2_KEY ''
# This is a file path, so it needs to be accessible to the container (e.g. via a mount)
ENV HUBIC_TOKEN_FILE ''
ENV SSH_PASSWORD ''
# This is a file path, so it needs to be accessible to the container (e.g. via a mount)
ENV SSH_KEY_FILE '' 
ENV DROPBOX_TOKEN ''
ENV AZURE_KEY ''
ENV GCD_TOKEN ''
# This is a file path, so it needs to be accessible to the container (e.g. via a mount)
ENV GCS_TOKEN_FILE ''
# This is a file path, so it needs to be accessible to the container (e.g. via a mount)
ENV ONEDRIVE_TOKEN_FILE ''

#--
#-- Other steps
#--
RUN apk --no-cache add ca-certificates && update-ca-certificates
RUN wget https://github.com/gilbertchen/duplicacy/releases/download/v2.1.0/duplicacy_linux_x64_2.1.0 -O /usr/bin/duplicacy && \
    chmod +x /usr/bin/duplicacy

RUN mkdir /app
WORKDIR /app

ADD entrypoint.sh .
ADD backup.sh .

RUN chmod +x entrypoint.sh backup.sh

VOLUME ["/data"]
ENTRYPOINT ["/app/entrypoint.sh"]