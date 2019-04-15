#!/usr/bin/env bash

getDownload () {
    echo $(cat ./data.json | python -c "import sys, json; print(json.load(sys.stdin)['download'])")
}

getUpload () {
    echo $(cat ./data.json | python -c "import sys, json; print(json.load(sys.stdin)['upload'])")
}

createInfluxDB () {
    curl -i -XGET "http://$INFLUX_URL/query?q=CREATE+DATABASE+speedtest" -u $INFLUX_USER:$INFLUX_PASS
}

writeToInflux () {
    curl -i -XPOST "http://$INFLUX_URL/write?db=speedtest" -u $INFLUX_USER:$INFLUX_PASS --data-binary "speed_short,host=$HOSTNAME,updown=down value=$(getDownload)"
    curl -i -XPOST "http://$INFLUX_URL/write?db=speedtest" -u $INFLUX_USER:$INFLUX_PASS --data-binary "speed_short,host=$HOSTNAME,updown=up value=$(getUpload)"
}

checkEnv () {
    # Make sure the user has their variables set
    echo "Checking environment variables..."
    if [ "$INFLUX_URL" = "REPLACE_ME" ] || [ "$INFLUX_URL" = "" ]; then echo "[✗]\tINFLUX_URL"; exit 1; else echo "[✔]\tINFLUX_URL"; fi
    if [ "$INFLUX_USER" = "REPLACE_ME" ] || [ "$INFLUX_USER" = "" ] ; then echo "[✗]\tINFLUX_USER"; exit 1; else echo "[✔]\tINFLUX_USER"; fi
    if [ "$INFLUX_PASS" = "REPLACE_ME" ]|| [ "$INFLUX_PASS" = "" ] ; then echo "[✗]\tINFLUX_PASS" ; exit 1 ; else echo "[✔]\tINFLUX_PASS"; fi
    if [ "$HOSTNAME" = "REPLACE_ME" ]|| [ "$HOSTNAME" = "" ] ; then echo "[✗]\HOSTNAME" ; exit 1 ; else echo "[✔]\HOSTNAME"; fi
}


# Check environment variables
checkEnv

# Attempt creation of database
createInfluxDB

# Start the check loop
while true
do
    speedtest-cli --json > data.json
    writeToInflux
    sleep 2m
done