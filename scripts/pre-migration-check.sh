#!/bin/bash
echo "=== Pre-migration checks ==="
echo "[1] Disk usage"
df -h
echo
echo "[2] Running services"
systemctl list-units --type=service --state=running | head -n 30
echo
echo "[3] Listening ports"
ss -tulpn | head -n 50
