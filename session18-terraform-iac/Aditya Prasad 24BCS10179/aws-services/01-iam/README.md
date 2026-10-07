# IAM - Governance

IAM controls authentication and authorization. A user is an identity; a group collects users and permissions; a role is assumed by a workload or person using temporary credentials. Policies describe allowed/denied actions and resource scope, commonly as JSON. Permission evaluation considers identity/resource policies and applicable boundaries; explicit deny overrides allow. Least privilege means only necessary actions and resources, reviewed over time. Prefer federation/Identity Center for people, roles for workloads, MFA, protected root account, no root everyday use, and avoid long-lived keys. Example: an EC2 workload assumes a role that reads one S3 prefix, rather than sharing an administrator key.

## Sources
- https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
