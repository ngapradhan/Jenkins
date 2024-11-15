#!/bin/bash

set -u
set -e

jenkins_url="http://localhost:8080"
USER="admin"
API_TOKEN="11945107455fda969710f76d60b00f5c11"

post_docker_run() {
  JENKINS_URL=${jenkins_url}
  API_ENDPOINT="/api/json?tree=jobs%5Bname,_class,url,jobs%5D"

  # Wait for Jenkins to be up
  wait_for_jenkins "$JENKINS_URL" || return 1

  # Collect multibranch job URLs recursively
  scan_reapply_multibranch_job "$JENKINS_URL" "$API_ENDPOINT" "$USER" "$API_TOKEN"
}

# This method verifies if Jenkins is available
wait_for_jenkins() {
  parent_url="$1"
  echo "Waiting for Jenkins to be up..."
  for i in {1..20}; do
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

# This method recursively collects multibranch job URLs and triggers the update process
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

  # Parse each item and look for multibranch pipelines and folders
  local job_urls=$(echo "$items" | jq -r '.jobs[] | select(._class=="org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject") | .url')
  
  # Recurse into folders
  local folders=$(echo "$items" | jq -r '.jobs[] | select(._class=="com.cloudbees.hudson.plugins.folder.Folder") | .url')
  for folder in $folders; do
    scan_reapply_multibranch_job "$(echo "$folder" | tr -d '\r')" "$api_endpoint" "$user" "$api_token"
    echo "$folder"
  done

  update_multibranch_job_configs "$user" "$api_token" "$job_urls"
}

# This method updates configuration for each multibranch job
update_multibranch_job_configs() {
  local user="$1"
  local api_token="$2"
  local job_urls="$3"

  echo "Updating configuration for multibranch jobs:"
  for url in $job_urls; do
    url="$(echo "$url" | tr -d '\r' | sed 's:/$::')" # Remove carriage return characters and trailing slash
    echo "Processing URL: $url"

    rm -f config.xml
    # Fetch the current job config.xml
    config_response=$(curl -s -u "$user:$api_token" -o config.xml "$url/config.xml")
    if [ $? -ne 0 ] || [ ! -s config.xml ]; then
      echo "Error: Failed to fetch config.xml for $url"
      continue
    fi
    echo "Config file retrieved successfully for $url"

    response=$(curl -s -u "$user:$api_token" "$url/config.xml" --data-binary "@config.xml" -H "Content-Type: application/xml")
    if [ $? -ne 0 ]; then
      echo "Error: Failed to update configuration for $url"
      continue
    fi

    echo "Configuration applied successfully for $url"
    rm -f config.xml
  done
}

post_docker_run
