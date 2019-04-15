# About
This project is a simple speed test docker container using the speedtest-cli python tool that writes to influxdb, created this in an effort to keep an eye the service provided by my ISP.

# Usage

Write a `.env` file like the following which defines your influx database connection and hostname information
```
# Host tag in influx
HOSTNAME=macbook

# The URL and port used to connect to influx
INFLUX_URL=127.0.0.1:8086

# The credentials of the user, if admin it will also create the database
INFLUX_USER=username
INFLUX_PASS=password
```

If the user you have defined does not have administrative credentials on the influx database then you must manually run the following query
```
CREATE DATABASE speedtest
```

Then build and run the docker container
```
docker rm -f speedtest
docker rmi speedtest
docker build . -t speedtest
docker run --name speedtest -it --env-file ./.env speedtest
```