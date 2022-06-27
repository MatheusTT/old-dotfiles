#!/bin/bash

dotfiles_path="$(realpath $(dirname "${BASH_SOURCE[@]}"))"

# Change this to "false" if you don't wanna
# install LightDM and use my config with it.
install_lightdm=true

# Small script made to redirect Spotify to
# a desktop, because bspc rule doesn't work
# with Spotify.
install_spotify_workaround=true

# Touchpad Gestures app.
install_libinput_gestures=true

# Installs my collection of wallpapers.
install_wallpapers=true

# Installing an AUR helper
if ( ! pacman -Qs "^paru" 1>/dev/null ) ; then
    cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru.git 1>/dev/null
    cd paru && makepkg -sic --noconfirm 1>/dev/null
fi

# Installing programs
sudo pacman -S --needed --noconfirm xss-lock kitty rofi feh redshift playerctl pulsemixer dunst flameshot polkit-gnome brightnessctl numlockx xorg-{setxkbmap,xset,xsetroot} nodejs-material-design-icons ttf-jetbrains-mono ttf-fira-{code,mono,sans} wget bat btop bspwm sxhkd polybar ranger papirus-icon-theme cmatrix neofetch typespeed libpulse xclip yt-dlp lsd maim nautilus

paru -S --needed --noconfirm i3lock-color-git zscroll-git picom-jonaburg-git nerd-fonts-{jetbrains-mono,fira-code} xcursor-breeze pipes.sh rxfetch pfetch thokr-git ipman spotify


# Installing oh my zsh and the plugins
## Oh My Zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
## Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Installing NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Installing ranger devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# Linking files
paths=(
  .config/BetterDiscord
  .config/bspwm
  .config/btop/btop.conf
  .config/dunst
  .config/flameshot
  .config/gtk-3.0/settings.ini
  .config/kitty
  .config/picom 
  .config/polybar
  .config/ranger/rc.conf
  .config/rofi
  .config/sxhkd
  .config/picom.conf
  .config/user-dirs.dirs
  scripts
  .aliasrc
  .gtkrc-2.0
  .p10k.zsh
  .xprofile
  .zshrc
  )

# Creating dirs
mkdir -p $HOME/.config/{btop,gtk-3.0}

# Linking files
for i in ${paths[@]} ; do
  if [[ -e $HOME/$i ]]; then
    mv $HOME/$i $HOME/$i.backup
  fi
  ln -sf $dotfiles_path/$i ~/$i 
done


## NvChad custom dir
ln -sf $dotfiles_path/.config/nvim/lua/custom ~/.config/nvim/lua/custom

## TokyoNight GTK theme
git clone https://github.com/stronk-dev/Tokyo-Night-Linux.git /tmp/tokyo-gtk
sudo cp -r /tmp/tokyo-gtk/usr/share/themes/TokyoNight /usr/share/themes/TokyoNight
rm -rf /tmp/tokyo-gtk
CURRENT_USER="$(whoami)"
sudo su -c "ln -sf /home/$CURRENT_USER/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini"
sudo su -c "ln -sf /home/$CURRENT_USER/.gtkrc-2.0 /root/.config/.gtkrc-2.0"

## Spotify Workaround
if ( $install_spotify_workaround ); then
  [[ -d $HOME/.local/bin ]] || mkdir -p $HOME/.local/bin
  [[ -d $HOME/.local/share ]] || mkdir -p $HOME/.local/share
  ln -sf $dotfiles_path/.local/bin/spotify-workaround ~/.local/bin/spotify-workaround
  ln -sf $dotfiles_path/.local/share/applications/spotify.desktop ~/.local/share/applications/spotify.desktop
fi

## LibInput Gestures
if ( $install_libinput_gestures ); then
  paru -S libinput-gestures
  ln -sf $dotfiles_path/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
  sudo usermod -a -G input $(whoami)
  libinput-gestures-setup autostart start
fi

## Configuring lightdm-gtk-greeter
if ( $install_lightdm ); then
  sudo pacman -S lightdm-gtk-greeter-settings
  sudo systemctl enable lightdm

  sudo su -c "cat << EOF > /etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
theme-name = TokyoNight
icon-theme-name = Papirus
cursor-theme-name = Breeze
cursor-theme-size = 0
font-name = Fira Sans 12
clock-format = %A, %H:%M
indicators = ~session;~layout;~spacer;~clock;~spacer;~power
EOF"
sudo sed -i "/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/" /etc/lightdm/lightdm.conf
fi

if ( $install_wallpapers ); then
  git clone https://github.com/MatheusTT/wallpapers ~/Pictures/wallpapers
fi