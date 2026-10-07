#!/usr/bin/env bash
set -eu
exec > >(tee /tmp/devops-evidence/s11-external-fix.txt) 2>&1
kubectl create ns aditya-s11
kubectl -n aditya-s11 apply -f /tmp/session-11-kubernetes-services/04-externalname/
kubectl -n aditya-s11 wait pod/dns-test-client --for=condition=Ready --timeout=90s
printf '\nORIGINAL TARGET DIRECT DNS CHECK\n'
kubectl -n aditya-s11 exec dns-test-client -- nslookup nencyravaliya.me || true
printf '\nCONTROL EXTERNAL TARGET\n'
kubectl -n aditya-s11 exec dns-test-client -- nslookup example.com
kubectl -n aditya-s11 patch svc external-database-service -p '{"spec":{"externalName":"example.com"}}'
kubectl -n aditya-s11 exec dns-test-client -- nslookup external-database-service.aditya-s11.svc.cluster.local
kubectl -n aditya-s11 exec dns-test-client -- curl -IL --max-time 30 http://external-database-service || true
kubectl delete ns aditya-s11
