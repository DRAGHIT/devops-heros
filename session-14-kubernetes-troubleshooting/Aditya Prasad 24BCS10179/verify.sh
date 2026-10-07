#!/bin/bash
set -u
mkdir -p /tmp/devops-evidence
exec > >(tee /tmp/devops-evidence/s14-output.txt) 2>&1
set -x
kubectl create ns aditya-s14
k(){ kubectl -n aditya-s14 "$@"; }
base=/tmp/s14-lab
k apply -f "$base/mini-project/deployment.yaml"
k apply -f "$base/mini-project/service.yaml"
k rollout status deploy/troubleshooting-app --timeout=180s
k run client --image=busybox:1.36 --restart=Never --command -- sleep 3600
k wait pod/client --for=condition=Ready --timeout=120s
k get pods -o wide
k describe svc troubleshooting-service
k logs deploy/troubleshooting-app
k exec deploy/troubleshooting-app -- curl -s localhost
k events
k explain pod.spec.containers
k top pods
printf '\nSECTION CRASHLOOP\n'
k apply -f "$base/06-crashloopbackoff/broken-pod.yaml"
sleep 15
k get pod crash-demo
k logs crash-demo --previous || k logs crash-demo
k describe pod crash-demo
k delete pod crash-demo --wait=true
k apply -f "$base/06-crashloopbackoff/fixed-pod.yaml"
k wait pod/crash-demo --for=condition=Ready --timeout=90s
k logs crash-demo
printf '\nSECTION IMAGEPULL\n'
k apply -f "$base/mini-project/broken-pod.yaml"
for i in $(seq 1 18); do k get pod project-broken-pod; state=$(k get pod project-broken-pod -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}'); [ "$state" = ImagePullBackOff ] && break; sleep 5; done
k describe pod project-broken-pod
k set image pod/project-broken-pod app=nginx:1.27
k wait pod/project-broken-pod --for=condition=Ready --timeout=120s
k get pod project-broken-pod
printf '\nSECTION PENDING\n'
k apply -f "$base/08-pending-pods/broken-pod.yaml"
sleep 3
k get pod pending-demo
k describe pod pending-demo
k delete pod pending-demo --wait=true
k apply -f "$base/08-pending-pods/fixed-pod.yaml"
k wait pod/pending-demo --for=condition=Ready --timeout=90s
printf '\nSECTION CONTAINERCREATING\n'
k apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata: {name: volume-demo}
spec:
  containers:
  - name: app
    image: nginx:1.27
    volumeMounts: [{name: config, mountPath: /etc/demo}]
  volumes:
  - name: config
    configMap: {name: missing-config}
YAML
sleep 10
k get pod volume-demo
k describe pod volume-demo
k create configmap missing-config --from-literal=student=24BCS10179
k wait pod/volume-demo --for=condition=Ready --timeout=180s
k exec volume-demo -- cat /etc/demo/student
printf '\nSECTION CONFIGURATION\n'
k apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata: {name: env-demo}
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: [sh, -c, 'echo $STUDENT; sleep 3600']
    env:
    - name: STUDENT
      valueFrom:
        configMapKeyRef: {name: missing-env, key: student}
YAML
sleep 5
k get pod env-demo
k describe pod env-demo
k create configmap missing-env --from-literal=student=24BCS10179
k wait pod/env-demo --for=condition=Ready --timeout=180s
k logs env-demo
printf '\nSECTION SERVICE SELECTOR\n'
k patch svc troubleshooting-service -p '{"spec":{"selector":{"app":"wrong-app"}}}'
sleep 3
k get pods --show-labels
k get endpointslices -l kubernetes.io/service-name=troubleshooting-service
k describe svc troubleshooting-service
k exec client -- wget -T 3 -qO- http://troubleshooting-service || true
k patch svc troubleshooting-service -p '{"spec":{"selector":{"app":"troubleshooting-app"}}}'
sleep 3
k get endpointslices -l kubernetes.io/service-name=troubleshooting-service
k exec client -- wget -T 5 -qO- http://troubleshooting-service
printf '\nSECTION POD NETWORK PORT\n'
podip=$(k get pod -l app=troubleshooting-app -o jsonpath='{.items[0].status.podIP}')
k exec client -- wget -T 3 -qO- "http://$podip:81" || true
k exec client -- wget -T 5 -qO- "http://$podip:80"
printf '\nSECTION DNS\n'
k exec client -- nslookup nonexistent-service.aditya-s14.svc.cluster.local || true
k exec client -- cat /etc/resolv.conf
k get svc troubleshooting-service
k exec client -- nslookup troubleshooting-service.aditya-s14.svc.cluster.local
k exec client -- wget -T 5 -qO- http://troubleshooting-service.aditya-s14.svc.cluster.local
printf '\nSECTION FINAL\n'
k get pods -o wide
k top pods
kubectl delete ns aditya-s14 --wait=true --timeout=180s
kubectl get ns aditya-s14 || true
