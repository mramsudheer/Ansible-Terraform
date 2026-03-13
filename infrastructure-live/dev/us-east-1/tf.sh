#!/bin/bash
source /c/DevOps_Practice_Code/aws_keys.sh
# Define the root path once to avoid repetition
ROOT_PATH="/c/DevOps_Practice_Code/Ansible-Terraform/infrastructure-live/dev/us-east-1"

apply(){
    echo "Starting Apply Sequence..."
    
    cd $ROOT_PATH/network || exit 1
    terraform init && terraform apply --auto-approve || exit 1
    
    cd ../security || exit 1
    terraform init && terraform apply --auto-approve || exit 1
    
    cd ../bastion || exit 1 
    terraform init && terraform apply --auto-approve || exit 1
}

destroy(){
    echo "Starting Destroy Sequence..."
    
    cd $ROOT_PATH/bastion && terraform destroy --auto-approve
    
    cd ../security && terraform destroy --auto-approve
    
    cd ../network && terraform destroy --auto-approve
}

case "$1" in
    "apply")
        apply
        ;;
    "destroy") # Fixed typo here
        destroy # Fixed typo here
        ;;
    *)
        echo "Usage: $0 {apply|destroy}"
        exit 1
        ;;
esac # Added missing esac
