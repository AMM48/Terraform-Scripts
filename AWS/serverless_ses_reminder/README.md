# Serverless Email Reminder

## Overview

This Terraform configuration establishes a serverless reminder system designed to send notifications via email, leveraging a variety of AWS services to ensure scalability, and high availability.

It utilizes Amazon Simple Email Service (SES) for email notifications and AWS Lambda for executing the application logic. The lambda function is triggered by a step function that interacts with Amazon API Gateway, which provides a secure RESTful API interface for the frontend to communicate with the backend.

The frontend is hosted in an Amazon S3 bucket, with CloudFront ensuring global distribution and low latency. Amazon Route 53 handles DNS management for reliable request routing, while Amazon Certificate Manager (ACM) secures communications with SSL/TLS certificates.

In addition to the mentioned resources, this configuration includes IAM roles for managing permissions, and CloudWatch for logging events.

## Deployed Services

- SES
- LAMBDA
- SFN
- API Gateway
- CloudFront
- S3
- R53
- ACM
- IAM
- CloudWatch 

## Architecture

![Serverless-Email-Reminder-Architecture-Diagram](./assets/serverless-email-reminder.drawio.svg)
