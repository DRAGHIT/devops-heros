#!/bin/bash
set -x
exec > >(tee /tmp/devops-evidence/s14-extra.txt) 2>&1
kubectl create ns aditya-s14-extra
kubectl -n aditya-s14-extra apply -f /tmp/s14-lab/06-crashloopbackoff/broken-pod.yaml
for i in $(seq 1 24); do kubectl -n aditya-s14-extra get pod crash-demo; reason=$(kubectl -n aditya-s14-extra get pod crash-demo -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}'); [ "$reason" = CrashLoopBackOff ] && break; sleep 3; done
kubectl -n aditya-s14-extra logs crash-demo
kubectl -n aditya-s14-extra describe pod crash-demo
kubectl -n aditya-s14-extra delete pod crash-demo --wait=true
kubectl -n aditya-s14-extra apply -f /tmp/s14-lab/06-crashloopbackoff/fixed-pod.yaml
kubectl -n aditya-s14-extra wait pod/crash-demo --for=condition=Ready --timeout=90s
kubectl -n aditya-s14-extra logs crash-demo
kubectl -n kube-system rollout restart deploy/metrics-server
kubectl -n kube-system rollout status deploy/metrics-server --timeout=150s
sleep 65
kubectl -n aditya-s14-extra top pods
kubectl top nodes
kubectl delete ns aditya-s14-extra --wait=true --timeout=180s
