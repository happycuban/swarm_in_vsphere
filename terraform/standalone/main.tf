##################################################################################
# MODULES LOADS AND GENERATES SERVERS
##################################################################################
# Provisioning of DOCKER servers
module "standalone-server" {
  source = "../vm-provision-standalone"

  vsphere_datacenter      = "Silkeborgvej (MW-DC2)"
  vsphere_compute_cluster = "MW-CL"
  vsphere_datastore       = "3Par_DS_Diverse"
  vsphere_network         = "VLAN500"
  vm_os_template          = "PackerTemplates/ubuntu22-04"


  first_ip_cidr_block = "10.50.0.0/16"
  starting_ip_index = 25707 #when using /16 the formula is (256*100)+ip
  #starting_ip_index = 177  #When using /24 no formula
  ip_netmask = "16"
  ip_gateway = "10.50.1.1"

  ## VM Settings
  server_name_prefix  = "sta-work-"
  starting_index = 3
  server_number = 2
  tag_role = "SWARM"
  tag_type = "STA"
  vm_folder_root = "Swarm"
  vm_type        = "sta"
  
  ## VM server Hardware
  server_num_cpus  = 8
  server_cpu_hot_add_enabled    = "true"
  server_cpu_hot_remove_enabled = "true"
  server_memory    = 16
  server_memory_hot_add_enabled = "true"
  
  
  vm_disk_size = 30
  disk1_size = 50
  disk2_size = 30

  ## VM Extra Config
  disk1_dir = "/var/lib/docker"
  disk2_dir = "/var/log"
  
}