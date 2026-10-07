#!/usr/bin/env bash
set -euo pipefail
exec > >(tee /tmp/devops-evidence/s13-output.txt) 2>&1
cd /tmp;tar xzf s13-lab.tar.gz
kubectl create ns aditya-s13
kubectl create ns aditya-s13-mini
k(){ kubectl -n aditya-s13 "$@"; }
m(){ kubectl -n aditya-s13-mini "$@"; }
k apply -f s13-lab/hpa/
m apply -f s13-lab/mini-project/
k rollout status deploy/hpa-demo --timeout=90s
m rollout status deploy/web-app --timeout=90s
m get pvc; kubectl get sc
old=$(m get pods -l app=web-app -o jsonpath='{.items[0].metadata.name}')
m exec "$old" -- sh -c 'printf "Aditya Prasad 24BCS10179\n" > /data/student.txt'
m exec "$old" -- cat /data/student.txt
m delete pod "$old" --wait=true
m rollout status deploy/web-app --timeout=90s
new=$(m get pods -l app=web-app -o jsonpath='{.items[0].metadata.name}')
printf '\nAFTER POD REPLACEMENT\n';m exec "$new" -- cat /data/student.txt
m describe deploy web-app
m run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c 'while true; do wget -q -O- http://web-service >/dev/null;done'
k run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c 'while true; do wget -q -O- http://hpa-demo-service >/dev/null;done'
for i in $(seq 1 8);do printf '\nHPA SAMPLE %s\n' "$i";k get hpa;m get hpa;k top pods || true;m top pods || true;k get pods;m get pods;sleep 20;done
k describe hpa hpa-demo;m describe hpa web-app-hpa
k delete pod load-generator;m delete pod load-generator
printf '\nLOAD STOPPED\n'
k get hpa;m get hpa
kubectl delete ns aditya-s13 aditya-s13-mini --wait=false
