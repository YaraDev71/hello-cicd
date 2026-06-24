#!/bin/bash
set -e

# ── Java 11 ──────────────────────────────────────────────────────────────
sudo yum install -y java-11-amazon-corretto-devel

# ── Maven (seulement si absent) ──────────────────────────────────────────
if [ ! -f /usr/local/bin/mvn ]; then
  cd /tmp
  wget -q https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
  sudo tar -xzf apache-maven-3.8.6-bin.tar.gz -C /usr/local/
  sudo ln -sf /usr/local/apache-maven-3.8.6/bin/mvn /usr/local/bin/mvn
fi

# ── Tomcat (seulement si absent) ─────────────────────────────────────────
if [ ! -d /usr/local/apache-tomcat-9.0.65 ]; then
  cd /tmp
  wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
  sudo tar -xzf apache-tomcat-9.0.65.tar.gz -C /usr/local/
  sudo ln -sf /usr/local/apache-tomcat-9.0.65 /usr/local/tomcat
fi

# ── Utilisateur tomcat ───────────────────────────────────────────────────
sudo useradd -r -s /sbin/nologin tomcat 2>/dev/null || true

# ── Permissions (toujours appliquées) ────────────────────────────────────
sudo chown -R tomcat:tomcat /usr/local/apache-tomcat-9.0.65
sudo find /usr/local/apache-tomcat-9.0.65/bin -name "*.sh" -exec chmod 750 {} \;

# ── Service systemd ──────────────────────────────────────────────────────
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto.x86_64
Environment=CATALINA_PID=/usr/local/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable tomcat

# Arrêter proprement avant de redémarrer (ignore l'erreur si pas encore lancé)
sudo systemctl stop tomcat 2>/dev/null || true
sleep 2
