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
configured (password no more required using sudo); see `install.sh` for more.


Preview
-------

The system will take approximately 3 GB on your SSD; reserve 6 to 10 GB.
Take a look at the result in the screenshot file: `screenshot.jpg`.


Installation
------------

Prepare an USB key to erase (you will have to boot on it):
```
wget http://ftp.debian.org/debian/dists/testing/main/installer-amd64/current/images/netboot/mini.iso
dd if=mini.iso of=/dev/sdX # X Where X represents your key device
```

Net-install Debian (without the graphical environment). Then fetch install files:
```
aptitude install unzip
wget https://github.com/Amodio/debian-config/archive/master.zip
unzip master.zip
cd debian-config-master
./install.sh
```
As it is too long to load music into MPD, user will have to run `mpc update`
after the reboot.

Hope you'll like it; I enjoy feedbacks (bugs, program to add, etc) :-)
