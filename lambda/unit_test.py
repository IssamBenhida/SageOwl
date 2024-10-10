"""Unit tests for the Lambda handler and geolocation functionality."""

import gzip
import json
import base64
from unittest.mock import patch, MagicMock
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
        "logStream": "development",
        "subscriptionFilters": ["firehose"],
        "logEvents": [
            {
                "id": "0",
                "timestamp": 1727200688033,
                "message": json.dumps({
                    "timestamp": "28/Sep/2024:22:19:51 +0000",
                    "http.flavor": "1.1",
                    "http.user_agent": "firefox",
                    "http.request.url": "/home.php",
                    "http.response.bytes": "100",
                    "http.request.method": "GET",
                    "http.referrer": "-",
                    "http.response.code": "200",
                    "client_ip": "41.248.68.93"
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
    """Test geolocation API failure with an HTTPError and ensure None values are returned"""
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
