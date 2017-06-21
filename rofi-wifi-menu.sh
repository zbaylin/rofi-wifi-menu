#!/usr/bin/env bash

nmcli dev wifi rescan

LIST=$(nmcli --fields "IN-USE,ssid,security,mode,signal,bars" device wifi list)
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# echo $RWIDTH
LINENUM=$(echo "$LIST" | wc -l)
KNOWNCON=$(nmcli connection show)

if [ LINENUM > 8 ]; then
	LINENUM=8
fi


CHENTRY=$(echo -e "manual\n$LIST" | sed '/--/,+1 d' | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines $LINENUM -font "DejaVu Sans Mono 8" -width -$RWIDTH)
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $2}')
#echo "$CHSSID"

if [ "$CHENTRY" = "manual" ]; then
	MSSID=$(echo "enter the SSID of the network (SSID,password)" | rofi -dmenu -p "Manual Entry: " -font "DejaVu Sans Mono 8" -lines 1)
	MPASS=$(echo $MSSID | awk -F "," {'print $2'})
	echo "$MSSID"
	echo "$MPASS"
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

else

	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	if [[ "$KNOWNCON" =~ "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " -lines 1 -font "DejaVu Sans Mono 8" )
		fi
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi
# nmcli con up "$CHSSID" || nmcli dev wifi con "$CHSSID" password "$WIFIPASS"