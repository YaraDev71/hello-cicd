#!/bin/bash
set -e

# 1. S'assurer que amazon-linux-extras est disponible
if ! command -v amazon-linux-extras &> /dev/null; then
    echo "Installing amazon-linux-extras..."
    sudo yum install -y amazon-linux-extras
fi

# 2. Installer Java 11 (Corretto)
sudo amazon-linux-extras install java-openjdk11 -y

# 3. Installer Tomcat 9 (via extras)
sudo amazon-linux-extras install tomcat9 -y
sudo systemctl enable tomcat9
sudo systemctl start tomcat9

# 4. Installer Maven manuellement (plus fiable que yum)
cd /tmp
wget -q https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
sudo tar -xzf apache-maven-3.8.6-bin.tar.gz -C /usr/local/
sudo ln -sf /usr/local/apache-maven-3.8.6/bin/mvn /usr/local/bin/mvn
