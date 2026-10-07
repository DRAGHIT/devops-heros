#!/bin/bash
set -euxo pipefail
exec > >(tee /tmp/devops-evidence/s20-gitops.txt) 2>&1
for i in $(seq 1 36); do
kubectl -n aditya-s20-argocd get app aditya-session20
status=$(kubectl -n aditya-s20-argocd get app aditya-session20 -o jsonpath='{.status.sync.status}')
[ "$status" = Synced ] && break
sleep 5
done
kubectl -n aditya-s20-argocd get app aditya-session20 -o jsonpath='{.status.conditions}'
kubectl -n aditya-s20 rollout status deploy/aditya-s20-app --timeout=120s
kubectl -n aditya-s20 get deploy,pods,svc
kubectl -n aditya-s20 run client --image=busybox:1.36 --restart=Never --command -- sleep 3600
kubectl -n aditya-s20 wait pod/client --for=condition=Ready --timeout=90s
kubectl -n aditya-s20 exec client -- wget -qO- http://aditya-s20-app | head -15
kubectl -n aditya-s20 logs deploy/aditya-s20-app --tail=8
kubectl -n aditya-s20 top pods
printf '\nSECTION DRIFT\n'
kubectl -n aditya-s20 scale deploy/aditya-s20-app --replicas=1
kubectl -n aditya-s20 get deploy/aditya-s20-app
for i in $(seq 1 24);do
r=$(kubectl -n aditya-s20 get deploy/aditya-s20-app -o jsonpath='{.spec.replicas}')
[ "$r" = 2 ] && break
sleep 3
done
kubectl -n aditya-s20 get deploy,pods
kubectl -n aditya-s20-argocd get app aditya-session20 -o jsonpath='{.status.sync.status} {.status.health.status} {.status.sync.revision}'
