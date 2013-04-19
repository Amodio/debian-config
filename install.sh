#!/bin/bash

# Directories to be created in /mnt/
directories="canon groar nexus win win2"

# DO NOT EDIT THIS FILE FROM HERE (at ur own risk!)

if [ $(whoami) != "root" ]; then
    echo "Please run me when logged as root." > /dev/stderr
    exit 1
fi

# You need to have changed the login from inittab, on the line after 'autologin'
username=$(grep autologin inittab | awk '{ print $4 }')

cp -f etc/fstab /etc/fstab
for directory in $directories; do
    echo "Creating /mnt/$directory directory."
    mkdir "/mnt/$directory"
    echo "/mnt/$directory" >> /etc/fstab
done

echo "Set /home (below) + /mnt/* (above)" >> /etc/fstab
blkid >> /etc/fstab

# Useless.. unless you want to gain a little disk space
#rm -rf /home
#mkdir /home

# Install ViM
aptitude -y install vim vim-syntax-go

echo "Will now edit /etc/fstab. You have to set /home + /mnt/* (ur mountpoints)"
echo "You have just one try; when exiting from ViM, it will be done."
echo "--- PRESS ENTER WHEN READY ---"
read
vi /etc/fstab
#FIXME mount /home

# No more needed to enter the password when using sudo
echo "$username	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install graphical part
aptitude -y install xserver-xorg xinit
aptitude -y install openbox python-xdg conky-cli
aptitude -y install feh graphicsmagick-imagemagick-compat
aptitude -y install obmenu obconf thunar
aptitude -y install numlockx volumicon-alsa xcalib xscreensaver tint2 wbar

# Install the terminal
aptitude -y install rxvt-unicode

# Install musical part
aptitude -y install sonata mpd mpc
cp -f etc/mpd.conf /etc/mpd.conf

# Autologin (u also have to modify ur .bashrc)
cp -f etc/inittab /etc/inittab
aptitude -y install mingetty

# Propose a package to install whenever a command is not found
aptitude -y install command-not-found && sudo update-command-not-found

# Install Web browsers
# This is firefox
aptitude -y install iceweasel
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# Dependencies for Chrome
aptitude -y install libgconf2-4 libxss1 xdg-utils
dpkg -i google-chrome-stable_current_amd64.deb

# Video reader
aptitude -y install vlc

# Install eog (image viewer)
aptitude -y install eog

# Optional stuff from here

# Crypted USB key (alias crypt)
aptitude -y install cryptsetup
cp -f etc/crypttab /etc/crypttab

# Galaxy Nexus (alias nexus)
aptitude -y install mtp-tools

echo "Will now logout to let you enjoy openbox on debian."
echo "Peace."
echo "--- PRESS ENTER WHEN READY ---"
read
killall -9 bash
