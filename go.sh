#!/bin/bash

aptitude -y install unzip
aptitude -y install libnotify-dev libmpdclient-dev

wget --no-check-certificate https://github.com/Amodio/mpd_notification/archive/master.zip
unzip master.zip
rm -f master.zip

wget --no-check-certificate https://github.com/Amodio/debian-config/archive/master.zip
unzip master.zip
cd debian-config-master
./install.sh
# Should not be reached (as install.sh should reboot the computer)
cd - > /dev/null
