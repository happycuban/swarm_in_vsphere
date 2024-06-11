
output "manager_vm_details" {
  value = {
    for vm in vsphere_virtual_machine.manager_server:
    vm.name => vm.default_ip_address
  }
  depends_on = [vsphere_virtual_machine.manager_server]
}

output "worker_vm_details" {
  value = {
    for vm in vsphere_virtual_machine.worker_server:
    vm.name => vm.default_ip_address
  }
  depends_on = [vsphere_virtual_machine.worker_server]
}