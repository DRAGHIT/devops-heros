#!/bin/bash
set -euxo pipefail
exec > >(tee /tmp/devops-evidence/s20-fix.txt) 2>&1
sed -i 's/namespace: *argocd/namespace: aditya-s20-argocd/g' /tmp/s20-prep/argocd-install.yaml
kubectl apply --server-side --force-conflicts -n aditya-s20-argocd -f /tmp/s20-prep/argocd-install.yaml
kubectl auth can-i list nodes --as=system:serviceaccount:aditya-s20-argocd:argocd-application-controller
kubectl -n aditya-s20-argocd rollout restart statefulset/argocd-application-controller
id=$(docker network inspect aditya-s20-monitor --format '{{.Id}}')
br=br-${id:0:12}
sudo iptables-legacy -I FORWARD -i "$br" -o "$br" -j ACCEPT
docker start exporter || true
sleep 15
curl -fsS http://127.0.0.1:9090/api/v1/targets
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=up{job="node"}'
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=100 * (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[1m])))'
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)'
printf '\nSECTION ALERT VERIFIED FAILURE\n'
docker stop exporter
sleep 18
curl -fsS http://127.0.0.1:9090/api/v1/alerts
printf '\nSECTION ALERT VERIFIED RECOVERY\n'
docker start exporter
sleep 12
curl -fsS http://127.0.0.1:9090/api/v1/alerts
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=up{job="node"}'
