# Terraform Infrastructure as Code (IaC) for VMware vSphere

**Overview**

In the contemporary landscape of cloud-centric infrastructure, the need for on-premise solutions remains crucial for many enterprises. Despite the prevalence of cloud-based services, certain companies find it imperative to maintain on-premise environments, often due to regulatory compliance, data sovereignty concerns, or specific operational requirements.

This Terraform Infrastructure as Code (IaC) repository focuses on provisioning Docker Swarm infrastructure on VMware vSphere, offering a streamlined process for on-premise container orchestration. As organizations navigate the complexities of hybrid cloud environments, having the ability to efficiently manage and deploy containerized workloads within on-premise infrastructure becomes a strategic advantage.

The provided Terraform scripts, tailored for vSphere, empower users to orchestrate Docker Swarm clusters seamlessly. This is particularly beneficial for companies with vSphere setups, allowing them to harness the advantages of containerization while maintaining control over their infrastructure.

By acknowledging the significance of on-premise solutions in conjunction with the flexibility of containerization, this tutorial bridges the gap between traditional infrastructure and modern container orchestration. It serves as a valuable resource for those seeking a robust solution for Docker Swarm deployment within their VMware vSphere environments, emphasizing the versatility of Infrastructure as Code in addressing diverse infrastructure needs.

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
   ```

2. Navigate to the `swarm-iac` directory:

    ```bash
    cd swarm-iac
    ```

3. Update the `main.tf` file in the `swarm-iac` directory with your specific configuration:

    - Adjust the values in the `module "swarm-manager"` and `module "swarm-worker"` blocks to match your environment.
    - Specify the vSphere datacenter, compute cluster, datastore, network, and VM template details.

4. Run Terraform commands:

    ```bash
    terraform init
    terraform apply
    ```

## Configuration

- **`provider-vsphere/main.tf`**: This file configures the HashiCorp vSphere provider and sets up the required version.

- **`swarm-iac/main.tf`**: This file loads and generates Docker Swarm servers using Terraform modules. Adjust the module configurations to customize your infrastructure.
    - **`module "swarm-manager"`**: Configures Docker Swarm manager nodes.
    - **`module "swarm-worker"`**: Configures Docker Swarm worker nodes.


## Ansible Configuration

Once the VMs are provisioned by Terraform, you can use Ansible to configure and manage them. Follow the steps below:

1. Retrieve the IPs from the provisioned VMs.

2. Write the IPs into the `ansible/inventory.yaml` file:

   ```yaml
   all:
     children:
       manager:
         hosts:
           xx.xx.xx.xx:
           xx.xx.xx.xx: 
       worker:
         hosts:
           xx.xx.xx.xx:
           xx.xx.xx.xx: 
     vars:
       ansible_user: sysadmin
       ansible_ssh_private_key_file: "/path_to_key/.ssh/terraform.key"
       ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
       ansible_python_interpreter: "/usr/bin/python3"
   ```

Once the VMs are provisioned by Terraform, use Ansible to configure and manage them. Below are Ansible playbooks for installing Docker and configuring Docker Swarm.

### Install Docker

   ```bash
   ansible-playbook -i inventory.yaml docker.yml
   ```

### Initialize Swarm Cluster

   ```bash
   ansible-playbook -i inventory.yaml swarm.yml
   ```

## Swarm Playbook Explanation:

The playbook checks the status of each manager and worker node, categorizing them into operational or bootstrap groups.
It initializes the swarm cluster on the first manager if no managers are operational.
Retrieves swarm tokens and populates a list of manager IPs.
Joins manager and worker nodes to the swarm cluster.


## Deploying Awesome Stacks with Docker Swarm

Now that your Docker Swarm is gracefully dancing across your servers, it's time to introduce the star performers – Portainer and Traefik! These two stacks will bring a touch of magic to your infrastructure.
Before deploying these stacks, don't forget to configure DNS to point to one of your Docker Swarm nodes for both Portainer and Traefik. Ensure that the DNS entry for each service resolves to the IP address of a reachable Swarm node. This is crucial for seamless access to the fantastic features provided by Portainer and the magic orchestrated by Traefik.


### Traefik Stack

Enter Traefik, the charismatic traffic conductor of your Docker Swarm circus! This stack knows how to handle traffic with finesse. To let Traefik take the lead, run this Ansible playbook:

   ```bash
   cd traefik-stack
   ansible-playbook -i ../inventory.yaml main.yml
   ```


### Portainer Stack

The Portainer stack is like the backstage manager for your Docker environment, ensuring that every container hits the stage with style. To deploy it, run the following Ansible playbook:

   ```bash
   cd portainer-stack
   ansible-playbook -i ../inventory.yaml main.yml
   ```

Feel free to sit back, relax, and enjoy the show as Portainer and Traefik transform your Docker Swarm into a spectacle worth applauding! 🎉✨

http://portainer.domain.local
http://traefik.domain.local


## Contributing

Feel free to contribute by opening issues or creating pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
