#!/bin/bash
# jenkins destination container
CONTAINER_NAME="jenkins"
DOCKER_PATH="/home/jenkins/"
# Define the backup jobs directory
BACKUP_JOB_DIR="/var/jenkins-backup/jenkins-jobs"
# Get the latest backup file in the backup
BACKUP_JOBS_FILE=$(ls -t "$BACKUP_JOB_DIR" | head -1)
echo "==> Tear down Jenkins.."
cd $DOCKER_PATH
docker-compose down -v
docker-compose up -d jenkins
sleep 15
echo "==> Removed before restoring.."
# Remove the existing jobs directory
docker exec jenkins rm -rf /var/jenkins_home/jobs
echo "==> Restoring jenkins jobs folder.."
if ! docker cp "$BACKUP_JOB_DIR/$BACKUP_JOBS_FILE" "$CONTAINER_NAME:/tmp/" || \
   ! docker exec "$CONTAINER_NAME" tar -xzvf "/tmp/$BACKUP_JOBS_FILE" -C /var/jenkins_home/ || \
   ! docker exec -u root "$CONTAINER_NAME" rm "/tmp/$BACKUP_JOBS_FILE"; then
  echo "Failed to restore Jenkins jobs folder"
  exit 1
fi
# Start the destination container
docker-compose up -d
# Print a message indicating the restore has been completed
echo "Jenkins jobs restore completed successfully"