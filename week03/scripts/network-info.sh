
#!/usr/bin/env bash

set -o pipefail

ip_address=${1:-1.1.1.1}
echo "================================"
echo "Linux Network Diagnostic Report"
echo "================================"

echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo

echo "=== Network interfaces ==="
ip -br addr
echo

echo "=== IPv4 routing table ==="
ip -4 route
echo

echo "=== Route to $ip_address ==="
ip -4 route get "$ip_address"
echo

echo "=== Connectivity test ==="

if ping -c 2 -W 2 "$ip_address"; then
    echo "ICMP connectivity to "$ip_address": OK"
else
    echo "ICMP connectivity to "$ip_address": FAILED or blocked"
    exit 1
fi
