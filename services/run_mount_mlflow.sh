#!/bin/bash
uid=`id -u jupyter`
gid=`id -g jupyter`
goofys -f -o allow_other --uid $uid --gid $gid --region $MLFLOW_DATA_BUCKET_REGION $MLFLOW_DATA_BUCKET:$MLFLOW_DATA_BUCKET_PREFIX $MLFLOW_DATA_BUCKET_MOUNT
