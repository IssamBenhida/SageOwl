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
                # Prepare JSON version from Syslog log data
                result = {
                    'timestamp': log_event['timestamp'],
                    'user': 'kali',
                    'message': match.group(1)
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
                        '_index': 'your_index_name',
                        '_id': str(i)
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
