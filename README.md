# About
This project is a simple service that performs a speedtest and sends the data off the host to influx. It works by using the [speedtest-cli](https://github.com/sivel/speedtest-cli) python tool the script writes data to a file and pushes it to influxdb. I created this in an effort to keep an eye the service provided by my ISP.

# Usage

First clone and CD into the repository
```
git clone https://github.com/DerfOh/speedtest-to-influx.git
cd speedtest-to-influx
```

Write a `.env` file like the following which defines your influx database connection and hostname information
```
# Host tag in influx
HOSTNAME=my_speedtest_host

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

## Docker

Then build and run the docker container
```
docker build . -t speedtest
docker run --name speedtest -it --env-file ./.env speedtest
```

Clean up
```
docker rm -f speedtest
docker rmi speedtest
```

## Python

First follow the install instructions at https://github.com/sivel/speedtest-cli

Then run the following
```
source .env
./script.sh
```