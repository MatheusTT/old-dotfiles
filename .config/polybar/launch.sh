#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Updates module (comment if not using Arch)
export TOTAL_PKGS="%{T5} %{T-}$(awk '/total/ { print $2 }' ~/.cache/.updates_available)"
export PACMAN_PKGS="󰮯 $(awk '/pacman/ { print $2 }' ~/.cache/.updates_available)"
export AUR_PKGS="󰣇 $(awk '/aur/ { print $2 }' ~/.cache/.updates_available)"
export FLATPAK_PKGS="󰏗 $(awk '/flatpak/ { print $2 }' ~/.cache/.updates_available)"

# Battery porcentage that can be modified by ~/scripts/module
# (change this to "100%" if you don't use a ideapad laptop)
export BATTERY="$(cat ~/.cache/.poly_battery)"

# Launch example bar
echo "---" | tee -a /tmp/polybar.log
polybar example 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched..."
