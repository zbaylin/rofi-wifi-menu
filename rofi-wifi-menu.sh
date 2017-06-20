#!/usr/bin/env bash

nmcli dev wifi rescan

LIST=$(nmcli --fields "IN-USE,ssid,security,mode,signal,bars" device wifi list)
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
echo $RWIDTH
LINENUM=$(echo "$LIST" | wc -l)
KNOWNCON=$(nmcli connection show)

if [ LINENUM > 8 ]; then
	LINENUM=8
fi


CHENTRY=$(echo "$LIST" | sed '/--/,+1 d' | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines $LINENUM -font "DejaVu Sans Mono 8" -width -$RWIDTH)
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $2}')
#echo "$CHSSID"

#if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
#	WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password:  " -lines 1 -font "DejaVu Sans Mono 8" )
#fi

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


# nmcli con up "$CHSSID" || nmcli dev wifi con "$CHSSID" password "$WIFIPASS"