#!/bin/bash
# Check for updates and save it to file
docker exec jenkins sh -c "java -jar /opt/jenkins-plugin-manager.jar -f /usr/share/jenkins/plugins.txt --available-updates --output txt > /var/jenkins_home/plugins-update.txt"
sleep 30
# Copy new list to host
docker cp jenkins:/var/jenkins_home/plugins-update.txt /home/jenkins/init/plugins-update.txt
# Use mv to replace old plugin.txt file
mv -f /home/jenkins/init/plugins-update.txt /home/jenkins/init/plugins.txt
# Run docker docker-compose down && docker-compose up -d to ensure new Jenkins plugins is running. This will trigger entrypoint.sh script
echo "Restaring Jenkins..."
docker-compose down && docker-compose up -d