#!/bin/bash
exec /sbin/setuser jupyter /opt/conda/bin/jupyter lab --config=/home/jupyter/.jupyter/jupyter_custom_notebook_config.py
