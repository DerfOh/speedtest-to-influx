FROM python

ENV INFLUX_URL REPLACE_ME
ENV INFLUX_USER REPLACE_ME
ENV INFLUX_PASS REPLACE_ME

# Create app directory
WORKDIR /usr/src/app

# Bundle app source
COPY . .

# Install speedtest-cli
RUN pip install speedtest-cli

CMD sh /usr/src/app/script.sh