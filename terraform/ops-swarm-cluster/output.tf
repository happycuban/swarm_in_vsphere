
output "manager_details" {
  #value = {for vm in module.swarm-cluster.manager_vm_details : vm.name => vm.guest_ip_addresses}
  value = module.swarm-cluster.manager_vm_details
}

output "worker_details" {
  #value = {for vm in module.swarm-cluster.worker_vm_details : vm.name => vm.guest_ip_addresses}
  value = module.swarm-cluster.worker_vm_details
}