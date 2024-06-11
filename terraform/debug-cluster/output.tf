
output "dev_manager_ip_addresses" {
  value      = { for k, v in module.dev-swarm-cluster.manager_ip_addresses : k => v }
  depends_on = [module.dev-swarm-cluster]
}
output "dev_worker_ip_addresses" {
  value      = { for k, v in module.dev-swarm-cluster.worker_ip_addresses : k => v }
  depends_on = [module.dev-swarm-cluster]
}