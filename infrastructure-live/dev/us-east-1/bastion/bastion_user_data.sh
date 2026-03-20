#! /bin/bash
sudo dnf install git -y
sleep 5

# Install ansible
sudo dnf install ansible -y
pip3.9 install netaddr
pip3 install boto3 botocore
sleep 5

# Install terraform
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf -y install terraform
sleep 10

mkdir GitFiles
cd GitFiles
git clone https://github.com/mramsudheer/Ansible-Terraform.git
git clone https://github.com/mramsudheer/ansible-roboshop-roles-tf.git