debian-config: My custom Debian
==============

About
-----

Use a SSD disk storage > 20 GB. Installation estimated to < 30 min.
Take a look at the result in this [screenshot file](https://raw.github.com/Amodio/debian-config/master/screenshot.png).

You will get a fresh Debian Jessie 64-bit system (testing branch), with:
* a lightweight OpenBOX environment that automatically renews its wallpaper,
* MPD (music daemon) + Sonata/mpc (GUI/cmd line music client),
* sudoers configured to no more require the password when using sudo,
* some packages (exhaustive list below).


Installation
------------

1. Fetch then write my Debian 64-bit network installation ISO to an USB key:
```
wget -- TODO
dd if=mini.iso of=/dev/sdX # Where X represents your key device, beware any mistake!
```
You can also use Unetbootin instead of dd, especially if you are on Windows.

2. Boot on this USB key and launch the installation, this may take ~ 20 minutes.

Hope you'll like it, please feedback!


Exhaustive list of installed packages
-------------------------------------

### System
* sudo
* mingetty # For autologin
* screen   # To attach to/detach from shareable screens
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
* MTP tools # For the Galaxy Nexus on USB
    * mtp-tools
* Realtek (Ethernet card) firmware
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
    * vim-nox #+ vim-syntax-go
    * gedit
    * less
    * libreoffice libreoffice-pdfimport
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
