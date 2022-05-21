#!/bin/bash

dotfiles_path="$( dirname "${BASH_SOURCE[0]}" )"

# Change this to "false" if you don't wanna
# install LightDM and use my config with it.
install_lightdm=true

# installing an AUR helper
if ( ! pacman -Qs "^paru" 1>/dev/null ) ; then
    cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru.git 1>/dev/null
    cd paru && makepkg -sic --noconfirm 1>/dev/null
fi

# installing programs
sudo pacman -S --needed --noconfirm xss-lock kitty rofi feh redshift playerctl pulsemixer dunst \
  flameshot polkit-gnome brightnessctl numlockx xorg-{setxkbmap,xset,xsetroot} \
  nodejs-material-design-icons ttf-jetbrains-mono ttf-fira-{code,mono,sans} wget bat btop \
  bspwm sxhkd polybar ranger papirus-icon-theme cmatrix neofetch typespeed libpulse xclip yt-dlp lsd

paru -S --needed --noconfirm i3lock-color-git zscroll-git picom-jonaburg-git nerd-fonts-{jetbrains-mono,fira-code} \
  xcursor-breeze pipes.sh rxfetch pfetch thokr-git ipman


# installing oh my zsh and the plugins
# Oh My Zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# installing NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# installing ranger devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# linking files
paths=(
  .config/BetterDiscord
  .config/bspwm
  .config/btop/btop.conf
  .config/dunst
  .config/flameshot
  .config/kitty
  .config/picom 
  .config/polybar
  .config/ranger/rc.conf
  .config/rofi
  .config/sxhkd
  .config/picom.confi
  .config/user-dirs.dirs
  scripts
  .aliasrc
  .p10k.zsh
  .xprofile
  .zshrc
  )

for i in ${paths[@]} ; do
  ln -sf $dotfiles_path/$i ~/$i 
done

# NvChad custom/chadrc.lua and TokyoNight GTK theme 
ln -sf $dotfiles_path/.config/nvim/lua/custom ~/.config/nvim/lua/custom

temp_tokyo_path="/tmp/tokyo-gtk"
git clone https://github.com/stronk-dev/Tokyo-Night-Linux.git $temp_tokyo_path
sudo cp -r $temp_tokyo_path/usr/share/themes/TokyoNight /usr/share/themes/TokyoNight
rm -rf $temp_tokyo_path

# configuring lightdm-gtk-greeter
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
background = /usr/share/pixmaps/beach.jpg
user-background = false
EOF"
fi
