#!/bin/bash

if [ "$USER" != 'root' ]; then
    echo 'Please run me when logged as root.' > /dev/stderr
    exit 1
fi

START_TIME=$(date +%s)

clear
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

# Install ViM
aptitude -y install vim-nox vim-syntax-go
echo

# Extra hosts
echo -n 'Do you want to add extra hosts? [Y/n] '
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    cat etc/hosts >> /etc/hosts
    echo 'Adding hosts.'
    echo -n 'Do you want to edit [with ViM] /etc/hosts? [y/N] '
    response=$(get_word N)
    if [ "$response" == 'y' ]; then
        vi etc/hosts
    fi
fi

# Directory containing your music files
mpd_zik_dir='/home/musique'
echo -n 'What is your music directory ['$mpd_zik_dir']? '
response=$(get_word $mpd_zik_dir)
if [ "$response" != "$mpd_zik_dir" ]; then
    mpd_zik_dir=$response
    echo 'Setting the music dir to "'$mpd_zik_dir'".'
fi

install_nvidia=1
echo -n 'Should we install NVIDIA drivers ? [Y/n] '
response=$(get_word Y)
echo -n 'Will '
if [ "$response" == 'n' ]; then
    echo -n 'not '
    install_nvidia=0
fi
echo 'install NVIDIA drivers.'

# You should know what you are doing!
use_optional=1
echo -n 'Should we install optional stuff? [Y/n] '
response=$(get_word Y)
echo -n 'Will '
if [ "$response" == 'n' ]; then
    echo -n 'not '
    use_optional=0
fi
echo 'install optional stuff.'

echo -n 'Edit fstab [with ViM] (/home will be mounted, strongly advised)? [Y/n] '
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    # Directories to be created in /mnt/
    mountpoints='canon groar nexus win win2'
    echo -n 'Create mountpoint directories in /mnt ? [Y/n] '
    response=$(get_word Y)
    if [ "$response" == 'y' ]; then
        echo "Will create mountpoints: \"$mountpoints\" in /mnt."
    else
        mountpoints=""
        echo 'Will not create any mountpoints in /mnt.'
    fi

    cp -f etc/fstab /etc/fstab
    echo >> /etc/fstab
    for directory in $mountpoints; do
        echo "Creating /mnt/$directory directory."
        mkdir -p "/mnt/$directory"
        echo "# /mnt/$directory" >> /etc/fstab
    done

    echo '# Set /home and / (below) + /mnt/ mountpoints (above)' >> /etc/fstab
    blkid | sed 's/^/# /gi' >> /etc/fstab

    echo
    echo
    echo 'Will now edit /etc/fstab. You have to set /home + /mnt/* (ur mountpoints)'
    echo '--- PRESS ENTER WHEN READY ---'
    read
    vi /etc/fstab

    echo -n 'Mount /home? [Y/n] '
    response=$(get_word Y)
    if [ "$response" == 'y' ]; then
        # Useless.. unless you want to gain a little disk space..
        # rm -rf /home; mkdir /home
        mount /home
    fi
fi

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
    cp -rf .config/{autostart,openbox,volumeicon} "/home/$username/.config/"
    if [ -f "/home/$username/.bashrc" ]; then
        echo -n 'Do you really want to erase your .bashrc ? [y/N] '
        response=$(get_word n)
        if [ "$response" == 'y' ]; then
            cp -f .bashrc "/home/$username/.bashrc"
        fi
    else
        cp -f .bashrc "/home/$username/.bashrc"
    fi
fi

# GRUB
echo -n 'Set GRUB timeout to 1 and save last boot choice [Y/n] '
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    sed 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub | sed 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved\nGRUB_SAVEDEFAULT=true/' > /etc/default/grub2
    mv -f /etc/default/grub2 /etc/default/grub
    update-grub
fi

echo
echo
echo 'Will now install all the packages.. this may take a while (20 minutes).'
echo 'DO NOT INTERRUPT THE INSTALLATION PROCESS.'
echo
echo '--- PRESS ENTER WHEN READY ---'
read

# Replace /etc/apt/sources.list & update
cp -f etc/sources.list /etc/apt/sources.list
aptitude update

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

# Sudo
aptitude -y install sudo
# The password is no more required
echo "$username	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# Less
aptitude -y install less

# uudecode (Base64)
aptitude -y install sharutils

# Network
aptitude -y install bind9-host dnsutils whois

# Unrar & unzip
aptitude -y install rar unrar unzip

# Bash completion
aptitude -y install bash-completion

# Install graphical part
aptitude -y install xserver-xorg xinit
aptitude -y install openbox python-xdg conky-std
aptitude -y install feh graphicsmagick-imagemagick-compat
aptitude -y install obmenu obconf thunar
aptitude -y install numlockx volumeicon-alsa xcalib xscreensaver tint2 wbar

# Install the terminal
aptitude -y install rxvt-unicode

# Install musical part
aptitude -y install alsa-utils
aptitude -y install sonata mpd mpc
echo 'Do not worry about MPD complaining. music_directory is not set yet.'
sed 's#^music_directory.*$#music_directory "'$mpd_zik_dir'"#' etc/mpd.conf > /etc/mpd.conf

# Autologin
aptitude -y install mingetty
sed 's/--autologin \w*/--autologin '$username'/' etc/inittab > /etc/inittab

# Propose a package to install whenever a command is not found
aptitude -y install command-not-found && echo 'Do not worry about that dude, I and I handle this.' && update-command-not-found && apt-file update

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

# Development
aptitude -y install gitk make gcc

# Development (debug tools)
aptitude -y install strace ltrace gdb

# bzip2
aptitude -y install bzip2

# Sniffer
aptitude -y install wireshark

# smartctl (for HDD health check)
aptitude -y install smartmontools

# Libreoffice
aptitude -y install libreoffice

# Eclipse
aptitude -y install eclipse

if [ $install_nvidia -eq 1 ]; then
    # Remove nouveau driver
    aptitude -y purge xserver-xorg-video-nouveau
    # Install NVIDIA proprietary drivers
    aptitude -y install nvidia-glx nvidia-xconfig && nvidia-xconfig
fi

DIFF_TIME=$(expr $(date +%s) - $START_TIME)
DIFF_min=$(expr $DIFF_TIME \/ 60)
DIFF_sec=$(expr $DIFF_TIME % 60)
echo -n 'Installation successfully completed in '
if [ $DIFF_min -gt 0 ]; then
    printf "%dm%02ds.\n" $DIFF_min $DIFF_sec
else
    printf "%02ds.\n" $DIFF_sec
fi
echo
echo
echo 'Will now reboot to let you enjoy Openbox on Debian.'
echo 'Please run `mpc update` after the reboot for your music to be loaded.'
echo 'Peace.'
echo
echo '--- PRESS ENTER TO REBOOT ---'
read
reboot
