import base64
import json
import re

parser = re.compile(r'^(.*)$')


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
        print(json.dumps(transformed_events))

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

    # print(f'Processing completed. Successful records {success}, Failed records {failure}.')
    return {'records': output}


ev = {
    "records": [
        {
            "data": json.dumps({
                "logEvents": [
                    {
                        "timestamp": 1726592475722,
                        "message": "{\"http.response.status.code\":\"404\",\"http.version\":\"1.1\",\"user.agent\":\"Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0\",\"http.request.method\":\"GET\",\"source.ip\":\"127.0.0.1\",\"event\":{\"original\":\"127.0.0.1 - - [17/Sep/2024:16:44:36 +0000] \\\"GET /test HTTP/1.1\\\" 404 125 \\\"-\\\" \\\"Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0\\\"\"},\"http.request.path\":\"/test\",\"host\":{\"name\":\"localhost\"},\"http.response.body.bytes\":\"125\",\"timestamp\":\"17/Sep/2024:16:44:36 +0000\"}",
                        "ingestionTime": 1726592481582
                    }
                ]
            })
        }
    ]
}

handler(ev, "")
