debian-config: My config files to run a fresh debian (netinstall)
==============

Purpose
-------

I aim at providing a script to run on a fresh debian netinstall (without the
graphical environment, etc) in order to let you enjoy a lightweight linux
environment.


Hidden purpose
--------------

There is no dark side like a mass-backdooring idea, there are more efficient
ways for that ;p


Provide
-------

Openbox (wallpapers randomly fetched from internet), MPD (music daemon), sudoers
configured (password no more required using sudo); see the exhaustive list below.


Preview
-------

The system will take approximately 4 GB on your SSD; reserve 6 to 10 GB.
The installation process is estimated to less than half an hour.
Take a look at the result in the [screenshot file](https://raw.github.com/Amodio/debian-config/master/screenshot.png).


Installation
------------

Prepare an USB key to erase (you will have to boot on it):
```
wget http://ftp.debian.org/debian/dists/testing/main/installer-amd64/current/images/netboot/mini.iso
dd if=mini.iso of=/dev/sdX # Where X represents your key device
```

Net-install Debian (without anything); this may take ~ 6 minutes.
Login as root then fetch and install my config files (this may take ~ 20m):
```
bash -c "$(wget http://hydrupload.info/go.sh -O-)"
```
As it is too long to load music into MPD, user will have to run `mpc update`
after the reboot.

Hope you'll like it; I enjoy feedbacks (bugs, program to add, etc) :-)


Exhaustive list of installed packages
-------------------------------------

### System
* sudo
* mingetty # For autologin
* screen   # To attach/detach from screens (can be shared)
* bash-completion
* command-not-found # Tell which pkg to install
* smartmontools     # smartctl (for HDD health check)
* X server
    * xserver-xorg xinit
    * openbox python-xdg conky-std
    * feh graphicsmagick-imagemagick-compat
    * obmenu obconf thunar
    * numlockx volumicon-alsa xcalib xscreensaver tint2 wbar
* Sound
    * alsa-utils
    * sonata mpd mpc
* NVIDIA Drivers # IF install_nvidia=1
    * nvidia-glx nvidia-xconfig
* MTP tools # IF use_optional=1, for the Galaxy Nexus on USB
    * mtp-tools
* Realtek (Ethernet card) firmware # IF use_optional=1
    * firmware-realtek
* Network
    * bind9-host # For host
    * dnsutils   # For dig

### Applications
* Text editor
    * vim + vim-syntax-go
    * less
    * libreoffice (the complete suite)
* Terminal
    * rxvt-unicode
* Web browsers
    * iceweasel # Firefox
    * Google Chrome 64 bits
* Video players
    * vlc
    * mplayer
* FTP Client
    * lftp
* Image Viewer
    * eog
* News reader
    * slrn
* IRC client
    * irssi
* Sniffer
    * wireshark
* Development
    * git gitk # Graphical UI for git
    * make
    * gcc
    * eclipse
* Archives
    * unzip
    * rar & unrar
* Compression
    * bzip2
    * sharutils # For base64 decoding (uudecode)
