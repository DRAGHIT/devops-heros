#!/usr/bin/env bash
set -euo pipefail
cd /tmp;tar xzf s11-labs.tar.gz
kubectl create namespace aditya-s11
k(){ kubectl -n aditya-s11 "$@"; }
exec > >(tee /tmp/devops-evidence/s11-output.txt) 2>&1
cd /tmp/session-11-kubernetes-services
k apply -f 01-clusterip/ -f 02-nodeport/ -f 03-loadbalancer/ -f 04-externalname/ -f 05-headless/
for d in web-app-clusterip web-app-nodeport web-app-loadbalancer;do k rollout status deployment/$d --timeout=120s;done
k rollout status statefulset/web-stateful --timeout=120s
for p in curl-client dns-test-client headless-dns-client;do k wait pod/$p --for=condition=Ready --timeout=120s;done
k get pods -o wide;k get services;k get endpointslice
printf '\nCLUSTERIP HTTP\n';k exec curl-client -- curl -fsS http://web-service-clusterip:8080 | head -15
printf '\nNODEPORT HTTP\n';curl -fsS --max-time 10 "http://$(minikube ip):30080" | head -15
printf '\nLOADBALANCER BEFORE LOCAL TUNNEL\n';k get service web-service-loadbalancer
minikube tunnel --cleanup=true >/tmp/s11-tunnel.log 2>&1 & tunnel=$!
trap 'kill "$tunnel" 2>/dev/null || true' EXIT
for i in $(seq 1 30);do ip=$(k get svc web-service-loadbalancer -o jsonpath='{.status.loadBalancer.ingress[0].ip}');[ -n "$ip" ] && break;sleep 2;done
k get svc web-service-loadbalancer
printf '\nLOADBALANCER HTTP VIA LOCAL TUNNEL\n';curl -fsS --max-time 10 "http://$ip" | head -15
printf '\nEXTERNALNAME DNS AND HTTP\n';k exec dns-test-client -- nslookup external-database-service.aditya-s11.svc.cluster.local || true
k exec dns-test-client -- curl -IL --max-time 15 http://external-database-service || true
printf '\nHEADLESS DNS\n';k exec headless-dns-client -- nslookup web-service-headless.aditya-s11.svc.cluster.local
k exec headless-dns-client -- nslookup web-stateful-0.web-service-headless.aditya-s11.svc.cluster.local
printf '\nHEADLESS HTTP\n';k exec headless-dns-client -- curl -fsS http://web-stateful-0.web-service-headless:80 | head -15
printf '\nCOREDNS CONFIG AND STATUS\n';kubectl -n kube-system get pods -l k8s-app=kube-dns;kubectl -n kube-system get configmap coredns -o yaml
kill "$tunnel" 2>/dev/null || true;wait "$tunnel" || true
kubectl delete namespace aditya-s11 --wait=true
