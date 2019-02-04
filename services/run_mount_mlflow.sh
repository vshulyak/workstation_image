#!/bin/bash
uid=`id -u jupyter`
gid=`id -g jupyter`
goofys -f -o allow_other --uid $uid --gid $gid --stat-cache-ttl 400ms --type-cache-ttl 100ms --region $MLFLOW_DATA_BUCKET_REGION $MLFLOW_DATA_BUCKET:$MLFLOW_DATA_BUCKET_PREFIX $MLFLOW_DATA_BUCKET_MOUNT
