# Multi Tier Architecture

## Overview

This Terraform configuration establishes a robust, scalable, self-healing, and resilient infrastructure on Amazon Web Services (AWS), designed to host a comprehensive full-stack web application.

The configuration incorporates a Virtual Private Cloud (VPC) to set up a secure, isolated virtual network spread across multiple Availability Zones. It deploys EC2 instances to provide the necessary computing resources. Auto Scaling Groups (ASGs) are used to ensure the optimal number of instances are always maintained, adjusting to the demand in real-time. Application Load Balancers (ALBs) are included to efficiently distribute incoming application traffic across multiple EC2 instances, enhancing the application’s availability and fault tolerance.

In addition to the mentioned resources, this configuration includes Route53 for DNS management, Amazon Certificate Manager (ACM) for managing SSL/TLS certificates, RDS for relational database service, IAM roles for managing permissions, SSM for storing database credentials securely, and CloudWatch for monitoring and observability.

## Deployed Services

- R53
- VPC
- EC2
- ASG
- ALB
- RDS
- ACM
- SSM

## Architecture

![Multi-Tier-Architecture-Diagram](./assets/multi-tier-architecture.drawio.svg)
