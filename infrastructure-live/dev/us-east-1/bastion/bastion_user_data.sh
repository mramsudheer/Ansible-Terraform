#! /bin/bash
# --- 1. EXTEND THE EBS VOLUME SPACE ---
# (Using growpart for automation instead of interactive parted)
sudo dnf install cloud-utils-growpart -y #This installs the growpart tool

#This tells the "Physical Disk" (/dev/nvme0n1) to expand Partition 4 to fill the remaining empty space on the 50GB drive.
sudo growpart /dev/nvme0n1 4

# Since you are using LVM, your partition acts as a "Physical Volume" (PV).
# Even though the partition is now 50GB, the LVM software doesn't know that yet.
# This command updates the LVM metadata to say, "Hey, this PV just got bigger; 
# we have more room for activities."
sudo pvresize /dev/nvme0n1p4

# Your disk is now 50GB, and LVM knows it, but that space is sitting in a 
# "spare pool" (the Volume Group). This command takes 100% of that FREE space 
# in the pool and gives it specifically to your Root Logical Volume (rootVol).
sudo lvextend -l +100%FREE /dev/mapper/RootVG-rootVol

# This command tells the XFS filesystem to expand and occupy 
# all the new space available in the Logical Volume.
sudo xfs_growfs /
sleep 10
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
sleep 5
sudo chmod +x /GitFiles/Ansible-Terraform/infrastructure-live/dev/us-east-1/bastion/bastion_user_data.sh
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