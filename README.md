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

## Contributing

Feel free to contribute by opening issues or creating pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
