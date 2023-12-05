
module "provider-vsphere" {
  source = "../../../modules/provider-vsphere"
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
  count             = var.manager_nodes_number
  name              = "${var.vm_name}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder  = format("%s/%s", var.vm_folder_root, var.vm_type)
  num_cpus          = var.vm_num_cpus
  cpu_hot_add_enabled    = var.vm_cpu_hot_add_enabled
  cpu_hot_remove_enabled = var.vm_cpu_hot_remove_enabled
  memory   = var.vm_memory
  memory_hot_add_enabled = var.vm_memory_hot_add_enabled
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

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
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.vm_name}-${count.index + 1}"
        domain    = "domain.local"
      }
      network_interface {
        ipv4_address = cidrhost(var.ip_range, count.index + 2)
        ipv4_netmask = "${var.ip_netmask}"
      }
      ipv4_gateway    = "${var.ip_gateway}"
      dns_server_list = ["192.168.1.253","192.168.1.254"]
      dns_suffix_list = ["domain.local"]
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
        "sudo echo '${var.public_key}' > /home/sysadmin/.ssh/authorized_keys",
    ]

    connection {
     type = "ssh"
      host = self.default_ip_address
      user = "sysadmin"
      password = "${var.os_local_adminpass}"
    }

  }
  
  
  connection {
    type = "ssh"
    host = self.default_ip_address
    user = "sysadmin"
    private_key = file("${path.module}/path_to_private_key")
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


}