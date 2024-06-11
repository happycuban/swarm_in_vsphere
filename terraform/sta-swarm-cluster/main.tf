##################################################################################
# MODULES LOADS AND GENERATES SERVERS
##################################################################################
# Provisioning of DOCKER servers
module "swarm-cluster" {
  source = "../vm-provision-random"

  vsphere_datacenter      = "Silkeborgvej (MW-DC2)"
  vsphere_compute_cluster = "MW-CL"
  vsphere_datastore       = "netapp02_development_ds01"
  vsphere_network         = "VLAN500"
  vm_os_template          = "PackerTemplates/ubuntu22-04"


  ## VM Settings
  
  tag_role = "SWARM"
  tag_type = "DEV"
  vm_folder_root = "Swarm"
  vm_type        = "dev"

  ## VM Network Settings

  ip_netmask = "16"
  ip_gateway = "10.50.1.1"
  
  ## VM manager Hardware
  manager_name_prefix  = "dev-mgr"
  manager_nodes_number = 3
  manager_num_cpus  = 8
  manager_cpu_hot_add_enabled    = "true"
  manager_cpu_hot_remove_enabled = "true"
  manager_memory    = 16
  manager_memory_hot_add_enabled = "true"
  

  ## VM worker Hardware
  worker_name_prefix  = "dev-wrk"
  worker_nodes_number = 3
  worker_num_cpus  = 8
  worker_cpu_hot_add_enabled    = "true"
  worker_cpu_hot_remove_enabled = "true"
  worker_memory    = 16
  worker_memory_hot_add_enabled = "true"
  
  
  vm_disk_size = 30
  disk1_size = 50
  disk2_size = 30

  ## VM Extra Config
  disk1_dir = "/var/lib/docker"
  disk2_dir = "/var/log"
  
}