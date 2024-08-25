#!/bin/bash

# Script Name: aws-service-list.sh
# Author: Vijay Saw
# Date: 2024-08-25
# Description: This script interacts with the AWS CLI to list various AWS resources 
#              such as EC2 instances, S3 buckets, Lambda functions, etc., in a specified region.

# Prompt for AWS region
echo "Enter AWS region (leave empty for default region 'us-east-1'):"
read -r aws_region

# Prompt for AWS service
echo "Enter AWS service (leave empty for default service 'ec2'):"
read -r aws_service

# Set default region if none provided
if [ -z "$aws_region" ]; then
    aws_region="us-east-1"
    echo "No region entered. Using default region: $aws_region"
fi

# Set default service if none provided
if [ -z "$aws_service" ]; then
    aws_service="ec2"
    echo "No service selected. Using default service: $aws_service"
fi

# Check if the `aws` command is available
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it."
    exit 1
fi

# Check if the AWS CLI configuration directory exists
if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please configure it."
    exit 1
fi

# Handle different AWS services
case $aws_service in
    ec2)
        echo "Listing all EC2 instances under region $aws_region"
        aws ec2 describe-instances --region "$aws_region"
        ;;
    s3)
        echo "Listing all S3 buckets"
        aws s3 ls --region "$aws_region"
        ;;
    lambda)
        echo "Listing all Lambda functions under region $aws_region"
        aws lambda list-functions --region "$aws_region"
        ;;
    vpc)
        echo "Listing all VPCs under region $aws_region"
        aws ec2 describe-vpcs --region "$aws_region"
        ;;
    subnet)
        echo "Listing all subnets under region $aws_region"
        aws ec2 describe-subnets --region "$aws_region"
        ;;
    route)
        echo "Listing all route tables under region $aws_region"
        aws ec2 describe-route-tables --region "$aws_region"
        ;;
    internetgateway)
        echo "Listing all internet gateways under region $aws_region"
        aws ec2 describe-internet-gateways --region "$aws_region"
        ;;
    route53)
        echo "Listing all hosted zones in Route 53"
        aws route53 list-hosted-zones
        ;;
    rds)
        echo "Listing all RDS instances under region $aws_region"
        aws rds describe-db-instances --region "$aws_region"
        ;;
    dynamodb)
        echo "Listing all DynamoDB tables under region $aws_region"
        aws dynamodb list-tables --region "$aws_region"
        ;;
    iam)
        echo "Listing all IAM users"
        aws iam list-users
        ;;
    *)
        echo "Unsupported service: $aws_service"
        exit 1
        ;;
esac

