#!/bin/bash

# Validate and deploy Terraform configurations for a given environment
# Usage: ./deploy.sh [dev|test|prod] [service_name]

ENV=$1
SERVICE=$2

if [[ -z "$ENV" ]] || [[ -z "$SERVICE" ]]; then
  echo "Usage: ./deploy.sh [dev|test|prod] [service_name]"
  exit 1
fi

# Define the base path for the services
BASE_PATH="services"

# Navigate to the specified service and environment
cd "$BASE_PATH/$SERVICE/infrastructure" || { echo "Service $SERVICE does not exist!"; exit 1; }

# Check if the environment file exists
if [[ ! -f "environments/$ENV.tfvars" ]]; then
  echo "Environment file for $ENV does not exist!"
  exit 1
fi

# Initialize Terraform with backend configuration
terraform init

# Validate Terraform configuration
terraform validate

# Format Terraform files
terraform fmt -check

# Plan Terraform deployment
terraform plan -var-file="environments/$ENV.tfvars"

# Prompt user for confirmation before applying
read -p "Do you want to apply these changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Apply Terraform deployment
  terraform apply -var-file="environments/$ENV.tfvars" -auto-approve
else
  echo "Deployment cancelled."
fi