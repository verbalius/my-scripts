#!/usr/bin/env bash

# Changes theme color depending on the time of the day (uses redshift to determine)
#
# !! You MUST have XFCE, redshift, Adapta GTK theme and Papirus Icon theme installed !!
#
# You can change theme to what you want in the conf below
# To run script every 15 minutes, create a cron job using line below:
# (crontab -l 2>/dev/null ; echo "*/15 * * * * /home/mykola/.local/bin/theme_switcher.sh 2>&1") | crontab -

# ----------- Change me here! ------------- 

# 24 Hour format
# SUNRISE=8
# SUNSET=19

# Now it uses Redshift
# Modes: Daytime, Night, Transition
MODE=$(redshift -p 2>/dev/null | grep -P 'Period:\s.+' | sed 's#Period:\s##g' | sed 's#\s(.*##g')

LIGHT_THEME=Adapta
LIGHT_ICON_THEME=Papirus

DARK_THEME=Adapta-Nokto
DARK_ICON_THEME=Papirus-Dark

# Sublime-text 3 Color Scheme
LIGHT_COLOR_SCHEME="Packages/gruvbox/gruvbox (Light) (Medium).sublime-color-scheme"
DARK_COLOR_SCHEME="Packages/gruvbox/gruvbox (Dark) (Medium).sublime-color-scheme"

# -----------------------------------------

USER=mykola
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"
HOUR="$(date +"%H")"

function dark()
{
	# skip if already set up (saves resources)
	if  ! [ "$(grep -e \"$DARK_THEME\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml;)" == "" ] && \
		! [ "$(grep -e \"$DARK_ICON_THEME\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml)" == "" ] && \
		! [ "$(grep -e "gruvbox (Dark) (Medium)" /home/$USER/.config/sublime-text-3/Packages/User/Preferences.sublime-settings)" == "" ] && \
		! [ "$(grep -e "Gruvbox Dark Medium" /home/$USER/.config/VSCodium/User/settings.json)" == "" ] && \
		# ! [ "$(grep -e "Gruvbox Dark Medium" /home/$USER/.config/JetBrains/IdeaIC2020.1/options/colors.scheme.xml)" == "" ] && \
		! [ "$(grep -e "set background=dark" /home/$USER/.vimrc)" == "" ];
		then exit 0;
	fi
	
	# xfce
	/usr/bin/xfconf-query -c xsettings -p /Net/ThemeName -s "$DARK_THEME"
	/usr/bin/xfconf-query -c xfwm4 -p /general/theme -s "$DARK_THEME"
	/usr/bin/xfconf-query -c xsettings -p /Net/IconThemeName -s "$DARK_ICON_THEME"

	# sublime text 3
	sed -i -E -e 's#"color_scheme": .+$#"color_scheme": "Packages/gruvbox/gruvbox (Dark) (Medium).sublime-color-scheme",#g' /home/$USER/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
	
	# vscodium
	sed -i -E -e 's#"workbench.colorTheme": .+$#"workbench.colorTheme": "Gruvbox Dark Medium",#g' /home/$USER/.config/VSCodium/User/settings.json

	# vim theme
	sed -i -E -e 's#set background=.*#set background=dark#g' /home/$USER/.vimrc

	# # IDEA theme
	# sed -i -E -e 's#<global_color_scheme name=".+$#<global_color_scheme name="Gruvbox Dark Medium" />#g' /home/$USER/.config/JetBrains/IdeaIC2020.1/options/colors.scheme.xml
	

	# Kvantum aka QT apps
	sed -i -E -e 's#theme=.+$#theme=KvAdaptaDark#g' /home/$USER/.config/Kvantum/kvantum.kvconfig
} 

