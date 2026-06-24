#!/bin/bash
set -e
sudo pkill -f catalina || true
sudo rm -f /usr/local/tomcat/temp/tomcat.pid
sleep 2
sudo systemctl start tomcat
sleep 5
sudo systemctl status tomcat --no-pager
