#!/bin/bash

# === Configuration ===
LOG_FILE="/var/log/httpd/access.log"
MAX_SIZE=1073741824  # 1GB in bytes
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_API_TOKEN="11563bfdaa05783d53bf9b532353008ae4"  # Replace this!
JENKINS_JOB_NAME="upload-log-to-s3"

# === Fetch Jenkins Crumb ===
JENKINS_CRUMB=$(curl -s --user "$JENKINS_USER:$JENKINS_API_TOKEN" \
  "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# === Check if file exists ===
if [ ! -f "$LOG_FILE" ]; then
  echo "❌ Log file not found: $LOG_FILE"
  exit 1
fi

# === Get file size ===
FILE_SIZE=$(stat -c%s "$LOG_FILE")

if [ "$FILE_SIZE" -ge "$MAX_SIZE" ]; then
  echo "✅ Log file is larger than 1GB. Triggering Jenkins job..."

  curl -X POST "$JENKINS_URL/job/$JENKINS_JOB_NAME/buildWithParameters" \
    --user "$JENKINS_USER:$JENKINS_API_TOKEN" \
    -H "$JENKINS_CRUMB" \
    --data-urlencode "LOG_PATH=$LOG_FILE"
    
  echo "🚀 Jenkins job triggered successfully."
else
  echo "ℹ️ Log file is under 1GB. No action taken."
fi

