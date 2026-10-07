#!/bin/bash
set -euxo pipefail
mkdir -p /tmp/devops-evidence
exec > >(tee /tmp/devops-evidence/s15-output.txt) 2>&1
cd /tmp/s15-lab
kubectl create ns aditya-s15
helm version
helm create practice-chart
helm lint practice-chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm repo update
helm search repo bitnami/nginx --versions | head -8 || true
helm repo remove bitnami
helm lint notes-chart
helm template notes-dev notes-chart > /tmp/devops-evidence/s15-rendered.yaml
cat /tmp/devops-evidence/s15-rendered.yaml
helm install notes-dev notes-chart -n aditya-s15 --wait --timeout=180s
helm list -n aditya-s15
helm status notes-dev -n aditya-s15
helm get values notes-dev -n aditya-s15
helm get manifest notes-dev -n aditya-s15
kubectl -n aditya-s15 get deploy,pods,svc,cm
kubectl -n aditya-s15 exec deploy/notes-dev-deploy -- printenv APP_NAME ENVIRONMENT
kubectl -n aditya-s15 exec deploy/notes-dev-deploy -- curl -s localhost | head -15
printf '\nSECTION UPGRADE 1\n'
helm upgrade notes-dev notes-chart -n aditya-s15 -f notes-chart/values-prod.yaml --wait --timeout=180s
kubectl -n aditya-s15 get deploy,pods
kubectl -n aditya-s15 exec deploy/notes-dev-deploy -- printenv APP_NAME ENVIRONMENT
printf '\nSECTION UPGRADE 2\n'
helm upgrade notes-dev notes-chart -n aditya-s15 --set replicaCount=2 --set image.tag=1.26 --set app.environment=staging --wait --timeout=180s
kubectl -n aditya-s15 get deploy,pods
kubectl -n aditya-s15 exec deploy/notes-dev-deploy -- printenv APP_NAME ENVIRONMENT
helm history notes-dev -n aditya-s15
printf '\nSECTION ROLLBACK\n'
helm rollback notes-dev 1 -n aditya-s15 --wait --timeout=180s
helm history notes-dev -n aditya-s15
helm get values notes-dev -n aditya-s15 --all
kubectl -n aditya-s15 get deploy,pods
kubectl -n aditya-s15 exec deploy/notes-dev-deploy -- printenv APP_NAME ENVIRONMENT
kubectl -n aditya-s15 exec deploy/notes-dev-deploy -- curl -s localhost | head -15
helm uninstall notes-dev -n aditya-s15
helm list -n aditya-s15
kubectl delete ns aditya-s15 --wait=true --timeout=180s
