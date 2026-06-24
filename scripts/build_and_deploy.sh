#!/bin/bash
cd /home/ec2-user/hello-cicd
/usr/local/bin/mvn clean package
WAR_FILE=$(find target -name "*.war" | head -n 1)
sudo cp "$WAR_FILE" /usr/local/tomcat/webapps/ROOT.war
