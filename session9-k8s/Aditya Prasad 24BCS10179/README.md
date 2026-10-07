# Session 9 - Kubernetes Fundamentals

Student: Aditya Prasad  
Roll Number: 24BCS10179

## Tasks and setup

Configured Minikube in the student Codespace with `minikube start --driver=docker --cpus=2 --memory=3000`. Minikube/kubectl were already installed; checked their functioning rather than claiming to install pre-existing tools. The cluster initially had CNI ImagePullBackOff because the Docker host's legacy forwarding rules blocked registry DNS. A temporary rule scoped to the Minikube bridge fixed registry access. The node became Ready, with CoreDNS and system pods running.

## Hands-on tutorial

Ran the Kubernetes Basics workflow using an Nginx demo: cluster status, deployment, pod inspection, service exposure, in-cluster HTTP access, scaling from one to two replicas, image update and rollout history. `kubectl describe deployment` confirmed two available updated replicas and the old ReplicaSet scaled to zero. The namespace was deleted after testing.

[terminal-output.txt](terminal-output.txt) contains the actual complete result. [verify-kubernetes.sh](verify-kubernetes.sh) contains the executed workflow; run only against a disposable lab cluster because it creates/deletes its `aditya-s9` namespace. The implementation follows the tutorial's concepts with an Nginx application, rather than claiming to reproduce every upstream demo image.

## Architecture and basic objects

The control plane includes API server (API entry point), etcd (cluster state), scheduler (assigns unscheduled Pods) and controller manager (reconciles desired state). Worker-node kubelet runs/manages containers via the runtime; networking makes Pods/Services reachable. A Pod is a runnable unit, a Deployment manages ReplicaSets and updates, and a Service provides a stable route to selected Pods. This demo verified these objects with `get`, `describe`, `exec`, `scale` and rollout commands.

## Status

Cluster setup and deploy/explore/expose/scale/update lab verified with real output. Screenshot evidence is being recorded separately; no fabricated screenshots or cluster output.

## Sources

- [Assignment document](https://docs.google.com/document/d/1cjXFYf2Thm8cBEN-0C48B-v02cj3jGLd47lcO18prHE/edit?tab=t.0)
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Kubernetes architecture](https://kubernetes.io/docs/concepts/architecture/)
