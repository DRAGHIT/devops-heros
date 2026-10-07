# S3 - Storage

S3 stores objects identified by keys inside buckets, not attached block disks. Storage classes balance access frequency, retrieval requirements and availability design: Standard, Intelligent-Tiering, Standard-IA, One Zone-IA and Glacier variants are examples. Versioning preserves versions for recovery; a delete marker does not erase earlier versions. Lifecycle policies transition or expire objects, including noncurrent versions when configured. Server-side encryption protects stored data; access policy and encryption are separate controls. Bucket policies are resource policies; use least privilege and Block Public Access. Common uses: backups, static assets, data lakes and logs.

## Sources
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html
