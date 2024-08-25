# AWS Service List Script

## Overview

This script interacts with the AWS CLI to list various AWS resources such as EC2 instances, S3 buckets, Lambda functions, and more in a specified AWS region. It allows you to specify the AWS region and service, and defaults to `us-east-1` and `ec2` respectively if none are provided.

## Features

- List EC2 instances
- List S3 buckets
- List Lambda functions
- List VPCs
- List subnets
- List route tables
- List internet gateways
- List Route 53 hosted zones
- List RDS instances
- List DynamoDB tables
- List IAM users

## Requirements

- AWS CLI installed and configured on your system.
- Access to AWS services based on your IAM permissions.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git

