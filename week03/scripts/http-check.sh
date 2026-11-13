
#!/usr/bin/env bash

URL="${1:-https://example.com}"

echo "================================"
echo "HTTP Health Check"
echo "================================"

echo "URL: $URL"
echo "Date: $(date)"
echo "curl -s -o /dev/null -w 'Total time: %{time_total}s\n' https://example.com"
echo

response=$(curl -sS -L \
    --connect-timeout 5 \
    --max-time 15 \
    -o /dev/null \
    -w '%{http_code}' \
    "$URL")

curl_status=$?

if (( curl_status != 0 )); then
    echo "Status: CONNECTION ERROR"
    echo "curl exit code: $curl_status"
    exit 2
fi

echo "HTTP status: $response"

if [[ "$response" =~ ^2[0-9][0-9]$ ]]; then
    echo "Status: HEALTHY"
    exit 0
else
    echo "Status: UNHEALTHY"
    exit 1
fi
