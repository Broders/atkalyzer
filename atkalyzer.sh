#!/bin/bash

#fail2ban logpath setup
F2B_LOG_PATH=/var/log/fail2ban.log

#Set a default log path
LOG_PATH=$F2B_LOG_PATH

find_countries(){
 #Filter IPs from the fail2ban logfile and stores them in a array
 IP=(`cut -d " " -f 7 ${LOG_PATH} | sort | uniq`)

 #Find the Geolocation for given IPs and print them with their IP
 for X in "${IP[@]}"
    do
      COUNTRY=`geoiplookup ${X} | sed 's/GeoIP Country Edition://g'`
      echo "${X} $COUNTRY"
 done
}
while getopts ':f:' OPTION ; do
  case "$OPTION" in
    f) LOG_PATH=${OPTARG};
  esac
done

find_countries
exit $?
