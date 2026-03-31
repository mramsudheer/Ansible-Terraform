#!/bin/bash
# Stop execution immediately if any command fails
set -e

#source /c/DevOps_Practice_Code/aws_keys.sh

ROOT_PATH="/GitFiles/Ansible-Terraform/infrastructure-live/dev/us-east-1"
ALL_COMPONENTS=("databases" "acm" "backend_alb" "frontend-alb" "ssm" "components" "frontend")

ACTION=$1
shift 
COMPONENTS=($@)

# Default to all if no specific component is provided
if [ ${#COMPONENTS[@]} -eq 0 ]; then
    COMPONENTS=("${ALL_COMPONENTS[@]}")
fi

# Function to run terraform with strict error checking
run_terraform() {
    local action=$1
    local component=$2
    
    echo ">>> Processing $component: $action..."
    
    # Exit if directory doesn't exist
    cd "$ROOT_PATH/$component" || { echo "Directory $component not found!"; exit 1; }

    case "$action" in
        "init")    terraform init || exit 1 ;;
        "plan")    terraform plan || exit 1 ;;
        #"apply")   terraform apply --auto-approve > /dev/null &&  terraform output || exit 1 ;;
        "apply")   terraform init -input=false && terraform apply -auto-approve && terraform output ;;
        "destroy") terraform destroy --auto-approve || exit 1 ;;
        *) echo "Unknown action: $action"; exit 1 ;;
    esac
}

case "$ACTION" in
    "init"|"plan"|"apply")
        for comp in "${COMPONENTS[@]}"; do
            run_terraform "$ACTION" "$comp"
        done
        ;;
    "destroy")
        # Reverse order for destroy (bastion -> security -> network)
        for ((i=${#COMPONENTS[@]}-1; i>=0; i--)); do
        #     run_terraform "destroy" "${COMPONENTS[i]}"
        comp="${COMPONENTS[i]}"
            
            # Special logic: run apply for ssm instead of destroy
            if [ "$comp" == "ssm" ]; then
                echo ">>> [Special Override] Running APPLY for ssm instead of destroy"
                run_terraform "apply" "ssm"
            else
                run_terraform "destroy" "$comp"
            fi
        done
        ;;
    *)
        echo "Usage: $0 {init|plan|apply|destroy} [components...]"
        exit 1
        ;;
esac

echo "Done!"