from datetime import datetime
from io import BytesIO
import base64
import gzip
import json
import re

# log parser for cloudwatch logs
parser = re.compile(r'^(.*)$')


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

                result = {
                    'timestamp': datetime.strptime(message_data.get("timestamp"), '%d/%b/%Y:%H:%M:%S %z').isoformat(),
                    'http_version': message_data.get('http_version'),
                    'user_agent': message_data.get('user_agent'),
                    'request_path': message_data.get('request'),
                    'client_ip': message_data.get('client_ip'),
                    'bytes': int(message_data.get('bytes')),
                    'http_method': message_data.get('http_method'),
                    'referrer': message_data.get('referrer'),
                    'response_code': int(message_data.get('response_code'))
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
