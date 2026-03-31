#! /bin/bash
# --- 1. EXTEND THE EBS VOLUME SPACE ---
# (Using growpart for automation instead of interactive parted)
sudo dnf install cloud-utils-growpart -y
sudo growpart /dev/nvme0n1 4
sudo pvresize /dev/nvme0n1p4
sudo lvextend -l +100%FREE /dev/mapper/RootVG-rootVol
sudo xfs_growfs /

# --- 2. INSTALL TOOLS ---
sudo dnf install git -y

# Install ansible
sudo dnf install ansible -y
pip3.9 install netaddr
pip3 install boto3 botocore

# Install terraform
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf -y install terraform

# --- 3. FIXED AWS CLI INSTALLATION ---
# Corrected URL: awscli.amazonaws.com
curl "https://amazonaws.com" -o "awscliv2.zip"
sudo dnf install unzip -y
unzip awscliv2.zip
sudo ./aws/install
sudo ln -s /usr/local/bin/aws /usr/bin/aws

# --- 4. CLONE REPOS ---
mkdir -p /GitFiles
cd /GitFiles
git clone https://github.com/mramsudheer/Ansible-Terraform.git
git clone https://github.com/mramsudheer/ansible-roboshop-roles-tf.git
#-------------------------------------------------------------------#
# sudo dnf install git -y
# sleep 5

# # Install ansible
# sudo dnf install ansible -y
# pip3.9 install netaddr
# pip3 install boto3 botocore
# sleep 5

# # Install terraform
# sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# sudo dnf -y install terraform
# sleep 10

# # Download the REAL installer (Note the 'awscli.' in the URL)
# curl "https://amazonaws.com" -o "awscliv2.zip"

# # Unzip and Install
# sudo dnf install unzip -y
# unzip awscliv2.zip
# sudo ./aws/install
# sleep 5
# sudo ln -s /usr/local/bin/aws /usr/bin/aws

# mkdir GitFiles
# cd GitFiles
# git clone https://github.com/mramsudheer/Ansible-Terraform.git
# git clone https://github.com/mramsudheer/ansible-roboshop-roles-tf.git