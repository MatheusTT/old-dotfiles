#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

#style="$($HOME/.config/rofi/applets/applets/style.sh)"

dir="$HOME/.config/rofi/applets/configs/"
rofi_command="rofi -theme $dir/network.rasi"

## Get info
IFACE="$(nmcli | grep -i interface | awk '/interface/ {print $2}')"
STATUS="$(nmcli radio wifi)"

active=""
urgent=""

if (ping -c 1 archlinux.org || ping -c 1 google.com || ping -c 1 github.com) &>/dev/null; then
	if [[ $STATUS == *"enable"* ]]; then
      active="-a 0"
      SSID="索 $(iwgetid -r)"
      connected="直"
	fi
else
    urgent="-u 0"
    SSID="Disconnected"
    connected="睊 "
fi


## Icons
launch_cli=" "
launch="󰙒"

options="$connected\n$launch_cli\n$launch"

## Main
chosen="$(echo -e "$options" | $rofi_command -p "$SSID" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $connected)
        if [[ $STATUS == *"enable"* ]]; then
			nmcli radio wifi off
		else
			nmcli radio wifi on
		fi 
        ;;
    $launch_cli)
        kitty nmtui
        ;;
    $launch)
        nm-connection-editor
        ;;
esac

