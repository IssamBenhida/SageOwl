import base64
import json
import re
from datetime import datetime

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

            if parser.match(message):
                try:
                    message_data = json.loads(log_event['message'])
                except json.JSONDecodeError:
                    # If message cannot be parsed as JSON, log the failure
                    failure += 1
                    continue

                result = {
                    'timestamp': datetime.strptime(message_data.get("timestamp"), '%d/%b/%Y:%H:%M:%S %z').isoformat(),
                    'response_code': int(message_data.get('response_code'))
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
                'data': base64.b64encode(json.dumps(event).encode('utf-8')).decode('utf-8')
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
                        "message": '{"timestamp":"25/Sep/2024:22:19:51 +0000","user_agent":"Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0","client_ip":"127.0.0.1","bytes":"999","response_code":"200","request":"/","http_version":"1.1","http_method":"GET"}'},
                ]
            })
        }
    ]
}

print(handler(ev, ""))
