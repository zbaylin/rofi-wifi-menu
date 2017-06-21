#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
nmcli dev wifi rescan


LIST=$(nmcli --fields "IN-USE,ssid,security,mode,signal,bars" device wifi list)
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ LINENUM > 8 ]; then
	LINENUM=8
fi


CHENTRY=$(echo -e "manual\n$LIST" | sed '/--/,+1 d' | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines $LINENUM -font "DejaVu Sans Mono 8" -width -$RWIDTH)
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $2}')
#echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "manual" ] ; then
	# Manual entry of the SSID and password (if appplicable)
	MSSID=$(echo "enter the SSID of the network (SSID,password)" | rofi -dmenu -p "Manual Entry: " -font "DejaVu Sans Mono 8" -lines 1)
	# Separating the password from the entered string
	MPASS=$(echo $MSSID | awk -F "," {'print $2'})
	
	#echo "$MSSID"
	#echo "$MPASS"

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

else

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ "$KNOWNCON" =~ "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " -lines 1 -font "DejaVu Sans Mono 8" )
		fi
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi