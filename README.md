# cron-sftp-sync

This image runs an sftp/ftp sync once every 10 minutes from a remote server to a local mount directory.

## Running from CLI

```sh
docker run -d --name sftp-sync-container \
  -e SFTP_USER=username \
  -e SFTP_PASS=password \
  -e SFTP_SERVER=my.server.com \
  -e SFTP_PORT=22 \
  -e SFTP_PROTO=sftp \
  -e SFTP_PATH=/remote/directory \
  -v /mnt/synced-data:/app/local \
  mccahan/sftp-sync
```