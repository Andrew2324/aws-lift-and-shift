#!/bin/bash
set -e

URL="${1:-http://localhost}"

echo "Validating URL: $URL"
curl -s -o /dev/null -w "%{http_code}\n" "$URL"
