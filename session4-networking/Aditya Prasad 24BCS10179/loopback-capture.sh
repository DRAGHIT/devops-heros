#!/usr/bin/env bash
set -eu
exec > >(tee /tmp/devops-evidence/s4-packet-success.txt) 2>&1
python3 -m http.server 18766 --bind 127.0.0.1 >/tmp/s4-http2.log 2>&1 & server=$!
trap 'kill "$server" 2>/dev/null || true' EXIT
for i in $(seq 1 20);do curl -fsS --max-time 1 http://127.0.0.1:18766 >/dev/null 2>&1 && break;sleep 1;done
sudo timeout 8 tcpdump -i lo -nn -c 4 tcp port 18766 >/tmp/s4-packets2.txt 2>&1 & cap=$!
sleep 1
curl -I --max-time 5 http://127.0.0.1:18766
wait "$cap" || true
cat /tmp/s4-packets2.txt
kill "$server";wait "$server" || true
