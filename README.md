debian-config: My config files to run a fresh debian (netinstall)
==============

Purpose
-------

I aim at providing a script to run on a fresh debian netinstall to let you
enjoy my lightweight GNU/Linux environment.


Provide
-------

Openbox with automatic and random fetching (from the internet) of wallpapers,
MPD (music daemon) + Sonata/mpc (GUI/cmd line), sudoers configured to no more
require the password when using sudo; see the exhaustive list below.


Preview
-------

The system will take approximately 6 GB on your SSD; reserve at least 10 GB.
All the installation process is estimated to less than half an hour.
Take a look at the result in this [screenshot file](https://raw.github.com/Amodio/debian-config/master/screenshot.png).


Installation
------------

Inscribe the current Debian 64-bit network installation ISO to an USB key:
```
wget http://ftp.debian.org/debian/dists/testing/main/installer-amd64/current/images/netboot/mini.iso
dd if=mini.iso of=/dev/sdX # Where X represents your key device, beware any mistake!
```

Boot on the USB key and Net-install the Debian; this may take ~ 6 minutes.
Login as root then fetch and install my config files (this may take ~ 20m):
```
bash -c "$(wget hydr.es/go.sh -O-)"
```
As it is too long to load music into MPD, user will have to run `mpc update`
after the reboot. Put your music in `/home/musique` (hint: use symbolic links).
You may also want to install [MPD_Notification](https://github.com/Amodio/mpd_notification):
```
cd mpd_notification
make install distclean
```

Hope you'll like it, if you miss any firmware/package you should tell me about it ;)


Exhaustive list of installed packages
-------------------------------------

### System
* sudo
* mingetty # For autologin
* screen   # To attach/detach from shareable screens
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
    * whois
* Crypto
    * cryptsetup
* Misc
    * libnotify-dev libmpdclient-dev
### Applications
* Text editor
    * vim-nox + vim-syntax-go
    * gedit
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
* Image
    * eog  # Viewer
    * gimp # Editor
* News reader
    * slrn
* IRC client
    * irssi
* Port Scanner
    * nmap
* Sniffer
    * tcpdump
    * wireshark
* Development
    * git gitk # Graphical UI for git
    * make
    * gcc
* Development (debugging tools)
    * strace & ltrace
    * gdb
    * valgrind
* Archives
    * unzip
    * rar & unrar
* Compression
    * bzip2
    * sharutils # base64
* PDF Reader
    * evince
* Calculator
    * bc
    * calcoo
* Misc
    * pwgen # Random password generator
    * hexedit # Hexadecimal editor
