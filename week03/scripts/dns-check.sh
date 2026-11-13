
#!/usr/bin/env bash

set -o pipefail

DOMAIN="${1:-github.com}"

echo "================================"
echo "DNS Diagnostic Report"
echo "================================"

echo "Domain: $DOMAIN"
echo "Date: $(date)"
echo

echo "=== Configured DNS resolvers ==="
grep '^nameserver' /etc/resolv.conf

echo
echo "=== IPv4 DNS records ==="
dig +short "$DOMAIN" A

echo
echo "=== IPv6 DNS records ==="
dig +short "$DOMAIN" AAAA

echo
echo "=== DNS resolution status ==="

if getent ahosts "$DOMAIN" > /dev/null; then
    echo "DNS resolution: OK"
    exit 0
else
    echo "DNS resolution: FAILED"
    exit 1
fi
