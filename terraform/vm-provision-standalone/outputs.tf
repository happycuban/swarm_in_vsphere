
output "manager_vm_details" {
  value = {
    for vm in vsphere_virtual_machine.server:
    vm.name => vm.default_ip_address
  }
  depends_on = [vsphere_virtual_machine.server]
}
