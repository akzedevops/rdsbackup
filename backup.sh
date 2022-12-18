#!/bin/bash

# Set the current date and time
CURRENT_DATE=$(date +%Y-%m-%d-%H-%M)

# Set the name of the database to backup
DATABASE_NAME=your_database_name

# Set the name of the backup file
BACKUP_FILE=${DATABASE_NAME}-${CURRENT_DATE}.sql

# Set the directory to store the backups
BACKUP_DIRECTORY=/path/to/backup/directory

# Set the RDS endpoint and credentials
RDS_ENDPOINT=your_rds_endpoint
RDS_USERNAME=backupuser
RDS_PASSWORD=password

# Create the MySQL dump
mysqldump --single-transaction --routines --triggers --events --hex-blob --add-drop-database -h ${RDS_ENDPOINT} -u ${RDS_USERNAME} -p${RDS_PASSWORD} ${DATABASE_NAME} > ${BACKUP_DIRECTORY}/${BACKUP_FILE}

# Compress the backup file
gzip ${BACKUP_DIRECTORY}/${BACKUP_FILE}

# Find backup files older than a month
OLD_BACKUPS=$(find ${BACKUP_DIRECTORY} -name "*.gz" -mtime +30)

# Delete the old backups
if [ -n "$OLD_BACKUPS" ]; then
  rm $OLD_BACKUPS
fi
