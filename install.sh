#!/bin/bash

if [ "$USER" != 'root' ]; then
    echo 'Please run me as root.' > /dev/stderr
    exit 1
fi

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

START_TIME=$(date +%s)

# Install ViM
aptitude -y install vim-nox vim-syntax-go
clear

# Your username
username='da'
echo -n 'What is your username ['$username']? '
response=$(get_word $username)
if [ "$response" != "$username" ]; then
    username=$response
    echo 'Setting the username to "'$username'".'
fi

# Extra hosts
echo -n 'Do you want to replace your hosts file? [y/N] '
response=$(get_word N)
if [ "$response" == 'y' ]; then
    cp -f etc/hosts /etc/hosts
    echo -n 'Do you want to edit /etc/hosts now? [y/N] '
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
    echo 'Setting the music directory to "'$mpd_zik_dir'".'
fi

install_nvidia=1
echo -n 'Should we install the NVIDIA drivers ? [Y/n] '
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
echo -n 'OK, will '
if [ "$response" == 'n' ]; then
    echo -n 'not '
    use_optional=0
fi
echo 'install optional stuff.'

echo -n 'Edit the partitions from /etc/fstab? [y/N] '
response=$(get_word N)
if [ "$response" == 'y' ]; then
    echo -n 'Copy my partition table to /etc/fstab ? [Y/n] '
    response=$(get_word Y)
    if [ "$response" == 'y' ]; then
        cp -f etc/fstab /etc/fstab
        echo >> /etc/fstab

        echo -n 'Create mountpoint directories in /mnt ? [Y/n] '
        response=$(get_word Y)
        if [ "$response" == 'y' ]; then
            # Directories to be created in /mnt/
            mountpoints='canon groar nexus win win2'
            for directory in $mountpoints; do
                echo "Creating /mnt/$directory directory."
                mkdir -p "/mnt/$directory"
                echo "# /mnt/$directory" >> /etc/fstab
            done
        fi

        echo '# Set /home and / (below) + /mnt/ mountpoints (above):' >> /etc/fstab
        blkid | sed 's/^/# /gi' >> /etc/fstab
    fi

    echo
    echo
    echo 'Will now edit /etc/fstab. You can set /home + /mnt/* (your mountpoints).'
    echo '--------- PRESS ENTER WHEN READY ---------'
    read
    vi /etc/fstab

    echo -n 'Mount /home? [Y/n] '
    response=$(get_word Y)
    if [ "$response" == 'y' ]; then
        mount /home
    fi
fi

cp -f .bashrc '/root/.bashrc'
echo -n 'Copy default config. files to your $HOME? (allow overwrite) [Y/n] '
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    cp -f .wbar "/home/$username/.wbar"
    cp -f .xinitrc "/home/$username/.xinitrc"
    cp -f .xscreensaver "/home/$username/.xscreensaver"
    cp -f .xsession "/home/$username/.xsession"
    cp -f .conkyrc "/home/$username/.conkyrc"
    cp -f .vimrc "/home/$username/.vimrc"
    mkdir -p "/home/$username/.config"
    cp -rf .config/{autostart,openbox,volumeicon} "/home/$username/.config/"
    chown -R "$username" "/home/$username/.config/"
    if [ -f "/home/$username/.bashrc" ]; then
        echo -n 'Are you sure you really want to erase your $HOME/.bashrc? [y/N] '
        response=$(get_word N)
        if [ "$response" == 'y' ]; then
            cp -f .bashrc "/home/$username/.bashrc"
        fi
    else
        cp -f .bashrc "/home/$username/.bashrc"
    fi
fi

# GRUB
echo -n 'Set GRUB timeout down to 0 [Y/n] '
response=$(get_word Y)
if [ "$response" == 'y' ]; then
    sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub #/etc/default/grub2
    #sed 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub | sed 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved\nGRUB_SAVEDEFAULT=true/' > /etc/default/grub2
    #mv -f /etc/default/grub2 /etc/default/grub
    update-grub
