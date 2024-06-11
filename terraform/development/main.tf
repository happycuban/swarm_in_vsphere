##################################################################################
# MODULES LOADS AND GENERATES SERVERS
##################################################################################
# Provisioning of DOCKER servers
module "dev-swarm-cluster" {
  source = "../vm-provision-swarm-cluster"

  vsphere_datacenter      = "Silkeborgvej (MW-DC2)"
  vsphere_compute_cluster = "IBM Cluster"
  vsphere_datastore       = "Tier"
  vsphere_network         = "VLAN-100"
  vm_os_template          = "PackerTemplates/ubuntu22-04"


  ip_range = "192.168.10.16"
  ip_netmask = "24"
  ip_gateway = "192.168.10.1"

  ## VM Settings
  manager_name     = "dev-man-0"
  manager_nodes_number = 3
  worker_name     = "dev-work-0"
  worker_nodes_number = 3
  tag_role = "SWARM"
  tag_type = "DEV"
  vm_folder_root = "Swarm"
  vm_type        = "dev"
  
  ## VM Manager Hardware
  manager_num_cpus  = 6
  manager_cpu_hot_add_enabled    = "true"
  manager_cpu_hot_remove_enabled = "true"
  manager_memory    = 16
  manager_memory_hot_add_enabled = "true"

   ## VM Worker Hardware
  worker_num_cpus  = 8
  worker_cpu_hot_add_enabled    = "true"
  worker_cpu_hot_remove_enabled = "true"
  worker_memory    = 16
  worker_memory_hot_add_enabled = "true"
  
  
  
  vm_disk_size = 30
  disk1_size = 110
  disk2_size = 30

  ## VM Extra Config
  disk1_dir = "/var/lib/docker"
  disk2_dir = "/var/log"
  
}