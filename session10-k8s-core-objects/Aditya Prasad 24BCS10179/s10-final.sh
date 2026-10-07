#!/usr/bin/env bash
set -euo pipefail
cd /tmp/session10-k8s-core-objects
for f in pod-lifecycle/*.yaml;do
 name=$(awk '/name: lifecycle-/{print $2;exit}' "$f")
 { echo "FILE: $f";kubectl -n aditya-s10 get pod "$name";kubectl -n aditya-s10 describe pod "$name";} > "/tmp/devops-evidence/s10-lifecycle/$name.txt"
done
kubectl -n aditya-s10 get pods | tee /tmp/devops-evidence/s10-lifecycle-summary.txt
kubectl -n aditya-s10 exec deploy/app-green -- wget -qO- http://myapp-service > /tmp/devops-evidence/s10-green-confirmed.txt
kubectl -n aditya-s10 delete pod lifecycle-termination --wait=false
kubectl -n aditya-s10 get pod lifecycle-termination >> /tmp/devops-evidence/s10-lifecycle/lifecycle-termination.txt
kubectl -n aditya-s10 wait --for=delete pod/lifecycle-termination --timeout=35s >> /tmp/devops-evidence/s10-lifecycle/lifecycle-termination.txt
kubectl delete namespace aditya-s10 --wait=false
