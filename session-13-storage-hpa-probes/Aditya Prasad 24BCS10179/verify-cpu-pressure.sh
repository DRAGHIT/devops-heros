#!/usr/bin/env bash
set -eu
exec > >(tee /tmp/devops-evidence/s13-scale.txt) 2>&1
for ns in aditya-s13-scale aditya-s13-mini-scale;do kubectl create ns "$ns";done
for f in /tmp/s13-lab/hpa/*.yaml;do kubectl -n aditya-s13-scale apply -f "$f";done
for f in /tmp/s13-lab/mini-project/*.yaml;do sed 's/aditya-s13-mini/aditya-s13-mini-scale/g' "$f" | kubectl apply -f -;done
kubectl -n aditya-s13-scale rollout status deploy/hpa-demo --timeout=90s
kubectl -n aditya-s13-mini-scale rollout status deploy/web-app --timeout=90s
for pair in 'aditya-s13-scale hpa-demo' 'aditya-s13-mini-scale web-app';do set -- $pair
kubectl -n "$1" exec deploy/"$2" -- sh -c 'nohup sh -c "while true;do sha256sum /dev/zero;done" >/dev/null 2>&1 </dev/null &' || true
done
for i in $(seq 1 8);do echo "CPU PRESSURE SAMPLE $i";kubectl -n aditya-s13-scale get hpa,pods;kubectl -n aditya-s13-mini-scale get hpa,pods;kubectl -n aditya-s13-scale top pods || true;kubectl -n aditya-s13-mini-scale top pods || true;sleep 20;done
kubectl -n aditya-s13-scale describe hpa hpa-demo
kubectl -n aditya-s13-mini-scale describe hpa web-app-hpa
kubectl delete ns aditya-s13-scale aditya-s13-mini-scale --wait=false
