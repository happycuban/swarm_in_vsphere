
output "worker_ips" {
  value = [for vm in vsphere_virtual_machine.worker : vm.default_ip_address]
}