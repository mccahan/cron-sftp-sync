FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache busybox-extras lftp

# Create directories
RUN mkdir -p /app/sftp /app/local

# Create sync.sh script
RUN echo '#!/bin/sh' > /app/sync.sh && \
    echo 'set -e' >> /app/sync.sh && \
    echo 'PROTO=$SFTP_PROTO' >> /app/sync.sh && \
    echo 'USER=$SFTP_USER' >> /app/sync.sh && \
    echo 'PASS=$SFTP_PASS' >> /app/sync.sh && \
    echo 'SERVER=$SFTP_SERVER' >> /app/sync.sh && \
    echo 'PORT=$SFTP_PORT' >> /app/sync.sh && \
    echo 'REMOTE_PATH=$SFTP_PATH' >> /app/sync.sh && \
    echo 'TERM=dumb' >> /app/sync.sh && \
    echo 'LOCAL_PATH=/app/local' >> /app/sync.sh && \
    echo 'while true; do' >> /app/sync.sh && \
    echo '  echo "Starting sync..."' >> /app/sync.sh && \
    echo '  TERM=dumb lftp -u "$USER","$PASS" -e "set cmd:interactive false; set log:enabled true; set xfer:use-temp-file yes; set log:enabled/xfer yes; set xfer:temp-file-name *.lftp; mirror --continue --parallel=2 $REMOTE_PATH $LOCAL_PATH; bye" -p $PORT $PROTO://$SERVER' >> /app/sync.sh && \
    echo '  sleep 600' >> /app/sync.sh && \
    echo '  echo "Completed. Sleeping for 10 minutes..."' >> /app/sync.sh && \
    echo 'done' >> /app/sync.sh && \
    chmod +x /app/sync.sh

# Start the sync script in the foreground
CMD ["/app/sync.sh"]
