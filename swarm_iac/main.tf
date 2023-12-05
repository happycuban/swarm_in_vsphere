##################################################################################
# MODULES LOADS AND GENERATES SERVERS
##################################################################################
# Provisioning of DOCKER servers
module "swarm-manager" {
  source = ".//../../../modules/vm-provision-linux/manager"
  
  #VM Staging Location
  vsphere_datacenter     = "DC-NAME"
  vsphere_compute_cluster= "CLUSTER"
  vsphere_datastore      = "DATASTORE"
  vsphere_network        = "NETWORK-NAME"
  vm_os_template          = "UBUNTU-TEMPLATE"
  

  ## VM Settings
  vm_name = ""
  tag_role = "VSPHERE_ROLE"
  tag_type = "VSPHERE_TYPE"
  manager_nodes_number = 3
  vm_folder_root = "Swarm"
  vm_type        = "ops"
  ip_range = "192.168.2.10/24"  # this is the format "192.168.1.0/24" 
  ip_netmask = "24"
  ip_gateway = "192.168.2.1"

  
  
  ## VM Hardware
  vm_num_cpus  = 4
  vm_cpu_hot_add_enabled    = "true"
  vm_cpu_hot_remove_enabled = "true"
  vm_memory    = 4 * 1024
  vm_memory_hot_add_enabled = "true"
  vm_disk_size = 25
  
  
  disk1_size = 80
  disk2_size = 20

  ## VM Extra Config
  disk1_dir = "/var/lib/docker"
  disk2_dir = "/var/log"
}

module "swarm-worker" {
  source = ".//../../../modules/vm-provision-linux/worker"
  
  #VM Staging Location
  vsphere_datacenter     = "DC-NAME"
  vsphere_compute_cluster= "CLUSTER"
  vsphere_datastore      = "DATASTORE"
  vsphere_network        = "NETWORK-NAME"
  vm_os_template          = "UBUNTU-TEMPLATE"
  

  ## VM Settings
  vm_name = ""
  tag_role = "VSPHERE_ROLE"
  tag_type = "VSPHERE_TYPE"
  worker_nodes_number = 1
  vm_folder_root = "Swarm"
  vm_type        = "ops"
  ip_range = "192.168.2.20/24"  # this is the format "192.168.1.0/24" 
  ip_netmask = "24"
  ip_gateway = "192.168.2.1"

  
  ## VM Hardware
  vm_num_cpus  = 8
  vm_cpu_hot_add_enabled    = "true"
  vm_cpu_hot_remove_enabled = "true"
  vm_memory    = 8 * 1024
  vm_memory_hot_add_enabled = "true"
  vm_disk_size = 20
  
  
  disk1_size = 80
  disk2_size = 20

  ## VM Extra Config
  disk1_dir = "/var/lib/docker"
  disk2_dir = "/var/log"
}