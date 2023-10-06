#!/bin/bash
# Define the name of the Jenkins container
CONTAINER_NAME="jenkins"
# Define the backup directory
BACKUP_DIR="/home/jenkins/jenkins-backup"
# Create the backup directory if it doesn't exist
mkdir -p /var/jenkins-backup
mkdir -p "$BACKUP_DIR"
# Get the current date and time
DATETIME=$(date +%Y-%m-%d_%H-%M-%S)
# Backup the Jenkins jobs directory using docker exec
docker exec "$CONTAINER_NAME" sh -c "cd /var/jenkins_home && tar czf - jobs" > "$BACKUP_DIR/jenkins_jobs_$DATETIME.tar.gz"
# Print a message indicating the backup has been completed
echo "Jenkins jobs backup completed successfully"



