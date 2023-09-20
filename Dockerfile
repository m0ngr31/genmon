FROM python:3.11.5-slim-bookworm

RUN apt update -y
RUN apt upgrade -y

# The timezone specified here just bypasses some required configuration, it is not configuring a persistent setting
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt install -y sudo git

# Download genmon code
RUN mkdir -p /app && cd /app && git clone https://github.com/jgyates/genmon.git
RUN sudo chmod 775 /app/genmon/startgenmon.sh && sudo chmod 775 /app/genmon/genmonmaint.sh

# Update the genmon.conf file to use the TCP serial for ESP32 devices
RUN sed -i 's/use_serial_tcp = False/use_serial_tcp = True/g' /app/genmon/conf/genmon.conf
RUN sed -i 's/serial_tcp_port = 8899/serial_tcp_port = 6638/g' /app/genmon/conf/genmon.conf
RUN echo "update_check = false" >> /app/genmon/conf/genmon.conf

# Update MQTT default config
RUN sed -i 's/strlist_json = False/strlist_json = True/g' /app/genmon/conf/genmqtt.conf
RUN sed -i 's/flush_interval = 0/flush_interval = 60/g' /app/genmon/conf/genmqtt.conf
RUN sed -i 's/blacklist = Monitor,Run Time,Monitor Time,Generator Time,External Data/blacklist = Run Time,Monitor Time,Generator Time,Platform Stats,Communication Stats/g' /app/genmon/conf/genmqtt.conf

# Install Genmon requirements
RUN /bin/bash /app/genmon/genmonmaint.sh -i -n -p 3 -s
RUN pip install spidev

# Configure startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Clean up
RUN apt-get purge -y git build-essential libssl-dev libffi-dev python3-dev cargo && apt autoremove && apt clean ; \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

VOLUME /etc/genmon

EXPOSE 22
EXPOSE 443
EXPOSE 8000

CMD ["/app/start.sh"]

# annotation labels according to
# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title="Genmon Docker Image"
LABEL org.opencontainers.image.description="Image to run an instance of Genmon"
LABEL org.opencontainers.image.url="https://github.com/m0ngr31/genmon"
LABEL org.opencontainers.image.documentation="https://github.com/m0ngr31/genmon#readme"
LABEL org.opencontainers.image.licenses="GPL-2.0"
LABEL org.opencontainers.image.authors="Joe Ipson"
