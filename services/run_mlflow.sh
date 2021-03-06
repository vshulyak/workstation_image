#!/bin/bash
exec /sbin/setuser jupyter mlflow server \
    --backend-store-uri $MLFLOW_SERVER_PERSISTENT_DISK_PATH \
    --default-artifact-root $MLFLOW_SERVER_ARTIFACTS \
    --host $MLFLOW_SERVER_HOST --port $MLFLOW_SERVER_PORT
