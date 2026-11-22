#!/bin/bash

########################################################
# CONFIGURATION
########################################################
# UNITY   = f for fahrenheit, c for celsius or k for kelvin   
# API_KEY = free register in https://openweathermap.org
#           and get your token
# CITY    = your city name
# COUNTRY = your country abbreviation: us, ru, br, etc..
########################################################

UNITY="c"
API_KEY="${OPENWEATHER_API_KEY:-}"
CITY="Hajdúhadház"
COUNTRY="hu"

########################################################
mkdir -p "$HOME/.cache"
[ -f "$HOME/.config/keiko-installer/weather.env" ] && source "$HOME/.config/keiko-installer/weather.env"
if [ -z "$API_KEY" ]; then exit 0; fi
CITY=$(echo $CITY | sed -e 's/ /%20/g')
if [ $UNITY == "k" ]
then
	UNITY="default"
elif [ $UNITY == "c" ]
then
	UNITY="metric"
elif [ $UNITY == "f" ]
then
	UNITY="imperial"
else
	UNITY="default"
fi
verify=$(which curl 2> /dev/null)
if [ "$verify" == "" ]
then
	echo "Dependency not found! Please install curl library!"
	exit
fi
url="https://api.openweathermap.org/data/2.5/weather?APPID=$API_KEY&q=$CITY,$COUNTRY&units=$UNITY"
status=$(curl -L -s -o /dev/null -w "%{http_code}" --max-time 15 "$url")
if [ "$status" != "200" ]
then
	echo ""
	exit
fi
data=$(curl -fsS --max-time 15 "$url" | sed -e 's/}//g' | sed -e 's/{//g' | sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/"//g')
city=$(echo $data | sed -e 's/,/\n/g' | grep name | cut -d":" -f2)
country=$(echo $data | sed -e 's/,/\n/g' | grep country | cut -d":" -f3)
temp=$(echo $data | sed -e 's/,/\n/g' | grep temp | sed -e 's/ /\n/g' | cut -d":" -f3)
description=$(echo $data | sed -e 's/,/\n/g' | grep description | cut -d":" -f2)
temp_min=$(echo $data | sed -e 's/,/\n/g' | grep temp_min | cut -d":" -f2)
temp_max=$(echo $data | sed -e 's/,/\n/g' | grep temp_max | cut -d":" -f2)
humidity=$(echo $data | sed -e 's/,/\n/g' | grep humidity | cut -d":" -f2)
pressure=$(echo $data | sed -e 's/,/\n/g' | grep pressure | cut -d":" -f2)
wind=$(echo $data | sed -e 's/,/\n/g' | grep wind | cut -d":" -f3)
update=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "city>$city\ncountry>$country\ntemp>$temp\ndescription>$description\nmin>$temp_min\nmax>$temp_max\nhumidity>$humidity\npressure>$pressure\nwind>$wind\nupdate>$update" > "$HOME/.cache/weather.txt.tmp"
[ -s "$HOME/.cache/weather.txt.tmp" ] && mv "$HOME/.cache/weather.txt.tmp" "$HOME/.cache/weather.txt"
