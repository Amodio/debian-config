# Automatically launch startx if the tty is tty1
if [ -z "$DISPLAY" -a "$(tty)" == "/dev/tty1" ]; then
  startx
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# English
#export LC_ALL='en_US.UTF-8'

#### Color
red='\033[0;31m'
RED='\033[1;31m'
green='\033[0;32m'
GREEN='\033[1;32m'
yellow='\033[0;33m'
YELLOW='033[1;33m'
blue='\033[0;34m'
BLUE='\033[1;34m'
magenta='\033[0;35m'
MAGENTA='\033[1;35m'
cyan='\033[0;36m'
CYAN='\033[1;36m'
white='\033[0;37m'
WHITE='\033[1;37m'
stopColor='\033[0m'

change_xterm_title()
{
    echo -ne "\033]2;$1\007"
}

zoom()
{
    printf '\33]50;%s\007' "xft:DejaVuSansMono:size=$1"
}

URXVT_SIZE=13
URXVT_PROGRESS_SIZE=2

zp() {
    URXVT_SIZE=$(echo "$URXVT_SIZE+$URXVT_PROGRESS_SIZE" | bc)
    zoom $URXVT_SIZE
}

zm() {
    URXVT_SIZE=$(echo "$URXVT_SIZE-$URXVT_PROGRESS_SIZE" | bc)
    zoom $URXVT_SIZE
}

# Usual env vars
export PS1="[\[$green\]\A\[$stopColor\]][\[$BLUE\]\W\[$stopColor\]]"
if [ $(whoami) = "root" ]; then
    export PS1="$PS1# "
else
    export PS1="$PS1$ "
fi
export MYSQL_PS1='(\u@\h) [\d]> '
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PATH='/usr/local/lib:/usr/lib/:/usr/local/cuda/bin/:/usr/X11/bin/:/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:/usr/games/bin:/usr/games'
export GOROOT='/usr/lib/go'
export GOPATH="$HOME/go/gocode:$GOROOT"
export GOBIN="$GOROOT/bin"
export GOOS='linux'
export GOARCH='amd64'
export GOMAXPROCS='2'
export PATH="$PATH:$GOBIN"
eval "$(dircolors -b)"

# Usual aliases
alias ls='ls --color'
alias l='ls'
alias ll='ls -l'
alias grep='grep --color'
alias reboot='sudo reboot'
alias mount='sudo mount'
alias umount='sudo umount'
alias aptitude='sudo aptitude'
alias xmms='audacious2'
alias mv='mv -i'
# mplayer -af volnorm Gran\ Torino.ac3 si c'est pas assez fort
# mplayer -playlist *.asx -dumpstream -dumpfile fugly.proprietary.stuff pour d/l un mms://
alias mplayer='mplayer -vo vdpau -ao alsa -nolirc -nojoystick'
alias dtc='sudo shutdown -h now'
alias sound_max='amixer -c 0 sset "Master,0" 100%;amixer -c 0 sset "PCM,0" 100%;mpc volume 100'
alias record="arecord -f cd --use-strftime '%d-%m-%Y_%H:%M.wav'"
alias uncrypt='umount /mnt/groar;sudo cryptdisks_stop groar'
alias crypt='sudo modprobe dm_mod;sudo cryptdisks_start groar;mount /mnt/groar;sudo bash --rcfile /mnt/groar/.aliases -i;uncrypt'
base64()
{
  local filename=$(mktemp)
  echo "begin-base64 644 /dev/stdout" > $filename
  cat $1 >> $filename
  echo "" >> $filename
  echo "end" >> $filename
  uudecode -o ${filename}_decode $filename
#rm -f $filename
}
set nobeep


# Misc aliases
alias hddtemp='sudo hddtemp /dev/sdb'
alias ntpdate="sudo ntpdate ntp.sophia.cnrs.fr;sudo hwclock -w"
alias screenshot='sleep 1;import -screen screenshot.png'
alias capture='xvidcap --gui no --file ~/capture.mpeg --frames 0 --fps 10 --cap_geometry 1280x1024+0+0'
alias val='valgrind --tool="memcheck" --leak-check=full --show-reachable=yes --track-origins=yes'
alias apt-go='aptitude autoclean;aptitude update; aptitude full-upgrade'
alias wireshark='sudo wireshark'
alias Xtremsplit='Xtremsplit --type xtm11 --coller'
alias pwgen='pwgen -s -y -1 10 5'
# curl -F file=@da nopaste.com/a
alias radio='vlc http://millepattes.ice.infomaniak.ch:80/millepattes-high.mp3 http://hd.lagrosseradio.info:8300'
alias radio2='echo http://size-radio.com; mplayer http://size.ice.infomaniak.ch/size-128.mp3'
#alias javac='javac -encoding iso-8859-15'

alias graver_audio='du -csh *.wav|tail -1;sudo cdrecord speed=2 -eject -dao -pad -audio *.wav' # for i in *.[Mm][Pp]3;do mpg123 --rate 44100 --stereo --buffer 3072 --resync -w "`basename "$i" .mp3`.wav" "$i"; done # normalize -m *.wav
alias ettercap='sudo ettercap -n 255.255.255.0 -G'
alias vncviewer='vncviewer -passwd ~/.vnc/passwd'
alias changelog="file=\"$(mktemp)\"; git --no-pager log -1 --format='%ai %aN%n%n%x09* %s%n' > $file; cat ChangeLog >> $file; diff ChangeLog $file; head -5 ChangeLog; mv -i $file ChangeLog"
alias commit='changelog;git commit -a'

# TV
alias tv3='mplayer "rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=202"'
alias tv2='mplayer "rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=201"'
alias tv2hd='mplayer "rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=201&flavour=hd"'
alias tv5='mplayer "rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=203"'
alias tvarte='mplayer "rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=204"'
alias tv="echo \"start $(date)\" >> ~/.t;vlc ~/.tv.m3u;echo \"stop `date`\" >> ~/.t"
alias tvall='vlc http://mafreebox.freebox.fr/freeboxtv/playlist.m3u'
alias nexus='sudo mtpfs -o allow_other /mnt/nexus;cd /mnt/nexus;bash;cd -;sudo umount /mnt/nexus'

# Games
alias urt='mumble-overlay ~/DIVERS/UrbanTerror/ioUrbanTerror.i386'
alias frets='~/DIVERS/FretsOnFire/FretsOnFire'
#alias quake3='mumble-overlay quake3'
#alias chess='xboard -ics -icshost freechess.org'
alias gofmt='gofmt -e -tabwidth=4 -tabs=false'
#alias sux='kill -9 $(ps aux|grep plugin|grep chrome|cut -d \  -f5,6)'
alias screen_off='xset dpms force off'

if [ "$TERM" == "rxvt-unicode" ]; then
    if [ -s ~/.TODO ]; then
        echo "TODO list:"
        echo "----------"
        cat ~/.TODO
        echo
    fi

#fortune -s
fi
#mencoder -ovc copy -oac copy -ss 0 -endpos 01:46:20 -o _Bienvenue.Chez.Les.Chtis.avi Bienvenue.Chez.Les.Chtis.avi
#mencoder -ovc x264 -oac faac -o da.avi

# Get the included files
# grep -h include *.c|sed 's/#include <\([^>]*\)>$/\1/' | sort -u
# Get the functions
alias ls_function='egrep "^\w+\s+\w*\s*\*?\w+\(" *.c | while read file; do echo "$file;"; done'
alias ls_makefile="l *c|tr -s ' '|sed 's/^/\$\(SRC_DIR\)\//g'|tr '\n' ' ';echo"
