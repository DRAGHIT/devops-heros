# Monitoring, observability and GitOps
Metrics are numeric time-series measurements, such as CPU, memory, error rate and request latency. Logs are time-stamped events explaining what a component did; correlate them with pod/release/request identifiers. Traces link spans across services to show a request path and latency contributions. Metrics indicate a symptom; logs and traces help explain it. Observability matters when an unknown failure cannot be answered by prewritten health checks alone.

Prometheus scrapes metrics and evaluates alert expressions; Alertmanager handles routing/grouping notifications. Grafana visualizes metrics; Loki or Elasticsearch can store logs; OpenTelemetry instrumentation/collectors and Jaeger or Tempo can support tracing. In Kubernetes, use readiness/liveness probes, kubectl logs/events/describe/top, node and workload metrics, and application instrumentation. A Ready Pod is not proof every business operation works.

This demo measures CPU/memory, reads process logs, checks HTTP health and tests an exporter-down alert. It documents traces but does not claim an installed distributed tracing stack or delivered external notifications. The exporter reports the runtime-visible Linux metrics, not an invented personal-device measurement.

GitOps keeps declared desired state in Git and continuously reconciles the cluster to it. A typical workflow reviews and commits YAML, a controller fetches it, compares with live state and syncs differences. Argo CD's Application specifies repository, branch and path. Automated selfHeal reverses drift made only in the cluster; desired changes should be committed to Git. Prune removes previously tracked resources no longer declared, so review destructive changes. CI builds/tests images; GitOps deploys declared state. Do not put credentials in public Git.

## Sources
- https://opentelemetry.io/docs/concepts/signals/traces/
- https://prometheus.io/docs/introduction/overview/
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/
- Teacher Session20 metrics/logs/traces and Argo mini-project.
