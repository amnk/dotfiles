#!/bin/bash
# 
# xmonad "startup hook" script. This gets run after xmonad is initialized,
# via the startupHook facility provided by xmonad.

PATH=~/.cabal/bin:~/.xmonad/bin:$PATH

# nm-applet
if [ -z "$(pgrep -f nm-applet)" ] ; then
    nm-applet &
fi

# dropbox
DROPBOX_STATUS=`~/dropbox.py status`

if [ "$DROPBOX_STATUS" = "Dropbox isn't running!" ] ; then
    ~/dropbox.py start
fi

if [ -z "$(pgrep -f gtk-redshift)" ] ; then
    /usr/bin/gtk-redshift -l manual lat=37.40 long=-122.00 -t 5500:4200 &
fi

if [ -z "$(pgrep -f kbdd)" ] ; then
        /usr/bin/kbdd
fi

setxkbmap "us,ru" -option grp:caps_toggle

if [ -z "$(pgrep -f taffybar)" ] ; then
    ~/.cabal/bin/taffybar &
fi

# See this reddit link for some details about compton:
# https://www.reddit.com/r/linux/comments/1dnr2l/using_compton_for_simple_tearfree_compositing_in/
if [ -z "$(pgrep compton)" ] ; then
     compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc  -b
fi

#if [ -z "$(pgrep -f xscreensaver)" ] ; then
#    xscreensaver -nosplash &
#fi
