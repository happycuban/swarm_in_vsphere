#!/bin/bash

# Navigate to your Terraform directory
cd dev-swarm-cluster

# Initialize and apply Terraform
terraform init
terraform apply -auto-approve

# Generate JSON output from Terraform
terraform output -json > terraform_output.json

# Parse JSON to create Ansible inventory file
python3 - << 'EOF'
import json

# Load Terraform JSON output
with open('terraform_output.json', 'r') as file:
    data = json.load(file)

# Open a new Ansible inventory file
with open('ansible_inventory.ini', 'w') as inventory:
    # Write [all:vars] section with general variables
    inventory.write("[all:vars]\n")
    inventory.write("env_short=dev\n")
    inventory.write("ansible_connection=ssh\n")
    inventory.write("ansible_user=sysadmin\n")
    inventory.write("ansible_become=yes\n")
    inventory.write("ansible_become_method=sudo\n")
    # Uncomment the next line if you wish to include the ansible_become_password
    # inventory.write("ansible_become_password=sysadmin1\n")
    inventory.write("ansible_python_interpreter=/usr/bin/python3\n")
    inventory.write("ansible_ssh_private_key_file=/config/.ssh/terraform.key\n")
    inventory.write("ansible_ssh_common_args=-o StrictHostKeyChecking=no\n")
    inventory.write("device2_hdd_dev=/dev/sdd\n\n")
    
    # Initialize an empty list to store all unique hostnames for gluster_nodes
    gluster_nodes = []

    # Define groups based on keys in the JSON file and collect hostnames for gluster_nodes
    for key, group_data in data.items():
        if 'value' in group_data:
            # Adjust the group name to include 'swarm_' prefix appropriately
            if 'manager' in key:
                group_name = 'swarm_managers'
            elif 'worker' in key:
                group_name = 'swarm_workers'
            else:
                continue  # Skip if it's neither manager nor worker

            inventory.write(f"[{group_name}]\n")

            # Write host entries and collect hostnames
            for host, ip in group_data['value'].items():
                inventory.write(f"{host} ansible_host={host}\n")
                if host not in gluster_nodes:  # Ensure each hostname is only added once
                    gluster_nodes.append(host)

            # Add a newline for better formatting
            inventory.write("\n")

    # Write gluster_nodes section with hostnames, maintaining the original order
    inventory.write("[gluster_nodes]\n")
    for hostname in gluster_nodes:  # Use the list as it was populated
        inventory.write(f"{hostname}\n")

EOF

# Clean up JSON file
rm terraform_output.json

echo "Ansible inventory has been created successfully."
