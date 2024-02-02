#!/bin/bash


#===========YAY AUR HELPER INSTALLATION===========#
if ! command -v yay &> /dev/null; then
    sudo pacman -Sy --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && clear && cd .. && rm -rf yay
fi


#===========APPS AND DEPENDENCIES DOWNLOAD=========#
if ! command -v git &> /dev/null; then
    sudo pacman -Sy --noconfirm git
fi
sudo pacman -Sy tilix mpv ranger rofi waybar zsh curl neovim grim slurp wl-clipboard qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects dconf
yay --answerclean All --answerdiff None -Sy --noconfirm ueberzugpp mpvpaper
if [ ! -f "$HOME/.local/share/fonts/fonts/ttf/JetBrainsMono-Bold.ttf" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
fi

#===================THEMES==============#
if [ ! -d "$HOME/.themes" ]; then 
    mkdir $HOME/.themes
fi
if [ ! -d "$PWD/Themes/Graphite-gtk-theme" ]; then
    git clone https://github.com/vinceliuice/Graphite-gtk-theme.git $PWD/Themes/Graphite-gtk-theme
fi
./Themes/Graphite-gtk-theme/install.sh
gsettings set org.gnome.desktop.interface icon-theme Graphite-Dark
if [ -d "$HOME/.config/gtk-3.0" ]; then 
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Graphite-Dark/' "$HOME/.config/gtk-3.0/settings.ini"
else 
    cp -rf "$PWD/Configs/gtk-3.0" $HOME/.config/
fi


#===========SDDM THEME============#
if [ ! -d "/usr/share/sddm" ]; then 
    sudo mkdir /usr/share/sddm
fi
if [ ! -d "/usr/share/sddm/themes" ]; then
    sudo mkdir /usr/share/sddm/themes
fi
if [ ! -d "$PWD/Themes/where_is_my_sddm_theme" ]; then
    git clone https://github.com/stepanzubkov/where-is-my-sddm-theme $PWD/Themes/where_is_my_sddm_theme
fi
if [ ! -d "/usr/share/sddm/themes/where_is_my_sddm_theme" ]; then
    sudo cp -rf $PWD/Themes/where_is_my_sddm_theme /usr/share/sddm/themes/
fi
if [ -f "/etc/sddm.conf" ]; then 
    sudo sed -i 's/Current=.*/Current=where_is_my_sddm_theme/' /etc/sddm.conf
else 
    sudo cp -rf $PWD/Configs/sddm/sddm.conf /etc/
fi


#===========HYPRLAND && HYPRPAPER CONFIGS===========#
if [ -d "$HOME/.config/hypr" ]; then
    mv -f $HOME/.config/hypr $PWD/Backups/
fi
cp -rf $PWD/Configs/hypr $HOME/.config/


#===========TILIX TERMINAL CONFIGS=============#
if ! command -v tilix &> /dev/null; then
    dconf dump /com/gexperts/Tilix/ > $PWD/Backups/tilix_config.txt;
fi
dconf load /com/gexperts/Tilix/ < $PWD/Configs/tilix/tilix_config.txt


#================RANGER CONFIGS================#
if [ -d "$HOME/.config/ranger" ]; then
    mv -f $HOME/.config/ranger $PWD/Backups/
fi
cp -rf $PWD/Configs/ranger $HOME/.config/


#================WAYBAR CONFIGS================#
if [ -d "$HOME/.config/waybar" ]; then
    mv -f $HOME/.config/waybar $PWD/Backups/
fi
cp -rf $PWD/Configs/waybar $HOME/.config/


#================ROFI CONFIGS================#
if [ -d "$HOME/.config/rofi" ]; then
    mv -f $HOME/.config/rofi $PWD/Backups/
fi
mkdir $HOME/.config/rofi
git clone --depth=1 https://github.com/adi1090x/rofi.git $PWD/Configs/rofi
cd $PWD/Configs/rofi 
chmod a+x setup.sh
./setup.sh
if [ -f "$HOME/.config/rofi/launchers/type-2/shared/colors.rasi" ]; then 
    mv -f $HOME/.config/rofi/launchers/type-2/shared/colors.rasi $PWD/Backups/
fi
cd ..
cd ..
sed -i 's/theme=.*/theme=style-7/' $HOME/.config/rofi/launchers/type-2/launcher.sh
cp -f $PWD/Configs/Rofi_user_configs/colors.rasi $HOME/.config/rofi/launchers/type-2/shared/
cp -f $PWD/Configs/Rofi_user_configs/launcher_run.sh $HOME/.config/rofi/launchers/type-2/


#================NEOFETCH CONFIGS================#
if [ -d "$HOME/.config/neofetch" ]; then
    mv -f $HOME/.config/neofetch $PWD/Backups/
fi
cp -rf $PWD/Configs/neofetch $HOME/.config/


#================WALLPAPERS IMAGES================#
if [ ! -d "$HOME/Pictures" ]; then
    mkdir $HOME/Pictures
fi
if [ ! -d "$HOME/Pictures/Wallpapers" ]; then
    mkdir $HOME/Pictures/Wallpapers
fi
cp -rf $PWD/Wallpapers/Static/* $HOME/Pictures/Wallpapers/


#================WALLPAPERS VIDEOS================#
if [ ! -d "$HOME/Videos" ]; then
    mkdir $HOME/Videos
fi
if [ ! -d "$HOME/Videos/Animated_wallpapers" ]; then
    mkdir $HOME/Videos/Animated_wallpapers
fi
cp -rf $PWD/Wallpapers/Animated/* $HOME/Videos/Animated_wallpapers/


#================ZSH AND OH_MY_ZSH INSTALLATION================#
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#================ZSH AND OH_MY_ZSH CONFIGS================#
if [ -d "$HOME/.config/zsh" ]; then
    mv -f $HOME/.config/zsh $PWD/Backups/
fi
if [ -f "$HOME/.zshrc" ]; then
    mv -f $HOME/.zshrc $PWD/Backups/
fi
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp -rf $PWD/Configs/zsh $HOME/.config/
cp -rf $PWD/Configs/Home_Configs_Files/.zshrc $HOME/


#================THE END================#
clear 
echo "Everything Done! Tkx for Eating My Rice. :3"
echo "i recommend one system reboot to everything start with the new configuration"

