#!/bin/sh
#if test ping -c1 -W2 plum >/dev/null 2>&1
#then
#    if ! mount|grep -q skyrta; then echo sudo /sbin/mount /skyrta/; fi
#fi

xrdb -merge ~/.Xresources

xset m 7/10 1
xset r rate 300 21

#xset dpms 300 0 0
xset -dpms
xset s off

xset b on
xset b 50 800 120

#setxkbmap -model pc104 -layout "us,ua" -option "grp:rwin_toggle"
setxkbmap -model pc104 -layout "us,ua" -option "grp:menu_toggle"

xsetroot -cursor_name left_ptr

mixer vol 100
mixer pcm 100
mixer treble 90
mixer bass 60
mixer rec 80
mixer mic 70
mixer line 90
mixer speaker 0
mixer mix 0
mixer igain 0
mixer ogain 0

if test -n "$MNXTEST"
then
    exec $HOME/development/mnwm/test/testfoo r
else
    #exec /data1/mkushnir/development/dwm/dwm
    #exec /usr/local/bin/ctwm --single --nowelcome -f $HOME/.ctwm/.ctwmrc

    #cairo-dock -o &
    #exec /usr/local/bin/lxsession -a


    #exec /usr/local/bin/enlightenment_start
    #exec /usr/local/bin/startxfce4
    #exec /usr/local/bin/openbox-session
    #exec /usr/local/bin/startlxde
    #exec /usr/local/bin/start-lumina-desktop
    #exec /usr/local/bin/sawfish
    #
    #exec xterm -n login

    ##xclock -digital -strftime '%A %d %b %H:%M' -bg black -fg white -geometry "220x24-0-0" -padding 4 -chime -render &
    ##xclock -digital -strftime '%A %d %b %H:%M' -bg black -fg white -geometry "220x24-0-0" -padding 4 -render &
    xclock -bg black -fg white -geometry "80x80-0-0" -chime -render &
    exec /usr/local/bin/twm
fi
