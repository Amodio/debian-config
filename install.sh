#!/bin/bash

if [ "$USER" != 'root' ]; then
    echo 'Please run me when logged as root.' > /dev/stderr
    exit 1
fi

echo "Let's start, hope you gonna be a Yes man ;)"
echo

# One argument: default value if nothing was read
function get_word()
{
    read read_tmp
    if [ -z "$read_tmp" ]; then
        read_tmp="$1"
    fi
    if [ "$read_tmp" == "N" ]; then
        echo 'n'
    elif [ "$read_tmp" == "Y" ]; then
        echo 'y'
    else
        echo "$read_tmp"
    fi
}

# Your username
username='da'
echo -n 'What is your username ['$username']? '
response=$(get_word $username)
if [ "$response" != "$username" ]; then
    username=$response
    echo 'Setting the username to "'$username'".'
fi

# Directory containing your music files
mpd_zik_dir='/home/musique'
echo -n 'What is your music directory ['$mpd_zik_dir']? '
response=$(get_word $mpd_zik_dir)
if [ "$response" != "$mpd_zik_dir" ]; then
    mpd_zik_dir=$response
    echo 'Setting the music dir to "'$mpd_zik_dir'".'
fi

# Directories to be created in /mnt/
mountpoints='canon groar nexus win win2'
echo -n 'What are your mountpoints? ['$mountpoints']? '
response=$(get_word $mountpoints)
if [ "$response" != "$mountpoints" ]; then
    mountpoints=$response
    echo 'Setting the mountpoints to "'$mountpoints'".'
fi

install_nvidia=1
echo -n 'Should we install NVIDIA drivers ? [Y/n] '
response=$(get_word Y)
if [ "$response" != 'y' ]; then
    echo 'Will not install NVIDIA drivers.'
    install_nvidia=0
fi

# You should know what you are doing!
use_optional=1
echo -n 'Should we install optional stuff? [Y/n] '
response=$(get_word Y)
if [ "$response" != 'y' ]; then
    echo 'Will not install optional stuff.'
    use_optional=0
fi

cp -f etc/fstab /etc/fstab
for directory in $mountpoints; do
    echo "Creating /mnt/$directory directory."
    mkdir "/mnt/$directory"
    echo "/mnt/$directory" >> /etc/fstab
done

echo '# Set /home and / (below) + /mnt/ mountpoints (above)' >> /etc/fstab
blkid | sed 's/^/# /gi' >> /etc/fstab

# Sudo
aptitude -y install sudo
# The password is no more required
echo "$username	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install ViM
aptitude -y install vim vim-syntax-go

echo 'Will now edit /etc/fstab. You have to set /home + /mnt/* (ur mountpoints)'
echo 'You have just one try; when exiting from ViM, it will be too late! :p'
echo '--- PRESS ENTER WHEN READY ---'
read
vi /etc/fstab

echo -n 'Remount /home (ignore if you have not a dedicated partition)? [Y/n] '
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    # Useless.. unless you want to gain a little disk space..
    rm -rf /home; mkdir /home
    mount /home
fi

# Install graphical part
aptitude -y install xserver-xorg xinit
aptitude -y install openbox python-xdg conky-std
aptitude -y install feh graphicsmagick-imagemagick-compat
aptitude -y install obmenu obconf thunar
aptitude -y install numlockx volumicon-alsa xcalib xscreensaver tint2 wbar

cp -f .bashrc '/root/.bashrc'
echo -n "Copy default config. files to your \$HOME? (allow overwrite) [Y/n] "
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    cp -f .wbar "/home/$username/.wbar"
    cp -f .xinitrc "/home/$username/.xinitrc"
    cp -f .xscreensaver "/home/$username/.xscreensaver"
    cp -f .xsession "/home/$username/.xsession"
    cp -f .conkyrc "/home/$username/.conkyrc"
    mkdir -p "/home/$username/.config"
    cp -rf etc/.config/{autostart,openbox,volumeicon} "/home/$username/.config/"
    if [ !-f "/home/$username/.bashrc" ]; then
        echo -n 'Do you really want to erase your .bashrc ? [y/N] '
        response=$(get_word n)
        if [ "$response" != 'n' ]; then
            cp -f .bashrc "/home/$username/.bashrc"
        fi
    else
        cp -f .bashrc "/home/$username/.bashrc"
    fi
fi

# Install the terminal
aptitude -y install rxvt-unicode

# Install musical part
aptitude -y install sonata mpd mpc
sed 's#^music_directory.*$#music_directory "'$mpd_zik_dir'"#' etc/mpd.conf > /etc/mpd.conf

# Autologin
aptitude -y install mingetty
sed 's/--autologin \w*/--autologin '$username'/' etc/inittab > /etc/inittab

# Propose a package to install whenever a command is not found
aptitude -y install command-not-found && echo 'Do not worry about that dude, I and I take care of it' && update-command-not-found

# Install Web browsers
# This is firefox
aptitude -y install iceweasel
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# Dependencies for Chrome
aptitude -y install libgconf2-4 libxss1 xdg-utils
dpkg -i google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Video players
aptitude -y install mplayer vlc

# FTP client
aptitude -y install lftp

# Install eog (image viewer)
aptitude -y install eog

# News reader
aptitude -y install slrn

# IRC client
aptitude -y install irssi

# Add screen (sharing terms)
aptitude -y install screen

# PDF reader
aptitude -y install evince

# Git
aptitude -y install gitk

# Sniffer
aptitude -y install wireshark

# Sound
aptitude -y install alsa-utils

# smartctl (for HDD health check)
aptitude -y install smartmontools

if [ $install_nvidia -eq 1 ]; then
    # NVIDIA proprietary drivers
    aptitude -y install nvidia-glx nvidia-xconfig
fi

if [ $use_optional -eq 1 ]; then
    # Optional stuff from here

    # Crypted USB key (alias crypt)
    aptitude -y install cryptsetup
    cp -f etc/crypttab /etc/crypttab

    # Galaxy Nexus (alias nexus)
    aptitude -y install mtp-tools

    # Realtek 8169 (Ethernet card)
    aptitude -y install firmware-realtek
fi

echo 'Will now reboot to let you enjoy Openbox on Debian.'
echo 'Please run `mpc update` after the reboot for your music to be loaded.'
echo 'Peace.'
echo '--- PRESS ENTER TO REBOOT ---'
read
reboot
