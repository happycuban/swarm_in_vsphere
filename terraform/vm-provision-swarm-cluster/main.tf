
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.2.0"
    }

  }
}

provider "vsphere" {
  allow_unverified_ssl = true
}



locals {
  # flexible number of data disks for VM
  # mount as disk or LVM is done by remote-exec script
  disks = [
    { "id":1, "dev":"sdb", "lvm":0, "sizeGB":var.disk1_size, "dir": var.disk1_dir },
    { "id":2, "dev":"sdc", "lvm":0, "sizeGB":var.disk2_size, "dir": var.disk2_dir }
  ]
  # construct arguments passed to disk partition/filesystem/fstab script
  # e.g. "sdb,0,10,/data1 sdc,1,20,/data2"
  disk_format_args = join(" ", [for disk in local.disks: "${disk.dev},${disk.lvm},${disk.sizeGB},${disk.dir}"] )

}

resource "vsphere_virtual_machine" "manager" {
   
  count = var.manager_nodes_number
  name = "${var.manager_name}${count.index + 1}"
  folder  = format("%s/%s", var.vm_folder_root, var.vm_type)

  num_cpus = var.manager_num_cpus
  cpu_hot_add_enabled    = var.manager_cpu_hot_add_enabled
  cpu_hot_remove_enabled = var.manager_cpu_hot_remove_enabled
  memory   = var.manager_memory*1024
  memory_hot_add_enabled = var.manager_memory_hot_add_enabled

  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  #nested_hv_enabled = true
  #vvtd_enabled = true
  #enable_disk_uuid = true


  firmware = "efi"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    thin_provisioned = true
    size             = var.vm_disk_size
  }
  
  # creates variable number of disks for VM
  dynamic "disk" {
    for_each = [ for disk in local.disks: disk ]
    
    content {
     label            = "disk${disk.value.id}"
     unit_number      = disk.value.id
     datastore_id     = data.vsphere_datastore.datastore.id
     size             = disk.value.sizeGB
     eagerly_scrub    = false
     thin_provisioned = true
    }
  }

  disk {
    label            = "glusterfs"
    unit_number      = 3
    thin_provisioned = true
    size             = 50
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.manager_name}${count.index + 1}"
        domain    = "mindworking.local"
      }
      network_interface {
        ipv4_address = "${var.ip_range}${count.index + 1}"
        ipv4_netmask = "${var.ip_netmask}"
       }
      ipv4_gateway         = "${var.ip_gateway}"
      dns_server_list = ["10.4.10.253","10.4.10.252"]
      dns_suffix_list = ["mindworking.local"]
      
    }
  }

  lifecycle {
    ignore_changes = [
      annotation
      ]
  }


  tags = [
    data.vsphere_tag.tag_role.id,
    data.vsphere_tag.tag_type.id
  ]

  provisioner "remote-exec" {
    inline = [
        "sudo echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7bv2A0BdaIbbEEbytPQkT8/UkKksZF8MdohpPptxoO sysadmin' > /home/sysadmin/.ssh/authorized_keys",
    ]

    connection {
     type = "ssh"
      host = "${var.ip_range}${count.index + 1}"
      user = "sysadmin"
      password = "${var.os_local_adminpass}"
    }

  }   
  
  connection {
    type = "ssh"
    agent = "false"
    host = "${var.ip_range}${count.index + 1}"
    user = "sysadmin"
    password = "${var.os_local_adminpass}"
  }

  provisioner "file" {
    destination = "/tmp/basic_disk.sh"
    content = templatefile(
      "${path.module}/templates/basic_disk.sh",
      { 
        "disks": local.disks
        "default_args" : local.disk_format_args
      }
    )
  }

  # script that creates partition and filesystem for data disks
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/basic_disk.sh",
      "echo ${var.os_local_adminpass} | sudo -S /tmp/basic_disk.sh ${local.disk_format_args} > /tmp/basic_disk.log",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "id",
      "uname -a",
      "cat /etc/os-release",
      "echo \"machine-id is $(cat /etc/machine-id)\"",
      "lsblk -x KNAME -o KNAME,SIZE,TRAN,SUBSYSTEMS,FSTYPE,UUID,LABEL,MODEL,SERIAL",
      "mount | grep ^/dev",
      "df -h",
    ]
    connection {
      type = "ssh"
      user = "sysadmin"
      host = "${var.ip_range}${count.index + 1}"
      private_key = file("${path.module}/templates/terraform.key")
    }
  }
}


