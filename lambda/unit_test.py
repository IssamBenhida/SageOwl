"""Unit tests for the Lambda handler and geolocation functionality."""

import gzip
import json
import base64
from unittest.mock import patch, MagicMock, ANY
from io import BytesIO
import pytest
from requests.exceptions import HTTPError
from index import handler, get_geo_location


@pytest.fixture
def sample_event():
    """Sample event for testing"""
    # Create the plain text event as a Python dictionary
    ev = {
        "messageType": "DATA_MESSAGE",
        "owner": "000000000000",
        "logGroup": "sageowl",
        "logStream": "on-prime",
        "subscriptionFilters": ["firehose"],
        "logEvents": [
            {
                "id": "0",
                "timestamp": 1727200688033,
                "message": json.dumps({
                    "http.request.url": "/admin",
                    "timestamp": "06/Nov/2024:10:09:01 +0000",
                    "http.request.method": "GET",
                    "http.response.code": "200",
                    "http.user_agent.os": "X11; Linux x86_64; rv:109.0",
                    "http.user_agent.browser": "Mozilla/5.0",
                    "http.user_agent.platform": "Gecko/20100101",
                    "http.referrer": "http://localhost/",
                    "client_ip": "176.31.84.249",
                    "http.flavor": "1.1",
                    "http.response.bytes": "125",
                    "http.user_agent.details": "Firefox/115.0"
                })
            }
        ]
    }

    # Gzip compress the serialized JSON event
    compressed_data = BytesIO()
    with gzip.GzipFile(fileobj=compressed_data, mode='w') as gz:
        gz.write(json.dumps(ev).encode('utf-8'))
    # Base64 encode the compressed data
    return {
        'records': [
            {
                'data': base64.b64encode(compressed_data.getvalue()).decode('utf-8')
            }
        ]
    }


@patch("requests.get")
@patch("os.getenv", return_value="https://mockapi.io")
def test_get_geo_location(_mock_getenv, mock_get):
    """Test successful geolocation API call"""
    mock_response = MagicMock()
    mock_response.json.return_value = {
        "ip": "192.168.0.1",
        "country": "US",
        "city": "New York",
        "region": "NY",
        "loc": "40.7128,-74.0060",
        "org": "Mock Org"
    }
    mock_response.raise_for_status = MagicMock()
    mock_get.return_value = mock_response

    result = get_geo_location("192.168.0.1")
    assert result["country"] == "US"
    assert result["city"] == "New York"
    assert result["org"] == "Mock Org"


@patch("requests.get", side_effect=HTTPError("404 Client Error"))
def test_get_geo_location_failure(_mock_get):
    """Test geolocation API failure with an HTTPError and ensure None values"""
    expected_result = {
        'ip': None,
        'country': None,
        'city': None,
        'region': None,
        'loc': None,
        'org': None
    }

    result = get_geo_location("192.168.0.1")
    assert result == expected_result


@patch("index.logger")
def test_handler_json_decode_error(mock_logger, sample_event):
    """Test handler execution with an invalid JSON to trigger JSONDecodeError."""
    # Modify the sample_event to include an invalid JSON message
    invalid_event = sample_event.copy()
    invalid_event['records'][0]['data'] = base64.b64encode(
        gzip.compress(
            json.dumps({
                "messageType": "DATA_MESSAGE",
                "logEvents": [
                    {
                        "id": "0",
                        "timestamp": 1727200688033,
                        # Invalid JSON (missing a colon between key and value)
                        "message": '{"http.request.url" "/admin", '
                                   '"timestamp": "06/Nov/2024:10:09:01 +0000"}'
                    }
                ]
            }).encode('utf-8')
        )
    ).decode('utf-8')

    context = MagicMock()
    context.log_stream_name = "development"

    result = handler(invalid_event, context)
    # Check that JSONDecodeError was logged
    mock_logger.error.assert_called_with("Json error occurred: %e", ANY)

    # Ensure that the handler still returns a result
    assert 'records' in result
    # No valid records should be processed due to JSON error
    assert len(result['records']) == 0


@patch("index.get_geo_location")
def test_handler_success(mock_geo_location, sample_event):
    """Test successful handler execution with valid log entries"""
    mock_geo_location.return_value = {
        "ip": "192.168.0.1",
        "country": "US",
        "city": "New York",
        "region": "NY",
        "loc": "40.7128,-74.0060",
        "org": "Mock Org"
    }
    context = MagicMock()
    context.log_stream_name = "development"

    result = handler(sample_event, context)

    # Check if output has records
    assert 'records' in result
    assert len(result['records']) == 1

    # Validate the structure of the output data
    record = result['records'][0]
    assert record['result'] == 'Ok'
    assert record['data'] is not None
