#!/bin/sh

if [ ! -f "/var/log/genmon.log" ]; then
  sudo touch /var/log/genmon.log
fi

if [ ! -d "/etc/genmon" ]; then
  sudo mkdir -p /etc/genmon
fi

/app/genmon/startgenmon.sh start && tail -F /var/log/genmon.log