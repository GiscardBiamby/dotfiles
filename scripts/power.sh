#!/bin/bash

nvidia-smi -q
nvidia-smi -q -d PERFORMANCE
sudo tlp-stat -s
sudo powertop
sudo /opt/dell/dcc/cctk

cat /proc/driver/nvidia/gpus/0000\:01\:00.0/power 
