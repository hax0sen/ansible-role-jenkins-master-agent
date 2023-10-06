#!/bin/bash
#TIMESTAMP config
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
#Ensure folder exist
mkdir /var/jenkins_home/jcasc
# Copy configuration files to jcasc folder in container
cp /var/jenkins_init/*.yml /var/jenkins_home/jcasc
# Copy plugin file to container
cp /var/jenkins_init/plugins.txt /var/jenkins_home/
# Copy plugin file in right place
cp /var/jenkins_home/plugins.txt /usr/share/jenkins/ref/
# Run java to install plugins, output saved to log /var/jenkins_home/plugins-$TIMESTAMP.log
java -jar /opt/jenkins-plugin-manager.jar -f /usr/share/jenkins/ref/plugins.txt -d /var/jenkins_home/plugins --verbose > /var/jenkins_home/latest-plugin-log.txt 2>&1
echo "$(date) - This log show output for Installed plugins " >> latest-plugin-log.txt
echo "done, restarting jenkins.."
exec /usr/local/bin/jenkins.sh