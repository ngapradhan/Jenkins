#!/bin/bash

post_docker_run() {
  JENKINS_URL=${jenkins_url}
  API_ENDPOINT="/api/json?tree=jobs%5Bname,_class,url,jobs%5D"

  # Get Jenkins credentials
  jenkins_service_account=$(aws secretsmanager get-secret-value \
  --region ${region} \
  --secret-id ${jenkins_secret_id} \
  | jq --raw-output .SecretString)

  # extract creds
  USER=$(jq -r .username <<< $jenkins_service_account)
  API_TOKEN=$(jq -r .password <<< $jenkins_service_account)

  # Wait for Jenkins to be up
  wait_for_jenkins || return 1

  # Collect multibranch job urls recursively
  scan_reapply_multibranch_job "$JENKINS_URL" "$API_ENDPOINT" "$USER" "$API_TOKEN"
}

# This method verify if Jenkins is available or not
wait_for_jenkins() {
  echo "Waiting for Jenkins to be up..."
  for i in {1..20}; do
    if [ "$(curl -o /dev/null -s -w '%%{http_code}' "${jenkins_url}/login")" -eq 200 ]; then
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
  # Check if the curl command was successful
  if [ $? -ne 0 ]; then
    echo "Error: Failed to retrieve the list of jobs from Jenkins"
    return 1
  fi

  # Parse each item and look for multibranch pipelines and folders
  local job_urls=$(echo "$items" | jq -r '.jobs[] | select(._class=="org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject") | .url')

  # Recurse into folders
  local folders=$(echo "$items" | jq -r '.jobs[] | select(._class=="com.cloudbees.hudson.plugins.folder.Folder") | .url')
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
  local MULTIBRANCH_JOB_URLS=()

  # Add multibranch pipeline job URLs to the array and reapply configuration
  for url in $job_urls; do
    MULTIBRANCH_JOB_URLS+=("$url")
  done

  echo 'Updating configuration for multibranch jobs:'
  for url in "$MULTIBRANCH_JOB_URLS[@]"; do
    url="$(echo "$url" | tr -d '\r' | sed 's:/$::')" # Remove carriage return characters and trailing slash
    echo "Updating configuration to: $url"
  
    # Clean up any previous job config.xml, ignore fail
    rm -f config.xml
  
    # Get current job config.xml
    curl -s -u "$user:$api_token" "$url/config.xml" -O
  
    # Update the same config.xml to the job
    curl -s -u "$user:$api_token" "$url/config.xml" --data-binary "@config.xml" -H "Content-Type: application/xml"
  done
  
  # Clean up any previous job config.xml, ignore fail
  rm -f config.xml
}