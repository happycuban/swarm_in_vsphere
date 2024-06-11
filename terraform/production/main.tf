##################################################################################
# MODULES LOADS AND GENERATES SERVERS
##################################################################################
# Provisioning of DOCKER servers
module "prod-swarm-cluster" {
  source = "../vm-provision-swarm-cluster"

   #VM Production Location
  vsphere_datacenter      = "Silkeborgvej (MW-DC2)"
  vsphere_compute_cluster = "IBM Cluster"
  vsphere_datastore       = "Tier"
  vsphere_network         = "VLAN500"
  vm_os_template          = "PackerTemplates/ubuntu22-04"


  ip_range = "10.50.30.1"
  ip_netmask = "16"
  ip_gateway = "10.50.1.1"

  ## VM Settings
  manager_name     = "pro-man-0"
  manager_nodes_number = 3
  worker_name     = "pro-work-0"
  worker_nodes_number = 4
  tag_role = "SWARM"
  tag_type = "PRO"
  vm_folder_root = "Swarm"
  vm_type        = "pro"
  
  ## VM Manager Hardware
  manager_num_cpus  = 4
  manager_cpu_hot_add_enabled    = "true"
  manager_cpu_hot_remove_enabled = "true"
  manager_memory    = 8 * 1024
  manager_memory_hot_add_enabled = "true"

   ## VM Worker Hardware
  worker_num_cpus  = 4
  worker_cpu_hot_add_enabled    = "true"
  worker_cpu_hot_remove_enabled = "true"
  worker_memory    = 16 * 1024
  worker_memory_hot_add_enabled = "true"
  vm_disk_size = 20   ## OS only
  
  
  disk1_size = 110
  disk2_size = 30

  ## VM Extra Config
  disk1_dir = "/var/lib/docker"
  disk2_dir = "/var/log"
  
}