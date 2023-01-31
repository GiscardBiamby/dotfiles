#!/bin/bash

nvidia-smi -q
nvidia-smi -q -d PERFORMANCE
sudo tlp-stat -s
# Note, powertop only works on laptops becuse systems don't track power usage unless there is a battery.
sudo powertop
sudo /opt/dell/dcc/cctk

cat /proc/driver/nvidia/gpus/0000\:01\:00.0/power 
