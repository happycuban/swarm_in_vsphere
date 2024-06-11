#!/bin/bash

# Fetch outputs from Terraform
terraform output -json > terraform_output.json

# Assuming terraform_output.json contains the Terraform output
OUTPUT_FILE="terraform_output.json"

# Extract the data into variables
MANAGER_IPS=$(jq -r '.server_ips.value | to_entries[] | .key + " ansible_host=" + .value + " rke2_type=server"' $OUTPUT_FILE)
WORKER_IPS=$(jq -r '.agent_ips.value | to_entries[] | .key + " ansible_host=" + .value + " rke2_type=agent"' $OUTPUT_FILE)
GLUSTER_IP=$(jq -r '.k8s_admin.value | to_entries[] | .key + " ansible_host=" + .value + " rke2_type=admin"' $OUTPUT_FILE)

# Begin writing to the hosts.ini file
{
    echo "[swarm_managers]"
    echo "$MANAGER_IPS"
    echo ""
    echo "[workers]"
    echo "$WORKER_IPS"
    echo ""
    echo "[gluster_nodes]"
    echo "$GLUSTER_IP"
    echo ""
    echo "[k8s_cluster:children]"
    echo "masters"
    echo "workers"
    echo ""
    echo "[all:vars]"
    echo "env_short=dev"
    echo "ansible_ssh_user=sysadmin"
    echo "ansible_ssh_private_key_file=/home/sysadmin/.ssh/id_ed25519"
    echo "ansible_ssh_extra_args=\"-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\""
} > hosts.ini
