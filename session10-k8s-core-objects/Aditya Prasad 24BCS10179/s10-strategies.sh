#!/usr/bin/env bash
set -euo pipefail
cd /tmp;tar xzf session10-labs.tar.gz
cd session10-k8s-core-objects
kubectl create ns aditya-s10
k(){ kubectl -n aditya-s10 "$@"; }
{
k apply -f 01-rolling-update/deployment-v1.yaml -f 01-rolling-update/service.yaml
k rollout status deploy/app-rolling --timeout=90s
k get pods -L version
k apply -f 01-rolling-update/deployment-v2.yaml
k rollout status deploy/app-rolling --timeout=90s
k get rs
k get pods -L version
k apply -f 02-blue-green/deployment-blue.yaml -f 02-blue-green/deployment-green.yaml -f 02-blue-green/service-blue.yaml
k rollout status deploy/app-blue --timeout=90s
k rollout status deploy/app-green --timeout=90s
k exec deploy/app-blue -- wget -qO- http://myapp-service
k apply -f 02-blue-green/service-green.yaml
k exec deploy/app-green -- wget -qO- http://myapp-service
k apply -f 03-canary/
k rollout status deploy/app-stable --timeout=90s
k rollout status deploy/app-canary --timeout=90s
k get pods -l app=myapp-canary -L track
k get endpointslice -l kubernetes.io/service-name=myapp-canary-service
k exec deploy/app-canary -- sh -c 'for i in $(seq 1 30); do wget -qO- http://myapp-canary-service | grep -E "STABLE v1|CANARY v2";done'
k apply -f 04-recreate/deployment-v1.yaml -f 04-recreate/service.yaml
k rollout status deploy/app-recreate --timeout=90s
k apply -f 04-recreate/deployment-v2.yaml
k rollout status deploy/app-recreate --timeout=90s
k describe deploy app-recreate
k get pods -L version
} 2>&1 | tee /tmp/devops-evidence/s10-strategies.txt