resource "vsphere_virtual_machine" "worker" {
    
  name = "${var.worker_name}${count.index + 1}"
  count = var.worker_nodes_number
  folder = format("%s/%s", var.vm_folder_root, var.vm_type)

  num_cpus = var.worker_num_cpus
  cpu_hot_add_enabled    = var.worker_cpu_hot_add_enabled
  cpu_hot_remove_enabled = var.worker_cpu_hot_remove_enabled
  memory   = var.worker_memory*1024
  memory_hot_add_enabled = var.worker_memory_hot_add_enabled

  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  nested_hv_enabled = true
  vvtd_enabled = true
  enable_disk_uuid = true


  firmware = "efi"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    thin_provisioned = true
    size             = var.vm_disk_size
  }
  
  # creates variable number of disks for VM
  dynamic "disk" {
    for_each = [ for disk in local.disks: disk ]
    
    content {
     label            = "disk${disk.value.id}"
     unit_number      = disk.value.id
     datastore_id     = data.vsphere_datastore.datastore.id
     size             = disk.value.sizeGB
     eagerly_scrub    = false
     thin_provisioned = true
    }
  }

  disk {
    label            = "glusterfs"
    unit_number      = 3
    thin_provisioned = true
    size             = 50
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.worker_name}${count.index + 1}"
        domain    = "mindworking.local"
      }
      network_interface {
        ipv4_address = "${var.ip_range}${count.index + 5}"
        ipv4_netmask = "${var.ip_netmask}"
       }
      ipv4_gateway         = "${var.ip_gateway}"
      dns_server_list = ["10.4.10.253","10.4.10.252"]
      dns_suffix_list = ["mindworking.local"]
    }
  }

   lifecycle {
    ignore_changes = [
      annotation
      ]
  }

  tags = [
    data.vsphere_tag.tag_role.id,
    data.vsphere_tag.tag_type.id
  ]

  provisioner "remote-exec" {
    inline = [
        "sudo echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7bv2A0BdaIbbEEbytPQkT8/UkKksZF8MdohpPptxoO sysadmin' > /home/sysadmin/.ssh/authorized_keys",
    ]

    connection {
     type = "ssh"
      host = "${var.ip_range}${count.index + 5}"
      user = "sysadmin"
      password = "${var.os_local_adminpass}"
    }

  }   
  
  connection {
    type = "ssh"
    agent = "false"
    host = "${var.ip_range}${count.index + 5}"
    user = "sysadmin"
    password = "${var.os_local_adminpass}"
  }

  provisioner "file" {
    destination = "/tmp/basic_disk.sh"
    content = templatefile(
      "${path.module}/templates/basic_disk.sh",
      { 
        "disks": local.disks
        "default_args" : local.disk_format_args
      }
    )
  }

  # script that creates partition and filesystem for data disks
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/basic_disk.sh",
      "echo ${var.os_local_adminpass} | sudo -S /tmp/basic_disk.sh ${local.disk_format_args} > /tmp/basic_disk.log",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "id",
      "uname -a",
      "cat /etc/os-release",
      "echo \"machine-id is $(cat /etc/machine-id)\"",
      "lsblk -x KNAME -o KNAME,SIZE,TRAN,SUBSYSTEMS,FSTYPE,UUID,LABEL,MODEL,SERIAL",
      "mount | grep ^/dev",
      "df -h",
    ]
    connection {
      type = "ssh"
      user = "sysadmin"
      host = "${var.ip_range}${count.index + 5}"
      private_key = file("${path.module}/templates/terraform.key")
    }
  }
}