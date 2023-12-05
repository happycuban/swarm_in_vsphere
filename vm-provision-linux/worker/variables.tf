
variable "vm_name" {
  description = "vm names, e.g. of the form <vm_name_env>-<vm_name_role>-[vm_name_task]-%02d-[vm_name_extra]"
  type        = string
  nullable = true
}

variable "worker_nodes_number" {
  type    = number
  default = 3
  validation {
    condition = var.worker_nodes_number >= 1
    error_message = "Must be 1 or more."
  }
}

variable "tag_type" {
  type = string
  nullable = true
}

variable "tag_role" {
  type = string
  nullable = true
}

variable "vm_num_cpus" {
  type    = number
  default = 1
  validation {
    condition = var.vm_num_cpus >= 1
    error_message = "Must be 1 or more."
  }
}

variable "vm_memory" {
  type    = number
  default = 1024
}

variable "vm_cpu_hot_add_enabled" {
  description = "Allow CPUs to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "vm_cpu_hot_remove_enabled" {
  description = "Allow CPUs to be removed to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "vm_memory_hot_add_enabled" {
  description = "Allow memory to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "vm_disk_size" {
  type    = number
  default = 30
  validation {
    condition = var.vm_disk_size >= 10
    error_message = "Must be 30 or more."
  }
}

variable "disk1_size" {
  type    = number
  default = 50
}

variable "disk2_size" {
  type    = number
  default = 20
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_compute_cluster" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_network" {
  type = string
}

variable "vm_os_template" {
  type    = string
  default = "PackerTemplates/ubuntu22-04"
}

variable "disk1_dir" {
  type = string
}

variable "disk2_dir" {
  type = string
  default = "/var/log"
}

variable "os_local_adminpass" {
  description = "The administrator password for this virtual machine.(Required) when ssh login."
  default     = "sysadmin1"
  sensitive   = true
}

variable "vm_folder_root" {
  description = "The path to the root folder to put this virtual machine in the module a path is calculated based on type, role and task"
  default     = "_root_"
}

variable "vm_type" {
  description = "Type of environment the server is running in. Possible values: tmp, dev, tes, sta, pro"
  type        = string
  default     = "tmp"
}

variable "ip_range" {
  description = "The IP pool for VMs"
  default     = "192.168.1.0/24"
}

variable "ip_netmask" {
  default = "24"
}

variable "ip_gateway" {
  default = "192.168.1.1"
}

variable "public_key" {
  default = "xxxxxxxxxxxxxxx"
}
