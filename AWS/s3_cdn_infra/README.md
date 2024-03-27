# S3 Static Website

## Overview

This Terraform configuration defines the infrastructure for hosting a static website on Amazon Web Services (AWS).

It includes resources such as an S3 bucket for storing website assets, a CloudFront distribution for content delivery, TLS certificate management using AWS ACM, Route 53 DNS configuration, and a CodeBuild project for automating the build and deployment process.

The setup ensures secure and efficient hosting while automating deployment and DNS management for the static website.

## Deployed Services

- S3
- CloudFront
- Route 53
- ACM
- CodeBuild

## Architecture

![S3-Static-Website-Diagram](./assets/s3-static-website.drawio.svg)
