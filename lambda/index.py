from requests.exceptions import HTTPError, Timeout
from datetime import datetime
from io import BytesIO
import requests
import base64
import gzip
import json
import re
import os

# log parser for cloudwatch logs
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
        # Decode and decompress records data
        compressed_payload = base64.b64decode(record['data'])
        with gzip.GzipFile(fileobj=BytesIO(compressed_payload)) as f:
            data = f.read().decode('utf-8')

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
                    'timestamp': datetime.strptime(message_data.get("timestamp"), '%d/%b/%Y:%H:%M:%S %z').isoformat(),
                    'http.flavor': message_data.get("http.flavor"),
                    'http.request.url': message_data.get("http.request.url"),
                    'http.response.bytes': message_data.get("http.response.bytes"),
                    'http.request.method': message_data.get("http.request.method"),
                    'http.referrer': message_data.get("http.referrer"),
                    'http.response.code': message_data.get("http.response.code"),
                    'http.ip.address': connection.get("ip"),
                    'http.ip.country': connection.get("country"),
                    'http.ip.city': connection.get("city"),
                    'http.ip.region': connection.get("region"),
                    'http.ip.location': connection.get("loc"),
                    'http.ip.org': connection.get("org"),
                    'http.user_agent.browser': message_data.get("http.user_agent.browser"),
                    'http.user_agent.os': message_data.get("http.user_agent.os"),
                    'http.user_agent.platform': message_data.get("http.user_agent.platform"),
                    'http.user_agent.details': message_data.get("http.user_agent.details")
                }
                transformed_events.append(result)
                success += 1
            else:
                failure += 1

        # Log transformed payload
        print(f'Transformed payload: {json.dumps(transformed_events)}')

        # Append document to output in Elasticsearch bulk API format
        for i, event in enumerate(transformed_events):
            # output.append({
            #     'recordId': str(i),
            #     'result': 'Ok',
            #     'data': base64.b64encode(json.dumps({
            #         'index': log_events[i]['id']
            #     }).encode('utf-8')).decode('utf-8')
            # })
            output.append({
                'recordId': str(i),
                'result': 'Ok',
                'data': base64.b64encode(json.dumps(event).encode('utf-8')).decode('utf-8')
            })

    print(f'Processing completed. Successful records {success}, Failed records {failure}.')
    return {'records': output}
