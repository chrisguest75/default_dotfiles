#!/usr/bin/env bash 
#Use !/bin/bash -x  for debugging 

echo $DISPLAY                                                                                    
export DISPLAY=:0
dbus-launch --exit-with-session gsettings set org.gnome.Vino enabled true
dbus-launch --exit-with-session gsettings set org.gnome.Vino prompt-enabled false
dbus-launch --exit-with-session gsettings set org.gnome.Vino require-encryption false
/usr/lib/vino/vino-server