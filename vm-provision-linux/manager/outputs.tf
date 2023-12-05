
output "manager_ips" {
  value = [for vm in vsphere_virtual_machine.manager : vm.default_ip_address]
}