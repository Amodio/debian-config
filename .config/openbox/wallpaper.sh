#!/bin/bash

# We download 4 wallpapers in a row
n_preload=4

# There are 14 wallpapers in a list
n_list=14

walldir="$HOME/.config/openbox/wallpapers"
random_wallpapers_file="$walldir/random_wallpapers.html"
current_file="$walldir/current"
list_file="$walldir/list"
current_line_list_file="$walldir/current_line"

# Hack to bypass a bug in wbar
reload_wbar()
{
    killall wbar
    sleep 1
    cd
    wbar -above-desk -isize 64 -zoomf 1 -nanim 1 -bpress -balfa 0 > /dev/null 2>&1 &
    cd -
}

# Print the number of lines of a file
get_n_lines()
{
    local ret=0
    if [ ! -s "$1" ]; then
        local ret=1
        echo 0
    else
        wc -l "$1" | cut -d ' ' -f1
    fi
    return $ret
}

# Wicked func' giving infinite links to HD wallpapers
get_next_link()
{
    if [ ! -s "$list_file" ]; then
        rm -f "$random_wallpapers_file"
        wget -q "http://www.hdwallpapers.org/random-wallpapers.html" -O "$random_wallpapers_file"
        if [ $? -ne 0 ] || [ ! -s "$random_wallpapers_file" ]; then
            echo "Cannot fetch wallpapers" > /dev/stderr
            # Stop the program here, do not cycle change the wallpaper
            exit 1
        fi
        rm -f "$list_file"
        grep '<div class="thumb">' "$random_wallpapers_file" | sed 's#^<div class="thumb"><a href="##' | grep -oe '[^"]*\.html' | sed 's/-wallpapers.html$//' > "$list_file"
        local list_lines=$(get_n_lines "$list_file")
        if [ $? -ne 0 ] || [ $list_lines -eq 0 ]; then
            echo "Cannot fetch list of wallpapers" > /dev/stderr
            # Stop the program here, do not cycle change the wallpaper
            exit 2
        elif [ $list_lines -ne $n_list ]; then
            echo "We fetched $list_lines, expected $n_list." > /dev/stderr
            # Stop the program here, do not cycle change the wallpaper
            # That is harsh! Life is as radical.
            exit 2
        fi
        # Reinit line counter in the list
        echo 0 > "$current_line_list_file"
    fi
    # Fetch current_line_list
    current_line_list=$(cat "$current_line_list_file" 2> /dev/null)
    ((current_line_list++))
    # Update current_line_list
    echo $current_line_list > "$current_line_list_file"
    local da=$(head -n "$current_line_list" "$list_file" | tail -1)
    echo "http://www.hdwallpapers.org/download/$da-1920x1080.jpg"
    # Delete the now done list
    if [ $current_line_list -eq $(wc -l "$list_file" | awk '{print $1}') ]; then
        rm -f "$list_file"
    fi
}

# Download wallpapers: $i.jpg from $1 to $1 + $n_preload
download_wallpapers()
{
    local i=$1
    local j=1
    while [ $j -le $n_preload ]; do
        local tmp_wallpaper_file="$walldir/_$i.jpg"
        local wallpaper_file="$walldir/$i.jpg"
        wget -q "$(get_next_link)" -O "$tmp_wallpaper_file"
        if [ $? -eq 0 ] && [ -s "$tmp_wallpaper_file" ]; then
            identify "$tmp_wallpaper_file" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                mv -f "$tmp_wallpaper_file" "$wallpaper_file"
                local j=$(expr $j + 1)
                local i=$(expr $i + 1)
            fi
            rm -f "$tmp_wallpaper_file"
        fi
    done
}

current=$(cat $current_file 2>/dev/null)
# First call
if [ $? -ne 0 ] || [ $current -gt 0 -a ! -s "$walldir/$current.jpg" ]; then
    # Set the default wallpaper (when none has been downloaded yet)
    ret_val=$(feh --bg-scale "$walldir/sunset_in_tuscany-1920x1080.jpg")
    reload_wbar
    # Initialize the wallpaper counter
    echo 0 > $current_file
    # Download wallpapers: $i.jpg from 1 to n_preload
    download_wallpapers 1
    exit $ret_val
fi

# Cycle when reaching the end
if [ $current -ge $n_list ]; then
    # Move wallpapers to the begining (starting from 1) and delete old ones
    j=1
    for ((i=$current + 1; ; i++)); do
        tmp_wallpaper_file="$walldir/$i.jpg"
        wallpaper_file="$walldir/$j.jpg"
        if [ ! -s "$tmp_wallpaper_file" ]; then
            break
        fi
        mv -f "$tmp_wallpaper_file" "$wallpaper_file"
        ((j++))
    done
    for ((; ; j++)); do
        wallpaper_file="$walldir/$j.jpg"
        if [ ! -s "$wallpaper_file" ]; then
            break
        fi
        rm -f "$wallpaper_file"
    done
    current=1
else
    ((current++))
fi

# Update the current wallpaper counter
echo $current > $current_file

# Set the wallpaper
ret_val=$(feh --bg-scale "$walldir/$current.jpg" 2> /dev/null)
reload_wbar

# The last wallpaper n° that is free to use
free_file=1
while true; do
    if [ ! -s "$walldir/$free_file.jpg" ]; then
        if [ $free_file -eq 1 ]; then
            echo "No wallpaper found." > /dev/stderr
            exit 1
        fi
        break
    else
        ((free_file++))
    fi
done

n_wallpapers=$(/bin/ls $walldir/[0-9]*.jpg 2> /dev/null| wc -l)
# If the number of wallpapers left is lower than n_preload, download some more
if [ $(expr $n_wallpapers - $current) -le $n_preload ]; then
    download_wallpapers $free_file
    exit $ret_val
fi

exit $ret_val