function light()
{
	# skip if already set up (saves resources)
	if  ! [ "$(grep -e \"$LIGHT_THEME\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml;)" == "" ] && \
	 	! [ "$(grep -e \"$LIGHT_ICON_THEME\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml)" == "" ] && \
		! [ "$(grep -e "gruvbox (Light) (Medium)" /home/$USER/.config/sublime-text-3/Packages/User/Preferences.sublime-settings)" == "" ] && \
		! [ "$(grep -e "Gruvbox Light Medium" /home/$USER/.config/VSCodium/User/settings.json)" == "" ] && \
		# ! [ "$(grep -e "Gruvbox Light Medium" /home/$USER/.config/JetBrains/IdeaIC2020.1/options/colors.scheme.xml)" == "" ] && \
		! [ "$(grep -e "set background=light" /home/$USER/.vimrc)" == "" ];
		then exit 0;
	fi

	# xfce
	/usr/bin/xfconf-query -c xsettings -p /Net/ThemeName -s "$LIGHT_THEME"
	/usr/bin/xfconf-query -c xfwm4 -p /general/theme -s "$LIGHT_THEME"
	/usr/bin/xfconf-query -c xsettings -p /Net/IconThemeName -s "$LIGHT_ICON_THEME"
	
	# sublime text 3
	sed -i -E -e 's#"color_scheme": .+$#"color_scheme": "Packages/gruvbox/gruvbox (Light) (Medium).sublime-color-scheme",#g' /home/$USER/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
	
	# vscodium
	sed -i -E -e 's#"workbench.colorTheme": .+$#"workbench.colorTheme": "Gruvbox Light Medium",#g' /home/$USER/.config/VSCodium/User/settings.json

	# vim theme
	sed -i -E -e 's#set background=.*#set background=light#g' /home/$USER/.vimrc

	# # IDEA theme
	# sed -i -E -e 's#<global_color_scheme name=".+$#<global_color_scheme name="Gruvbox Light Medium" />#g' /home/$USER/.config/JetBrains/IdeaIC2020.1/options/colors.scheme.xml

	# Kvantum aka QT apps
	sed -i -E -e 's#theme=.+$#theme=KvAdapta#g' /home/$USER/.config/Kvantum/kvantum.kvconfig
}

#Hour of Sunrise
if [ $MODE == "Transition" ] && [ $HOUR -lt 12 ]; # Less than noon
then
	if  ! [ "$(grep -e \"sunrise\.jpg\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml;)" == "" ];
	then
		exit 0;
	fi
	# wallpaper sunrise
	/usr/bin/xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorLVDS-1/workspace0/last-image --set "/home/$USER/.local/share/dynamic_wallpaper/sunrise.jpg"
	light; # set global light mode

# Hour of sunset
elif [ $MODE == "Transition" ] && [ $HOUR -gt 12 ]; # Greater than noon
then
	if  ! [ "$(grep -e \"sunset\.jpg\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml;)" == "" ];
	then
		exit 0;
	fi
	# wallpaper sunset 
	/usr/bin/xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorLVDS-1/workspace0/last-image --set "/home/$USER/.local/share/dynamic_wallpaper/sunset.jpg"
	dark; # set global dark mode

# Night
elif [ $MODE == "Night" ]; #$HOUR -gt $SUNSET ] || [ $HOUR -lt $SUNRISE ]
then
	if  ! [ "$(grep -e \"night\.jpg\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml;)" == "" ];
	then
		exit 0;
	fi
	# wallpaper night
	/usr/bin/xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorLVDS-1/workspace0/last-image --set "/home/$USER/.local/share/dynamic_wallpaper/night.jpg"
	dark; # set global dark mode

# Day
elif [ $MODE == "Daytime" ]; #$HOUR -gt $SUNRISE ] || [ $HOUR -lt $SUNSET ]
then
    if ! [ "$(grep -e \"day\.jpg\" /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml;)" == "" ];
	then
		exit 0;
	fi
	# wallpaper day
	/usr/bin/xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorLVDS-1/workspace0/last-image --set "/home/$USER/.local/share/dynamic_wallpaper/day.jpg"
	light; # set global light theme
fi