#!/bin/bash
set -euxo pipefail
exec > >(tee /tmp/devops-evidence/s20-alert-final.txt) 2>&1
docker stop exporter
for i in $(seq 1 20); do
body=$(curl -fsS http://127.0.0.1:9090/api/v1/alerts)
echo "$body"
echo "$body" | python3 -c 'import json,sys;d=json.load(sys.stdin);assert any(a["state"]=="firing" for a in d["data"]["alerts"])' && break
sleep 3
done
docker start exporter
for i in $(seq 1 16);do
body=$(curl -fsS http://127.0.0.1:9090/api/v1/alerts)
echo "$body"
echo "$body" | python3 -c 'import json,sys;assert not json.load(sys.stdin)["data"]["alerts"]' && break
sleep 3
done
