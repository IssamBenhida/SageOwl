#!/bin/bash

# Checking if sufficient arguments are provided
if [[ $# -lt 4 ]]; then
  echo "Usage: $0 -d <detector.json> -r <rule.json>"
  exit 1
fi

# Checking if the JSON file exists
if [[ ! -f $2 || ! -f $4 ]]; then
  echo "Error: $2 file not found!"
  exit 1
fi

endpoint="http://es-local.us-east-1.opensearch.localhost.localstack.cloud:4566"
r="$endpoint/_plugins/_security_analytics/rules?category=apache_access"
d="$endpoint/_plugins/_security_analytics/detectors"


# Sending the API request
response=$(curl -s -w "%{http_code}" -X POST "$r" \
-H "Content-Type: application/json" \
-d @"$4")

# Extracting the HTTP status code
http_code="${response: -3}"
# Extracting the response body
response_body=$(echo "${response:0:-3}" | jq ._id)

# Checking HTTP response code
if [[ "$http_code" -eq 200 || "$http_code" -eq 201 ]]; then
  sed -i "17s/\"id\" : *.*/\"id\" : $response_body/" "$2"
  curl -s -w "%{http_code}" -X POST "$d" \
  -H "Content-Type: application/json" \
  -d @"$2"
else
  echo "Error: Received HTTP status code $http_code"
  echo "Response body: $response_body"
  exit 1
fi
