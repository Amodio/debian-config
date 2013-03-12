#!/bin/bash

# We download (and store) 14 wallpapers at once
n=14

walldir="$HOME/.config/openbox/wallpapers"
list_file="$walldir/list"
current_file="$walldir/current"
current=$(cat $current_file 2>/dev/null)
if [ $? -ne 0 ]; then
    current=$(expr $n + 1)
    # Set the default wallpaper (when none has been downloaded yet)
    feh --bg-scale "$walldir/sunset_in_tuscany-1920x1080.jpg"
else
    ((current++))
fi

download_wallpapers()
{
    rm -f "$walldir/random_wallpapers.html"
    wget -q "http://www.hdwallpapers.in/random_wallpapers.html" -O "$walldir/random_wallpapers.html"
    if [ $? -ne 0 ] || [ ! -s "$walldir/random_wallpapers.html" ]; then
        echo "Cannot fetch wallpapers" 2>/dev/stderr
        # Stop the program here, do not cycle change the wallpaper
        exit 1
    fi
    rm -f "$list_file"
    grep 'ul class="wallpapers"' "$walldir/random_wallpapers.html" | sed 's#<li class="wall" ><div class="thumbbg"><div class="thumb"><a href="/#\n#g' |grep -oe '[^"]*\.html'|sed 's/-wallpapers.html$//' > "$list_file"
    list_lines=$(wc -l "$list_file" | awk '{print $1}')
    if [ $? -ne 0 -o $list_lines -eq 0 ]; then
        echo "Cannot fetch list of wallpapers" 2>/dev/stderr
        exit 2
    elif [ $list_lines -ne $n ]; then
        echo "We fetched $list_lines != $n!" 2>/dev/stderr
        n=$list_lines
    fi

    i=1
    for da in $(cat "$list_file"); do
        wget -q "http://www.hdwallpapers.in/download/$da-1920x1080.jpg" -O "$walldir/_$i.jpg"
        if [ $? -eq 0 ] && [ -s "$walldir/_$i.jpg" ]; then
            identify "$walldir/_$i.jpg" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                mv -f "$walldir/_$i.jpg" "$walldir/$i.jpg"
                ((i++))
            fi
        fi
    done
    for ((j=$i; $j <= $n; j++)); do
        # Remove old wallpapers
        rm -f "$walldir/$j.jpg"
    done

    if [ $i -eq 1 ]; then
        # Wow, the 14 wallpapers were not available in this resolution
        exit 3
    fi
}

if [ $current -eq $(expr $n + 1) ] || [ ! -s "$walldir/$current.jpg" ]; then
    download_wallpapers
    current=1
fi

# Update the current wallpaper counter
echo $current > $current_file

# Set the wallpaper
feh --bg-scale "$walldir/$current.jpg"
