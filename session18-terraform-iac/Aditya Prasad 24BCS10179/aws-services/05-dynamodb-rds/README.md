# DynamoDB and RDS

DynamoDB is managed serverless NoSQL storage. Tables contain items with attributes. A partition key determines placement; an optional sort key orders items within a partition key. Design keys from access patterns; examples include session data, carts and event metadata.

RDS manages relational database infrastructure and common tasks, while the user still owns schema, query tuning and access. Engines in the current RDS guide include Db2, MariaDB, SQL Server, MySQL, Oracle and PostgreSQL; Aurora has its separate guide. DB instances use an instance class/storage configuration; protect them with private VPC placement, security groups, encryption and scoped credentials. Automated backups/snapshots support recovery. Multi-AZ designs focus on availability; traditional standby is not a read-scaling endpoint. Read replicas generally use asynchronous replication for read workloads and may lag; do not equate them with backups. Use RDS for relational transactions and SQL access.

## Sources
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html
