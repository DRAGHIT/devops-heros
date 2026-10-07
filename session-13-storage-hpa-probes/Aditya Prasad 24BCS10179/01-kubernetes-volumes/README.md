# Kubernetes volumes

Student: Aditya Prasad, 24BCS10179

| Resource | What it means | Use / limit |
|---|---|---|
| emptyDir | Created for a Pod on its assigned node. Shared by containers, survives container restart, removed when the Pod is removed | Scratch/cache or init-container handoff. Not persistent across Pod replacement; memory medium consumes memory |
| hostPath | Mounts a path from the node filesystem | Node agents/local labs. Host access is a security risk; data is node-dependent, not portable or automatically shared between nodes |
| PersistentVolume | Cluster storage resource with capacity, access modes, reclaim policy and backing driver | Static storage or dynamically provisioned storage |
| PersistentVolumeClaim | Namespaced request for storage; binds a compatible PV | Pod refers to claimName and mounts it rather than embedding infrastructure details |
| StorageClass | Provisioner and parameters that define a storage tier, binding/reclaim behavior | Select a suitable CSI driver/class; cluster administrator controls options |
| Dynamic provisioning | A PVC can trigger storage creation through its StorageClass | Reduces manual PV management. Pending can mean driver/capacity/access-mode problems or delayed binding |

Actual mini-project: web-data requested 500Mi RWO and bound through the standard Minikube hostpath class (Delete reclaim policy, Immediate binding). Mounted at /data. Wrote Aditya Prasad 24BCS10179 to student.txt, deleted one Pod and checked the file after replacement. See session evidence, including the explicitly named replacement Pod check.

RWO means read/write by a single node, not necessarily a single Pod. This single-node lab allows multiple replicas to mount the same claim. That is not proof a multi-node production deployment can scale shared RWO storage safely. A StatefulSet with per-Pod PVCs or suitable RWX storage may be required by the application's real design. Deleting the PVC with Delete reclaim policy can delete backing data.

Illustrative Pod fragments (not claimed as separate executed volume labs):

```yaml
volumes:
  - name: scratch
    emptyDir: {}
  - name: node-data
    hostPath:
      path: /var/lab-data
      type: DirectoryOrCreate
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: web-data
```

Pair each name with a volumeMounts entry and mountPath. The mini-project includes the actual PVC and volumeMounts YAML used.

Sources:
- https://kubernetes.io/docs/concepts/storage/volumes/
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- https://kubernetes.io/docs/concepts/storage/storage-classes/
