
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