#!/bin/bash
# Installation de Java 11, Maven et Tomcat
amazon-linux-extras install java-openjdk11 -y
yum install -y maven tomcat
# On s'assure que Tomcat est reconnu comme service
systemctl enable tomcat
