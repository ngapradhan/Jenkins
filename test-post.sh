#!/bin/bash
jenkins_url="http://localhost:8080"
USER="admin"
API_TOKEN="Admin123"

post_docker_run() {
  JENKINS_URL=${jenkins_url}
  API_ENDPOINT="/api/json?tree=jobs%5Bname,_class,url,jobs%5D"

  # Wait for Jenkins to be up
  wait_for_jenkins "$JENKINS_URL" || return 1

  # Collect multibranch job urls recursively
  scan_reapply_multibranch_job "$JENKINS_URL" "$API_ENDPOINT" "$USER" "$API_TOKEN"
}

# This method verify if Jenkins is available or not
wait_for_jenkins() {
    parent_url="$1"
  echo "Waiting for Jenkins to be up..."
  for i in {1..20}; do
    # if [ "$(curl -o /dev/null -s -w '%%{http_code}' "${jenkins_url}/login")" -eq 200 ]; then
    if [ "$(curl -o /dev/null -s -w '%{http_code}' "$parent_url/login")" -eq 200 ]; then
      echo "Jenkins is up!"
      return 0
    fi
    echo "Jenkins not available yet, retrying..."
    sleep 10
  done
  echo "Error: Jenkins did not become available."
  return 1
}

# This method recursively collects multibranch job URLs and triggers the update process.
scan_reapply_multibranch_job() {
  local parent_url="$1"
  local api_endpoint="$2"
  local user="$3"
  local api_token="$4"

  # Fetch all items in the current directory
  local items=$(curl -sS --user "$user:$api_token" "$parent_url$api_endpoint")

  # Check if curl succeeded and if items is not empty
  if [ $? -ne 0 ] || [ -z "$items" ]; then
    echo "Error: Failed to retrieve the list of jobs from Jenkins, or response is empty"
    return 1
  fi

  # Log the raw response for debugging
  echo "Raw response from Jenkins API:"
  echo "$items"

  # Parse each item and look for multibranch pipelines and folders
  local job_urls=$(echo "$items" | jq -r '.jobs[] | select(._class=="org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject") | .url' 2>/dev/null)

  # Recurse into folders
  local folders=$(echo "$items" | jq -r '.jobs[] | select(._class=="com.cloudbees.hudson.plugins.folder.Folder") | .url' 2>/dev/null)
  for folder in $folders; do
    scan_reapply_multibranch_job "$(echo "$folder" | tr -d '\r')" "$api_endpoint" "$user" "$api_token"
    echo $folder
  done

  update_multibranch_job_configs "$user" "$api_token" "$job_urls"
}

# This method update configuration for every multibranch job
update_multibranch_job_configs() {
  local user="$1"
  local api_token="$2"
  local job_urls="$3"

  # Add multibranch pipeline job URLs to the array and reapply configuration
  echo 'Updating configuration for multibranch jobs:'
  for url in $job_urls; do
    echo "Print URL: $url \n"

    # Clean up any previous job config.xml, ignore fail
    # rm -f config.xml
  
    # Get current job config.xml
    curl -s -u "$user:$api_token" "$url/config.xml" -O

    # Get the Crumb
    CRUMB=$(curl -u "$user:$api_token" -s "$url/crumbIssuer/api/json" | jq -r '.crumb')
  
    # Update the same config.xml to the job
    curl -s -u "$user:$api_token" "$url/config.xml" --data-binary "@config.xml" -H "Content-Type: application/xml"
    # curl -u "$user:$api_token" -X POST \
    #  -H "Content-Type: application/xml" \
    #  -H 'Jenkins-Crumb:' $CRUMB \
    #  --data-binary @config.xml \
    #  "$url/config.xml"

    echo "Configuration has been applied for $url\n"
  done

#   rm -f config.xml
}

post_docker_run