fi
# Networking
echo -n 'Statically configure your network interface [y/N] '
response=$(get_word N)
if [ "$response" == 'y' ]; then
    cp -f etc/network/interfaces /etc/network/interfaces
fi


echo
echo
echo 'Will now install all the packages.. this may take a while (~ 20 minutes).'
echo 'DO NOT INTERRUPT THE INSTALLATION PROCESS.'
echo
echo '--------- PRESS ENTER WHEN READY ---------'
read

START_TIME2=$(date +%s)

# Replace /etc/apt/sources.list & update
cp -f etc/apt/sources.list /etc/apt/sources.list
cp -f etc/apt/apt.conf.d/80default-distrib /etc/apt/apt.conf.d/80default-distrib
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

# Graphical stuff
aptitude -y install xserver-xorg xinit
aptitude -y install openbox python-xdg conky-std
aptitude -y install feh graphicsmagick-imagemagick-compat
aptitude -y install obmenu obconf thunar
aptitude -y install numlockx volumeicon-alsa xcalib xscreensaver tint2 wbar

# Terminal
aptitude -y install rxvt-unicode

# Music: Sonata&mpc are the client, MPD is the daemon
aptitude -y install alsa-utils
aptitude -y install sonata mpd mpc
sed 's#^music_directory.*$#music_directory "'$mpd_zik_dir'"#' etc/mpd.conf > /etc/mpd.conf
echo 'Do not worry about MPD complaining: music_directory is now set.'

# Autologin
cp -r system/getty@tty1.service.d/ /etc/systemd/system/

# Propose a package to install whenever a command is not found
aptitude -y install command-not-found && echo 'Do not worry about that, I handle this.' && update-command-not-found && apt-file update

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

# Install gimp
aptitude -y install gimp

# Install hexedit
aptitude -y install hexedit

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
aptitude -y install strace ltrace gdb valgrind

# bzip2
aptitude -y install bzip2

# Calculator
aptitude -y install bc calcoo

# Gedit
aptitude -y install gedit

# Misc
aptitude -y install pwgen

# Port scanner
aptitude -y install nmap

# Sniffer
aptitude -y install tcpdump wireshark

# smartctl (for HDD health check)
aptitude -y install smartmontools

# Libreoffice
aptitude -y install libreoffice

if [ $install_nvidia -eq 1 ]; then
    # Remove nouveau driver
    aptitude -y purge xserver-xorg-video-nouveau
    # Install NVIDIA proprietary drivers
    aptitude -y install nvidia-glx nvidia-xconfig && nvidia-xconfig
fi

cp -f etc/resolv.conf /etc/resolv.conf

DIFF_TIME2=$(expr $(date +%s) - $START_TIME2)
DIFF_min2=$(expr $DIFF_TIME2 \/ 60)
DIFF_sec2=$(expr $DIFF_TIME2 % 60)
DIFF_TIME=$(expr $(date +%s) - $START_TIME)
DIFF_min=$(expr $DIFF_TIME \/ 60)
DIFF_sec=$(expr $DIFF_TIME % 60)
echo -n 'Installation successfully completed in '
if [ $DIFF_min -gt 0 ]; then
    printf "%dm%02ds" $DIFF_min $DIFF_sec
else
    printf "%02ds" $DIFF_sec
fi
if [ $DIFF_min2 -gt 0 ]; then
    printf " (core time: %dm%02ds).\n" $DIFF_min2 $DIFF_sec2
else
    printf " (core time: %02ds).\n" $DIFF_sec2
fi
echo
echo
echo 'Will now reboot to let you enjoy Openbox on Debian.'
echo 'Please run `mpc update` afterwards, for your music to be loaded into the MPD database.'
echo 'Signing off.'
echo
echo '  --------- PRESS ENTER TO REBOOT ---------'
read
reboot
