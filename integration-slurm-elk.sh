#!/bin/bash

# Configure the <IP>, <USER>, and <PASSWORD> fields
ELASTICSEARCH_URL="http://<IP>:9200/slurm_jobs/_doc"
USER="<USER>"
PASSWORD="<PASSWORD>"

# Generate an ISO 8601 UTC timestamp and initialize the JSON payload
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
json="{\"@timestamp\":\"$timestamp\","

# Read environment variables provided by SLURM (e.g., SLURM_JOB_ID, SLURM_JOB_USER, etc.)
for var in $(env); do
    key=$(echo $var | cut -d= -f1)
    value=$(echo $var | cut -d= -f2-)

    # Ensure the key and value are not empty
    if [[ -n "$key" && -n "$value" ]]; then
        value_cleaned="$(echo -n "$value" | xargs)"
        json+="\"$key\":\"$value_cleaned\","
    fi
done

# Remove the trailing comma and close the JSON payload properly
json="${json%,}}"

# Optional debug log
#echo "Sending JSON payload: $json" >> /tmp/integration-slurm-elk.log

# Abort if the JSON payload is empty
if [[ "$json" == "{}" ]]; then
    echo "Error: Empty JSON payload, aborting transmission" >> /tmp/integration-slurm-elk.log
    exit 1
fi

# Send the JSON payload to Elasticsearch
curl -u "$USER:$PASSWORD" -X POST "$ELASTICSEARCH_URL" \
     -H "Content-Type: application/json" \
     -d "$json"
