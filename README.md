# Terraform Infrastructure as Code (IaC) for VMware vSphere

This repository contains Terraform code to provision Docker Swarm infrastructure on VMware vSphere. The code uses the HashiCorp vSphere provider to create and configure virtual machines.

## Prerequisites

- [Terraform](https://www.terraform.io/) installed
- VMware vSphere environment set up
- Ubuntu VM template available in the vSphere environment

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/happycuban/swarm_in_vsphere.git
   cd swarm_in_vsphere

  - Update the provider-vsphere/main.tf file with your vSphere environment details.
  - Navigate to the swarm-iac directory:
   
   ```bash
   cd swarm-iac

2. Update the main.tf file in the swarm-iac directory with your specific configuration:

  - Adjust the values in the module "swarm-manager" and module "swarm-worker" blocks to match your environment.
  - Specify the vSphere datacenter, compute cluster, datastore, network, and VM template details.
  - Run Terraform commands:

   ```bash
   terraform init
   terraform apply


**Configuration**

- `provider-vsphere/main.tf`: This file configures the HashiCorp vSphere provider and sets up the required version.

- `swarm-iac/main.tf`: This file loads and generates Docker Swarm servers using Terraform modules. Adjust the module configurations to customize your infrastructure.
  - `module "swarm-manager"`: Configures Docker Swarm manager nodes.
  - `module "swarm-worker"`: Configures Docker Swarm worker nodes.

**Contributing**

Feel free to contribute by opening issues or creating pull requests.

**License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
