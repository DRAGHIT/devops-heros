# EC2 - Compute

EC2 provides virtual server instances. An AMI specifies launch software/root-volume image; instance type selects compute/memory capabilities. A key pair supplies public-key login identity, not security-group permission. Security groups are stateful traffic allow rules attached to network interfaces. EBS provides block storage; root and data volumes have lifecycle settings independent of the instance. Private IPs work in the VPC; public addresses and routing enable internet reachability when firewall rules permit. Lifecycle includes pending, running, stopping, stopped and terminated. Stopping does not delete all storage or remove every charge; termination and volume policy matter. Use cases include application servers, batch jobs and self-managed databases.

## Sources
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html
