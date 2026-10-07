# VPC - Networking

A VPC is a logically isolated network with CIDR address ranges. Subnets divide it into address ranges within Availability Zones. Route tables choose network targets. Internet Gateway supplies internet routing; a public subnet has a route to it, while reachable IPv4 instances also need a public address and allowed traffic. Private subnets lack direct internet-gateway routing. A NAT Gateway permits outbound IPv4 flows for private clients but incurs separate costs. Security groups are stateful allow controls at interfaces; network ACLs are stateless subnet allow/deny controls, so return-path rules matter. Avoid overlapping CIDRs and unrestricted inbound access.

## Sources
- https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html
