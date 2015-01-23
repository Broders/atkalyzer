#!/bin/bash

#fail2ban logpath setup
F2B_LOG_PATH=/var/log/fail2ban.log

#build cache
CACHE_DIR=/tmp/atkalyzr
IP_CACHE=${CACHE_DIR}/filteredIp
COUNTRY_CACHE=${CACHE_DIR}/countries

mkdir -p ${CACHE_DIR}

#Filter IPs from the fail2ban logfile
cut -d " " -f 7 ${F2B_LOG_PATH} | sort | uniq | sed '/^$/d' > ${IP_CACHE}

#Find the Geolocation for given IPs
<${IP_CACHE} xargs -i geoiplookup {} |
sed 's/GeoIP Country Edition://g' > ${COUNTRY_CACHE}

paste ${IP_CACHE} ${COUNTRY_CACHE}

#clean up
if [ "$CACHE_DIR" != "" ]; then
          rm -r ${CACHE_DIR}
fi
