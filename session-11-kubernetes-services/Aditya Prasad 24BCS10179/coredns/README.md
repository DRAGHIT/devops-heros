# CoreDNS

CoreDNS is a DNS server with plugins. Kubernetes commonly uses it for in-cluster discovery: clients query the cluster DNS Service, the kubernetes plugin answers Service/Pod names from Kubernetes objects, and the forward plugin sends external-name queries to upstream resolvers. This removes a need to hardcode changing Pod IPs.

Inspected the running CoreDNS Pod and kube-system/coredns ConfigMap. Actual Corefile includes kubernetes cluster.local, forward . /etc/resolv.conf, cache, errors, health, ready, reload and loop. See session evidence for the exact installed configuration; it can differ between clusters.

Troubleshooting steps: inspect Pod /etc/resolv.conf; nslookup a full Service name; compare an external domain; check namespace, Service selector and EndpointSlices; inspect kube-system DNS Pods, logs and Corefile; check upstream reachability and network policies. In this run the original ExternalName target returned NXDOMAIN, while example.com resolved. This isolated external target DNS failure from working cluster discovery.

Read commands: kubectl -n kube-system get pods -l k8s-app=kube-dns; kubectl -n kube-system get configmap coredns -o yaml. Changes to cluster DNS require care because all workloads use it.

Source: https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/
