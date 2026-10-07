#!/usr/bin/env bash
set -euo pipefail
exec > >(tee /tmp/devops-evidence/s12-output.txt) 2>&1
cd /tmp;tar xzf s12-lab.tar.gz
minikube addons enable ingress
kubectl wait -n ingress-nginx --for=condition=Ready pod -l app.kubernetes.io/component=controller --timeout=180s
kubectl create ns aditya-s12
k(){ kubectl -n aditya-s12 "$@"; }
k apply -f s12-lab/configmap.yaml
k create secret generic yatri-db-secret --from-literal=POSTGRES_USER=classroom_user --from-literal=POSTGRES_DB=classroom_db --from-literal=POSTGRES_PASSWORD=classroom-only-demo-value
k describe configmap yatri-app-config;k describe secret yatri-db-secret
k apply -f s12-lab/backend.yaml -f s12-lab/frontend.yaml
k rollout status deploy/yatri-backend --timeout=120s
k rollout status deploy/yatri-frontend --timeout=120s
k exec deploy/yatri-backend -- sh -c 'printf "CONFIG: %s %s %s\n" "$ENVIRONMENT" "$LOG_LEVEL" "$DEFAULT_CURRENCY"; test "$POSTGRES_PASSWORD" = classroom-only-demo-value && echo "SECRET value matches runtime test value (not printed)"'
k apply -f s12-lab/ingress.yaml
for i in $(seq 1 40);do ip=$(k get ingress yatri-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}');[ -n "$ip" ] && break;sleep 2;done
k describe ingress yatri-ingress
printf '\nFRONTEND ROUTE\n';curl -fsS --resolve "yatri.local:80:$(minikube ip)" http://yatri.local/ | head -15
printf '\nBACKEND ROUTE\n';curl -fsS --resolve "yatri.local:80:$(minikube ip)" http://yatri.local/api/
printf '\nWRONG HOST\n';curl -sS --resolve "wrong.local:80:$(minikube ip)" -o /tmp/wrong-host-body -w '%{http_code}\n' http://wrong.local/;cat /tmp/wrong-host-body
printf '\nTRAILING NEWLINE BEFORE AND AFTER\n'
echo classroom-demo | base64;echo -n classroom-demo | base64
k create secret generic newline-demo --from-literal=VALUE="$(echo classroom-demo | base64)"
k get secret newline-demo -o jsonpath='{.data.VALUE}' | base64 -d | base64 -d | od -An -t x1
k delete secret newline-demo
k create secret generic newline-demo --from-literal=VALUE="$(printf classroom-demo | base64)"
k get secret newline-demo -o jsonpath='{.data.VALUE}' | base64 -d | base64 -d | od -An -t x1
printf '\nFINAL OBJECTS\n';k get pods,svc,configmap,secret,ingress
kubectl delete ns aditya-s12 --wait=true
