#!/bin/bash
#  >> /var/log/mount_notebooks.log 2>&1
uid=`id -u jupyter`
gid=`id -g jupyter`
goofys -f -o allow_other --uid $uid --gid $gid --stat-cache-ttl 400ms --type-cache-ttl 100ms --region $JUPYTER_NB_BUCKET_REGION $JUPYTER_NB_BUCKET:$JUPYTER_NB_BUCKET_PREFIX $JUPYTER_NB_BUCKET_MOUNT
