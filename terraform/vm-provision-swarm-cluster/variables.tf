
#variable "manager_name" {
#  description = "vm names, e.g. of the form <vm_name_env>-<vm_name_role>-[vm_name_task]-%02d-[vm_name_extra]"
#  type        = list(string)

 # validation {
 #   condition     = length(var.manager_name) == length(distinct(var.manager_name))
 #   error_message = "vm names must be distinct."
 # }
#}

variable "manager_name" {
  description = "vm names, e.g. of the form <vm_name_env>-<vm_name_role>-[vm_name_task]-%02d-[vm_name_extra]"
  type        = string
}

variable "worker_name" {
  description = "vm names, e.g. of the form <vm_name_env>-<vm_name_role>-[vm_name_task]-%02d-[vm_name_extra]"
  type        = string
}

#variable "worker_names" {
#  description = "vm names, e.g. of the form <vm_name_env>-<vm_name_role>-[vm_name_task]-%02d-[vm_name_extra]"
#  type        = list(string)

#  validation {
#    condition     = length(var.worker_names) == length(distinct(var.worker_names))
#    error_message = "vm names must be distinct."
#  }
#}

variable "manager_nodes_number" {
  type    = number
  default = 3
  validation {
    condition = var.manager_nodes_number >= 3
    error_message = "Must be 3 or more."
  }
}

variable "worker_nodes_number" {
  type    = number
  default = 3
  validation {
    condition = var.worker_nodes_number >= 3
    error_message = "Must be 3 or more."
  }
}

variable "ip_range" {
  default = "192.168.10.19"
}

variable "ip_netmask" {
  default = "24"
}

variable "ip_gateway" {
  default = "192.168.10.1"
}

variable "tag_type" {
  type = string
  nullable = true
}

variable "tag_role" {
  type = string
  nullable = true
}

variable "manager_num_cpus" {
  type    = number
  description = "number of CPUs per VM"
  default = 4
  validation {
    condition = var.manager_num_cpus >= 4
    error_message = "Must be 4 or more."
  }
}

variable "manager_memory" {
  description = "amount of memory [GiB] per VM"
  type = number
  default = 4
  validation {
    condition = var.manager_memory >= 4
    error_message = "Must be 4 or more."
  }
}

variable "manager_cpu_hot_add_enabled" {
  description = "Allow CPUs to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "manager_cpu_hot_remove_enabled" {
  description = "Allow CPUs to be removed to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "manager_memory_hot_add_enabled" {
  description = "Allow memory to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "worker_num_cpus" {
  type    = number
  description = "number of CPUs per VM"
  default = 4
  validation {
    condition = var.worker_num_cpus >= 4
    error_message = "Must be 4 or more."
  }
}

variable "worker_memory" {
  description = "amount of memory [GiB] per VM"
  type = number
  default = 4
  validation {
    condition = var.worker_memory >= 4
    error_message = "Must be 4 or more."
  }
}

variable "worker_cpu_hot_add_enabled" {
  description = "Allow CPUs to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "worker_cpu_hot_remove_enabled" {
  description = "Allow CPUs to be removed to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "worker_memory_hot_add_enabled" {
  description = "Allow memory to be added to this virtual machine while it is running."
  type        = bool
  default     = true
}

variable "vm_disk_size" {
  description = "size of the OS disk [GiB]"
  type = number
  default = 30
  validation {
    condition = var.vm_disk_size >= 30
    error_message = "Must be 30 or more."
  }
}

variable "disk1_size" {
  description = "size of the DOCKER disk [GiB]"
  type = number
  default = 50
  validation {
    condition = var.disk1_size >= 50
    error_message = "Must be 50 or more."
  }

}

variable "disk2_size" {
  description = "size of the LOGS disk [GiB]"
  type = number
  default = 10
  validation {
    condition = var.disk2_size >= 10
    error_message = "Must be 10 or more."
  }

}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_compute_cluster" {
  type = string
}

variable "vsphere_compute_cluster_template" {
  type = string
  default = "IBM Cluster"
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_datastore_template" {
  type = string
  default = "Tier"
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
