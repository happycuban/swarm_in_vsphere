
output "ops_manager_ip_addresses" {
  value      = { for k, v in module.ops-swarm-cluster.manager_ip_addresses : k => v }
  depends_on = [module.ops-swarm-cluster]
}
output "ops_worker_ip_addresses" {
  value      = { for k, v in module.ops-swarm-cluster.worker_ip_addresses : k => v }
  depends_on = [module.ops-swarm-cluster]
}