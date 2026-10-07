# FQDN in Kubernetes

A fully qualified domain name gives the complete DNS name to its domain root. Service form: <service>.<namespace>.svc.<cluster-domain>, commonly cluster.local. A final dot can explicitly mark an absolute DNS name.

Our tested example: web-service-clusterip.aditya-s11.svc.cluster.local. In aditya-s11 a Pod can use web-service-clusterip; from another namespace use web-service-clusterip.aditya-s11 or the full name. Pod /etc/resolv.conf search domains allow short-name expansion.

The headless StatefulSet example is web-stateful-0.web-service-headless.aditya-s11.svc.cluster.local. Its DNS result is that Pod's IP, while the headless Service name returns eligible Pod addresses. Normal Service names return the Service cluster IP. ExternalName creates a CNAME mapping to the configured external domain.

Actual DNS/HTTP checks are linked from the session README. Source: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
