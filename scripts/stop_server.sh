#!/bin/bash
sudo systemctl stop tomcat 2>/dev/null || true
sudo pkill -f catalina || true
sleep 2
