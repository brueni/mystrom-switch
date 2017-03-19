#!/bin/bash
cd `dirname $0`

#Control a myStrom.ch Smarthome-Switch with this script
#Usage: switch.sh <ip> <on/off/status>

if [ "$2" = "on" ]; then
	curl --silent http://$1/relay?state=1
	echo $2 > state_$1.txt
elif [ "$2" = "off" ]; then
	curl --silent http://$1/relay?state=0
	echo $2 > state_$1.txt
elif [ "$2" = "toggle" ]; then
	report=`curl --silent http://$1/report`
	if [[ $report == *"true"* ]]; then
		echo "jetzt an, schalte aus"
		curl --silent http://$1/relay?state=0
		echo "off" > state_$1.txt
	else
		echo "jetzt aus, schalte an"
		curl --silent http://$1/relay?state=1
		echo "on" > state_$1.txt
	fi
else
	report=`curl --silent http://$1/report`
	#Find the position of ,
	pos_komma=$(echo $report | grep -aob ',' | grep -oE '[0-9]+')
	#Calculate length of power-value
	powerlen=$(expr $pos_komma - 11)
	power=${report:12:$powerlen}
	echo $power > state_watt_$1.txt
	if [[ $report == *"true"* ]]; then
		echo "on" > state_$1.txt
	else
		echo "off" > state_$1.txt
	fi
fi

cp state_$1.txt /var/www/states/light_$1.txt
cp state_watt_$1.txt /var/www/states/light_watt_$1.txt
