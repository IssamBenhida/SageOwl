#!/bin/bash

# Checking if sufficient arguments are provided
if [[ $# -lt 10 ]]; then
  echo "Usage: $0 -d <detector.json> -r <rule1.json,rule2.json> -s <sender.json> -R <receiver.json> -c <channel.json>"
  exit 1
fi

# Parsing arguments
while getopts "d:r:s:R:c:" opt; do
  case $opt in
  d) detector_file="$OPTARG" ;;
  r) rules_files="$OPTARG" ;;
  s) sender_file="$OPTARG" ;;
  R) receiver_file="$OPTARG" ;;
  c) channel_file="$OPTARG" ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
  esac
done

# Convert comma-separated rule files into an array
IFS=',' read -r -a rule_files_array <<<"$rules_files"

# Check if each specified file exists
for file in "$detector_file" "${rule_files_array[@]}" "$sender_file" "$channel_file" "$receiver_file"; do
  if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' does not exist."
    exit 1
  fi
done

e="http://localhost:5601/api/notifications/create_config"
echo "Running ..."
echo "Creating sender..."
response=$(curl -s -X POST -w "%{http_code}" "$e" -H @headers -d @"$sender_file")
sender_id=$(echo "${response:0:-3}" | jq .config_id)
rcode=${response: -3}
if [[ "$rcode" -eq "200" || "$rcode" -eq "201" ]]; then
  echo "Sender created successfully with id: $sender_id"
else
  echo "Error: Received HTTP status code $rcode"
  echo "Response body: $response"
  exit 1
fi

echo "Creating receiver..."
response=$(curl -s -X POST -w "%{http_code}" "$e" -H @headers -d @"$receiver_file")
receiver_id=$(echo "${response:0:-3}" | jq .config_id)
rcode=${response: -3}
if [[ "$rcode" -eq "200" || "$rcode" -eq "201" ]]; then
  echo "Receiver created successfully with id: $receiver_id"
else
  echo "Error: Received HTTP status code $rcode"
  echo "Response body: $response"
  exit 1
fi

echo "Creating channel..."
update=$(sed -e "s/\"\$sender_id\"/$sender_id/g" -e "s/\"\$receiver_id\"/$receiver_id/g" "$channel_file")
response=$(curl -s -X POST -w "%{http_code}" "$e" -H @headers -d "$update")
channel_id=$(echo "${response:0:-3}" | jq .config_id)
rcode=${response: -3}
if [[ "$rcode" -eq "200" || "$rcode" -eq "201" ]]; then
  echo "Channel created successfully with id: $channel_id"
else
  echo "Error: Received HTTP status code $rcode"
  echo "Response body: $response"
  exit 1
fi

echo "Creating detection rules..."
endpoint="http://sageowl-local.us-east-1.opensearch.localhost.localstack.cloud:4566"
r="$endpoint/_plugins/_security_analytics/rules?category=apache_access"
rule_id_array=()

for i in "${rule_files_array[@]}"; do
  response=$(curl -s -w "%{http_code}" -X POST "$r" -H "Content-Type: application/json" -d @"$i")
  rule_id=$(echo "${response:0:-3}" | jq ._id)
  rcode=${response: -3}
  if [[ "$rcode" -eq "200" || "$rcode" -eq "201" ]]; then
    echo "Detection rule created successfully with id: $rule_id"
    rule_id_array+=("$rule_id")
  else
    echo "Error: Received HTTP status code $rcode"
    echo "Response body: $response"
    exit 1
  fi
done

echo "Creating detector..."
d="$endpoint/_plugins/_security_analytics/detectors"

for (( i=0; i<${#rule_id_array[@]}; i++ )); do
  name=${rule_files_array[$i]}
  update=$(sed -e "s/NAME/${name%.*}/g" -e "s/\"ID\"/${rule_id_array[$i]}/g" -e "s/\"channel_id\"/$channel_id/g" "$detector_file")
  response=$(curl -s -w "%{http_code}" -X POST "$d" -H "Content-Type: application/json" -d "$update")
  detector_id=$(echo "${response:0:-3}" | jq ._id)
  rcode=${response: -3}
  if [[ "$rcode" -eq "200" || "$rcode" -eq "201" ]]; then
    echo "Detector ${name%.*} created successfully with id: $detector_id"
  else
    echo "Error: Received HTTP status code $rcode"
    echo "Response body: $response"
    exit 1
  fi
done
