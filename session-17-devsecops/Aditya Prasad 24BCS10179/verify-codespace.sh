#!/bin/bash
set -euxo pipefail
mkdir -p /tmp/devops-evidence
exec > >(tee /tmp/devops-evidence/s17-output.txt) 2>&1
cd /tmp/s17-lab
/opt/python/3.13.8/bin/python3.13 -m venv .venv313
. .venv313/bin/activate
pip install -r requirements-dev.txt
printf '\nSECTION TESTS\n'
python -m pytest --cov=app --cov-report=term-missing
printf '\nSECTION SAST\n'
bandit -r app -c bandit.yaml -f json -o /tmp/devops-evidence/s17-bandit.json
python -c 'import json; d=json.load(open("/tmp/devops-evidence/s17-bandit.json")); assert not d["errors"] and not d["results"]'
cat /tmp/devops-evidence/s17-bandit.json
printf '\nSECTION SCA\n'
pip-audit -r requirements.txt --format json -o /tmp/devops-evidence/s17-sca.json
cat /tmp/devops-evidence/s17-sca.json
printf '\nSECTION SECRETS\n'
mkdir -p /tmp/scanners
curl -fsSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar -xz -C /tmp/scanners gitleaks
/tmp/scanners/gitleaks dir app --no-banner
/tmp/scanners/gitleaks dir tests --no-banner
printf '\nSECTION BUILD AND IMAGE SCAN\n'
docker build -t aditya-session17:verified .
curl -fsSL https://github.com/aquasecurity/trivy/releases/download/v0.75.0/trivy_0.75.0_Linux-64bit.tar.gz | tar -xz -C /tmp/scanners trivy
/tmp/scanners/trivy image --exit-code 1 --severity HIGH,CRITICAL --format json --output /tmp/devops-evidence/s17-trivy.json aditya-session17:verified
printf '\nSECTION GATE PASSED REGISTRY\n'
docker run -d --name aditya-s17-registry -p 127.0.0.1:5002:5000 registry:2
docker tag aditya-session17:verified localhost:5002/aditya-session17:verified
docker push localhost:5002/aditya-session17:verified
docker pull localhost:5002/aditya-session17:verified
printf '\nSECTION DEPLOY\n'
minikube image load localhost:5002/aditya-session17:verified
kubectl create ns aditya-s17
sed 's#image: aditya-session17:verified#image: localhost:5002/aditya-session17:verified#' k8s/deployment.yaml | kubectl -n aditya-s17 apply -f -
kubectl -n aditya-s17 apply -f k8s/service.yaml
kubectl -n aditya-s17 rollout status deploy/session17-app --timeout=180s
kubectl -n aditya-s17 get pods -o wide
kubectl -n aditya-s17 logs deploy/session17-app
kubectl -n aditya-s17 exec deploy/session17-app -- python -c 'import urllib.request; print(urllib.request.urlopen("http://session17-app/health").read().decode())'
kubectl delete ns aditya-s17 --wait=true --timeout=180s
docker rm -f aditya-s17-registry
