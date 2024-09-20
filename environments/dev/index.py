import base64
import gzip
import json
import re
from io import BytesIO

parser = re.compile(r'^(.*)$')


def handler(event, context):
    success = 0
    failure = 0
    output = []

    for record in event['records']:
        # Decode and decompress data
        compressed_payload = base64.b64decode(record['data'])
        with gzip.GzipFile(fileobj=BytesIO(compressed_payload)) as f:
            data = f.read().decode('utf-8')

        # Parse JSON data
        log_data = json.loads(data)
        log_events = log_data['logEvents']

        transformed_events = []
        for log_event in log_events:
            message = log_event['message']
            match = parser.match(message)

            if match:
                try:
                    message_data = json.loads(log_event['message'])
                except json.JSONDecodeError:
                    # If message cannot be parsed as JSON, log the failure
                    failure += 1
                    continue

                result = {
                    'timestamp': log_event['timestamp'],
                    'user.agent': message_data['user.agent'],
                    'http.request.method': message_data.get('http.request.method'),
                    'http.request.url': message_data.get('http.request.path'),
                    'http.response.status': message_data.get('http.response.status.code'),
                    'http.response.body.bytes': message_data.get('http.response.body.bytes'),
                    'source.ip': message_data['source.ip'],
                }
                transformed_events.append(result)
                success += 1
            else:
                failure += 1

        # Log transformed payload
        print(f'Transformed payload: {json.dumps(transformed_events)}')

        # Append document to output in Elasticsearch bulk API format
        for i, event in enumerate(transformed_events):
            output.append({
                'recordId': str(i),
                'result': 'Ok',
                'data': base64.b64encode(json.dumps({
                    'index': {
                        '_log_type': 'web-app'
                    }
                }).encode('utf-8')).decode('utf-8')
            })
            output.append({
                'recordId': str(i),
                'result': 'Ok',
                'data': base64.b64encode(json.dumps(event).encode('utf-8')).decode('utf-8')
            })

    print(f'Processing completed. Successful records {success}, Failed records {failure}.')
    return {'records': output}
