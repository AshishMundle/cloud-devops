# RDS Basics

## Overview

Wrapped up the AWS stretch with databases — core DBMS concepts, relational vs NoSQL vs time-series engines, and the networking/security model RDS runs on. Closed out with hands-on creation (and teardown) of both PostgreSQL and MySQL RDS instances.

## Topics Covered

**Database fundamentals**
DBMS core concepts, SQL vs NoSQL, OLTP vs OLAP, and the three database categories covered — relational (MySQL, Oracle, PostgreSQL), NoSQL/document (MongoDB, Cassandra), and time-series (Prometheus).

**VPC & networking for RDS**
Public vs private subnet placement, Internet Gateway vs NAT Gateway, Route Tables, and Security Groups — specifically in the context of why databases belong in private subnets, accessed via a jump host.

**RDS vs self-managed databases**
Comparing a self-managed MySQL-on-EC2 setup against AWS RDS — patching, backups, scaling, and HA responsibility shifts from you to AWS with RDS.

**Production database security practices**
Encryption at rest/in transit, automated backup retention (7-90 days), Multi-AZ high availability, bastion host access patterns, read-only permission grants, enhanced monitoring, and credential rotation via Secrets Manager.

## Hands-on — RDS Creation

- Created both a PostgreSQL and a MySQL database instance through the AWS RDS console, using both the full-configuration and free-tier setup paths
- Configured auto-generated master passwords and reviewed authentication models (password-based vs IAM database authentication)
- Placed the instance in a private subnet to keep it isolated from direct internet access
- Enabled monitoring and retrieved the database endpoint and credentials once the instance was active
- Deleted both RDS instances after the exercise to avoid ongoing charges — standard cost hygiene for lab work

## Diagram 1 — Connecting to Private RDS via Public EC2 Jump Host

```mermaid
flowchart LR
    Internet((Internet)) -->|SSH| IGW[Internet Gateway]
    IGW --> PubSG[Security Group]
    subgraph AWSCloud[AWS Cloud - Availability Zone]
        subgraph PublicSubnet[Public Subnet]
            PubSG --> EC2[EC2 Instance<br/>Jump Host / Bastion]
        end
        subgraph PrivateSubnet[Private Subnet]
            PrivSG[Security Group]
            EC2 -->|SSH| PrivSG
            PrivSG --> RDS[(RDS Database<br/>MySQL)]
        end
    end

    style Internet fill:#2b2b2b,stroke:#fff,color:#fff
    style IGW fill:#5b4fc4,stroke:#fff,color:#fff
    style PubSG fill:#e8c547,stroke:#333,color:#000
    style PrivSG fill:#4fa3d1,stroke:#333,color:#000
    style EC2 fill:#e8823c,stroke:#333,color:#000
    style RDS fill:#c44fb3,stroke:#333,color:#fff
    style PublicSubnet fill:#fdf1d6,stroke:#e8c547,color:#000
    style PrivateSubnet fill:#dbeefb,stroke:#4fa3d1,color:#000
```

*The RDS instance sits in a private subnet with no direct internet access. To reach it, traffic goes: Internet → Internet Gateway → public EC2 jump host (bastion) → private subnet security group → RDS. This keeps the database itself never directly exposed.*

## Diagram 2 — Self-Managed Database vs AWS RDS

```mermaid
flowchart LR
    subgraph SelfManaged[Self-Managed - MySQL on EC2]
        A1[You: Install and configure DB]
        A2[You: OS patching]
        A3[You: Backups and scaling]
        A4[You: HA cluster setup]
        A5[You: Need dedicated DBA team]
    end
    subgraph RDSManaged[AWS RDS]
        B1[AWS: DB engine setup]
        B2[AWS: OS patching]
        B3[AWS: Automated backups]
        B4[AWS: Multi-AZ HA]
        B5[You: Just use the database]
    end

    style SelfManaged fill:#fde2e2,stroke:#d64545,color:#000
    style RDSManaged fill:#e2f7e2,stroke:#45a845,color:#000
```

## KEY Notes

- **Why databases go in private subnets:** prevents direct internet exposure, reducing risk of SQL injection and unauthorized data access — access is routed through a bastion host or application layer instead.
- **NAT Gateway vs Internet Gateway:** IGW allows public subnet resources to be reached from the internet; NAT Gateway lets private subnet resources initiate outbound connections (e.g. updates) without allowing inbound access.
- **RDS vs self-managed:** RDS removes OS patching, backup scripting, and HA clustering from your plate — trades some control for significantly less operational overhead.
- **MySQL port:** 3306, standard default for MySQL connections.
- **Multi-AZ:** deploying across multiple Availability Zones for automatic failover if one AZ has an outage.
