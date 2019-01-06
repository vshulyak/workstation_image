#!/bin/bash
#  >> /var/log/mount_data.log 2>&1
uid=`id -u jupyter`
gid=`id -g jupyter`
goofys -f -o allow_other --uid $uid --gid $gid --region $JUPYTER_DATA_BUCKET_REGION $JUPYTER_DATA_BUCKET:$JUPYTER_DATA_BUCKET_PREFIX $JUPYTER_DATA_BUCKET_MOUNT
