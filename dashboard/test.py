from asyncio import Timeout
from datetime import datetime
from urllib.error import HTTPError
import requests
import base64
import json
import os
import re

parser = re.compile(r'^(.*)$')


# Custom exception for geolocation errors
class GeoLocationError(Exception):
    pass


def get_geo_location(ip: str) -> dict:
    """
    Fetch geolocation information for a given IP address using an external API.

    :param ip: The IP address to look up
    :return: A dictionary with geolocation details
    :raises GeoLocationError: If the request fails or the IP is invalid
    """
    # Load the API URL from environment variables for flexibility
    api_url = os.getenv("geo_api_url", "https://ipinfo.io/")

    try:
        # Make the API request to fetch geolocation info
        response = requests.get(f"{api_url}/{ip}/json", timeout=5)
        response.raise_for_status()  # Raise an HTTPError on bad responses
        return response.json()  # Return the geolocation data as JSON

    except (HTTPError, Timeout) as e:
        raise GeoLocationError(f"Failed to fetch geolocation data: {e}")
    except Exception as e:
        raise GeoLocationError(f"Unexpected error occurred: {e}")


def handler(event, context):
    success = 0
    failure = 0
    output = []

    for record in event['records']:
        data = record['data']

        # Parse JSON data
        log_data = json.loads(data)
        log_events = log_data['logEvents']

        transformed_events = []

        for log_event in log_events:
            message = log_event['message']

            if parser.match(message):
                try:
                    message_data = json.loads(log_event['message'])
                except json.JSONDecodeError:
                    # If message cannot be parsed as JSON, log the failure
                    failure += 1
                    continue

                connection = get_geo_location(message_data.get("client_ip"))
                result = {
                    'timestamp': message_data.get("timestamp"),
                    'http.flavor': message_data.get("http.flavor"),
                    'http.user_agent': message_data.get("http.user_agent"),
                    'http.request.url': message_data.get("http.request.url"),
                    'http.response.bytes': int(message_data.get("http.response.bytes")),
                    'http.request.method': message_data.get("http.request.method"),
                    'http.referrer': message_data.get("http.referrer"),
                    'http.response.code': int(message_data.get("http.response.code")),
                    'ip.address': connection.get("ip"),
                    'ip.country': connection.get("country"),
                    'ip.city': connection.get("city"),
                    'ip.region': connection.get("region"),
                    'ip.location': connection.get("loc"),
                    'ip.org': connection.get("org")
                }
                transformed_events.append(result)
                success += 1
            else:
                failure += 1

        # Log transformed payload
        # print(json.dumps(transformed_events))

        # Append document to output in Elasticsearch bulk API format
        for i, event in enumerate(transformed_events):
            # output.append({
            #     'recordId': str(i),
            #     'result': 'Ok',
            #     'data': base64.b64encode(json.dumps({
            #         'index': "test"
            #     }).encode('utf-8')).decode('utf-8')
            # })
            output.append({
                'recordId': str(i),
                'result': 'Ok',
                'data': json.dumps(event).encode('utf-8').decode('utf-8')
            })

    # print(f'Processing completed. Successful records {success}, Failed records {failure}.')
    return {'records': output}


ev = {
    "records": [
        {
            "data": json.dumps({
                "messageType": "DATA_MESSAGE",
                "owner": "000000000000",
                "logGroup": "localstack-log-group",
                "logStream": "local-instance",
                "subscriptionFilters": ["kinesis-test"],
                "logEvents": [
                    {
                        "id": "0",
                        "timestamp": 1727200688033,
                        "message": '{"timestamp": "2024-09-28T22:19:51+00:00","http.flavor": "1.1", '
                                   '"http.user_agent":"firefox", "http.request.url": "/home.php",   '
                                   '"http.response.bytes": "100", "http.request.method": "GET", "http.referrer": "-", '
                                   '"http.response.code": "200", "client_ip": "41.248.68.93" }'
                    },
                ]
            })
        }
    ]
}

print(handler(ev, ""))
