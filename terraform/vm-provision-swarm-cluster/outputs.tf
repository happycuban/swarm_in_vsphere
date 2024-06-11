
output "manager_ip_addresses" {
  value      = "${vsphere_virtual_machine.manager.*.guest_ip_addresses}"
  depends_on = [vsphere_virtual_machine.manager]
}

output "worker_ip_addresses" {
  value      = "${vsphere_virtual_machine.worker.*.guest_ip_addresses}"
  depends_on = [vsphere_virtual_machine.worker]
}
