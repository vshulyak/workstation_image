#!/bin/bash
exec /sbin/setuser jupyter tensorboard --logdir $TENSORBOARD_LOGS_DIR
