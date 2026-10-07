#!/bin/bash
set -euxo pipefail
exec > >(tee /tmp/devops-evidence/s15-bad.txt) 2>&1
cd /tmp/s15-lab
kubectl create ns aditya-s15-bad
helm install notes-recovery notes-chart -n aditya-s15-bad --wait --timeout=180s
helm upgrade notes-recovery notes-chart -n aditya-s15-bad -f notes-chart/values-prod.yaml --wait --timeout=180s
helm upgrade notes-recovery notes-chart -n aditya-s15-bad -f notes-chart/values-prod.yaml --set image.tag=broken-tag-does-not-exist
for i in $(seq 1 18); do kubectl -n aditya-s15-bad get pods; kubectl -n aditya-s15-bad get pods -o jsonpath='{.items[*].status.containerStatuses[*].state.waiting.reason}' | grep ImagePullBackOff && break; sleep 5; done
kubectl -n aditya-s15-bad get events --sort-by=.lastTimestamp | tail -25
helm rollback notes-recovery 2 -n aditya-s15-bad --wait --timeout=180s
helm history notes-recovery -n aditya-s15-bad
kubectl -n aditya-s15-bad get deploy,pods
kubectl -n aditya-s15-bad exec deploy/notes-recovery-deploy -- printenv ENVIRONMENT
helm uninstall notes-recovery -n aditya-s15-bad
kubectl delete ns aditya-s15-bad --wait=true --timeout=180s
