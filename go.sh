#!/bin/bash

aptitude install unzip

wget --no-check-certificate https://github.com/Amodio/debian-config/archive/master.zip
unzip master.zip
cd debian-config-master
./install.sh
