#!/bin/bash
# Se déplacer dans le dossier où CodeDeploy a copié le code source
cd /home/ec2-user/hello-cicd

# Construction du projet avec Maven (génère le fichier .war)
mvn clean package

# Récupérer le nom du fichier WAR généré et le copier dans le dossier webapps de Tomcat
# Tomcat renomme automatiquement ROOT.war en application racine
WAR_FILE=$(find target -name "*.war" | head -n 1)
cp $WAR_FILE /usr/share/tomcat/webapps/ROOT.war

# Nettoyer les sources pour libérer de l'espace (optionnel)
# rm -rf /home/ec2-user/hello-cicd
