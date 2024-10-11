"""
This module contains a log parser for CloudWatch logs,
fetches geolocation information for IP addresses, and
transforms log entries into a specified format for further processing.
"""

import re
import os
import gzip
import json
import base64
import logging
from io import BytesIO
from datetime import datetime
import requests
from requests.exceptions import HTTPError

# Setup logging for Lambda
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# log parser for cloudwatch logs
parser = re.compile(r'^\{.*"timestamp": "\d{2}/\w{3}/\d{4}:\d{2}:\d{2}:\d{2} \+\d{4}".*}$')


def get_geo_location(ip: str) -> dict:
    """
    Fetch geolocation information for a given IP address using an external API.

    :param ip: The IP address to look up
    :return: A dictionary with geolocation details
    :raises GeoLocationError: If the request fails or the IP is invalid
    """
    # Load the API URL from environment variables for flexibility
    api_url = os.getenv("geo_api_url")
    null_response = {
        'ip': None,
        'country': None,
        'city': None,
        'region': None,
        'loc': None,
        'org': None
    }
    try:
        # Make the API request to fetch geolocation info
        response = requests.get(f"{api_url}/{ip}/json", timeout=5)
        # Raise an HTTPError on bad responses
        response.raise_for_status()
        # Return the geolocation data as JSON
        return response.json()

    except HTTPError as e:
        logger.error("Unexpected error occurred for IP %s: %s", ip, e)
        return null_response
s

def handler(event_data, context):
    """
    Process the incoming event data, transforming log entries
    and fetching geolocation.

    :param context:
    :param event_data: The incoming event containing log records
    :return: A dictionary with transformed records ready for output
    """
    output = []

    for record in event_data['records']:
        # Decode and decompress records data
        with gzip.GzipFile(fileobj=BytesIO(
                base64.b64decode(record['data'])
        )) as f:
            data = f.read().decode('utf-8')

        # Parse JSON data
        log_events = json.loads(data)['logEvents']

        transformed_events = []

        for log_event in log_events:
            if parser.match(log_event['message']):
                try:
                    message_data = json.loads(log_event['message'])
                    # If a message cannot be parsed as JSON, log the failure
                except json.JSONDecodeError as e:
                    logger.error("Json error occurred: %e", e)
                    continue

                connection = get_geo_location(message_data.get("client_ip"))
                result = {
                    'timestamp': datetime.strptime(
                        message_data.get("timestamp"),
                        '%d/%b/%Y:%H:%M:%S %z'
                    ).isoformat(),
                    'http.flavor': message_data.get("http.flavor"),
                    'http.request.url': message_data.get("http.request.url"),
                    'http.response.bytes': message_data.get(
                        "http.response.bytes"
                    ),
                    'http.request.method': message_data.get(
                        "http.request.method"
                    ),
                    'http.referrer': message_data.get(
                        "http.referrer"
                    ),
                    'http.response.code': message_data.get(
                        "http.response.code"
                    ),
                    'http.ip.address': connection.get(
                        "ip"
                    ),
                    'http.ip.country': connection.get(
                        "country"
                    ),
                    'http.ip.city': connection.get(
                        "city"
                    ),
                    'http.ip.region': connection.get(
                        "region"
                    ),
                    'http.ip.location': connection.get(
                        "loc"
                    ),
                    'http.ip.org': connection.get(
                        "org"
                    ),
                    'http.user_agent.browser': message_data.get(
                        "http.user_agent.browser"
                    ),
                    'http.user_agent.os': message_data.get(
                        "http.user_agent.os"
                    ),
                    'http.user_agent.platform': message_data.get(
                        "http.user_agent.platform"
                    ),
                    'http.user_agent.details': message_data.get(
                        "http.user_agent.details"
                    )
                }
                transformed_events.append(result)

        # Append document to output in Opensearch bulk API format
        for i, event in enumerate(transformed_events):
            output.append({
                'recordId': str(i) + context.log_stream_name,
                'result': 'Ok',
                'data': base64.b64encode(
                    json.dumps(event).encode('utf-8')
                ).decode('utf-8')
            })

    return {'records': output}
