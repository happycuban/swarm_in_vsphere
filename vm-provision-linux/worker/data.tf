
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_os_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# tags

data "vsphere_tag_category" "tag_category_type" {
  name = "Type"
}

data "vsphere_tag_category" "tag_category_role" {
  name = "Role"
}

data "vsphere_tag" "tag_type" {
  name        = var.tag_type
  category_id = data.vsphere_tag_category.tag_category_type.id
}

data "vsphere_tag" "tag_role" {
  name        = var.tag_role
  category_id = data.vsphere_tag_category.tag_category_role.id
}

data "template_cloudinit_config" "example" {
  count = var.worker_nodes_number
  gzip = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = <<-EOF
      #cloud-config
      hostname: "dd-work-${count.index + 1}"
      users:
        - name: sysadmin
          passwd: "$6$a55c764b5dad0c8e$O0rhsWmQzyIS2oLvKqijyE2YQdUUWzgM0bSg057iYZwwd5aRfZatbsE97rUQPCsqz.OzrjLoM.FXKaRyF1IUK1"
          ssh-authorized-keys:
            - ${file("${path.module}/templates/terraform.key.pub")}
            - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7bv2A0BdaIbbEEbytPQkT8/UkKksZF8MdohpPptxoO sysadmin"
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          groups: sudo
          shell: /bin/bash
         
      runcmd:
        - sed -i '/sysadmin insecure public key/d' /home/sysadmin/.ssh/authorized_keys
        # make sure the vagrant account is not expired.
        # NB this is needed when the base image expires the vagrant account.
        #- usermod --expiredate '' vagrant
      EOF
  }
}