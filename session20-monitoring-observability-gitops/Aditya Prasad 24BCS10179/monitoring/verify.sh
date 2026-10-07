#!/bin/bash
set -euxo pipefail
exec > >(tee /tmp/devops-evidence/s20-monitor.txt) 2>&1
mkdir -p /tmp/s20-monitor
cat > /tmp/s20-monitor/prometheus.yml <<'YAML'
global:
  scrape_interval: 5s
  evaluation_interval: 5s
rule_files: [/etc/prometheus/alerts.yml]
scrape_configs:
- job_name: prometheus
  static_configs:
  - targets: [localhost:9090]
- job_name: node
  static_configs:
  - targets: [exporter:9100]
YAML
cat > /tmp/s20-monitor/alerts.yml <<'YAML'
groups:
- name: classroom
  rules:
  - alert: ExporterDown
    expr: up{job="node"} == 0
    for: 5s
    labels: {severity: warning}
    annotations: {summary: Classroom exporter unavailable}
YAML
docker network create aditya-s20-monitor
docker run -d --name exporter --network aditya-s20-monitor prom/node-exporter:latest
docker run -d --name aditya-s20-prom --network aditya-s20-monitor -p 127.0.0.1:9090:9090 -v /tmp/s20-monitor/prometheus.yml:/etc/prometheus/prometheus.yml:ro -v /tmp/s20-monitor/alerts.yml:/etc/prometheus/alerts.yml:ro prom/prometheus:v3.15.0
for i in $(seq 1 30);do curl -fsS http://127.0.0.1:9090/-/ready && break;sleep 2;done
sleep 12
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=up'
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=100 * (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[1m])))'
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)'
docker logs exporter --tail 8
printf '\nSECTION ALERT FAILURE\n'
docker stop exporter
sleep 18
curl -fsS http://127.0.0.1:9090/api/v1/alerts
printf '\nSECTION ALERT RECOVERY\n'
docker start exporter
sleep 12
curl -fsS http://127.0.0.1:9090/api/v1/alerts
curl -fsSG http://127.0.0.1:9090/api/v1/query --data-urlencode 'query=up{job="node"}'
kubectl top nodes
