#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/devops-evidence
{
 minikube status
 kubectl get nodes
 kubectl cluster-info
 kubectl create namespace aditya-s9
 kubectl -n aditya-s9 create deployment hello --image=nginx:stable-alpine
 kubectl -n aditya-s9 rollout status deployment/hello --timeout=90s
 kubectl -n aditya-s9 get pods -o wide
 kubectl -n aditya-s9 expose deployment hello --port=80 --type=ClusterIP
 kubectl -n aditya-s9 get services
 kubectl -n aditya-s9 scale deployment hello --replicas=2
 kubectl -n aditya-s9 rollout status deployment/hello --timeout=60s
 kubectl -n aditya-s9 get pods
 kubectl -n aditya-s9 set image deployment/hello nginx=nginx:alpine
 kubectl -n aditya-s9 rollout status deployment/hello --timeout=90s
 kubectl -n aditya-s9 rollout history deployment/hello
 kubectl -n aditya-s9 exec deploy/hello -- wget -qO- http://hello | head -6
 kubectl -n aditya-s9 describe deployment hello
 kubectl delete namespace aditya-s9
} 2>&1 | tee /tmp/devops-evidence/s9-output.txt
