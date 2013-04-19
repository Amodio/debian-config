debian-config: My config files to run a fresh debian (netinstall)
==============

Preview
-------

Take a look at the result in the screenshot file: `screenshot.jpg`.


Installation
------------

Prepare an USB key to erase (you will have to boot on it):
```
wget http://ftp.debian.org/debian/dists/testing/main/installer-amd64/current/images/netboot/mini.iso
dd if=mini.iso of=/dev/sdX # X Where X represents your key device
```

Net-install Debian (without the graphical environment but with the OpenSSH
server). Then fetch my config files like this:
```
wget https://github.com/Amodio/debian-config/archive/master.zip
aptitude install unzip
unzip master.zip
```
Finally, read the `INSTALL` file.

Hope you'll like it; I enjoy feedbacks (bugs, etc) :-)
