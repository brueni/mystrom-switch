#!/bin/bash
cd `dirname $0`

#Control a myStrom.ch Smarthome-Switch with this script
#Usage: switch.sh <ip> <on/off/status>

if [ "$2" = "on" ]; then
	curl --silent http://$1/relay?state=1
	echo $2 > state_$1.txt
else
	curl --silent http://$1/relay?state=0
	echo $2 > state_$1.txt
fi

cp state_$1.txt /var/www/states/light_$1.txt
