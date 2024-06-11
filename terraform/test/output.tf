
output "manager_ip_addresses" {
  value      = { for k, v in module.tes-swarm-cluster.manager_ip_addresses : k => v }
  depends_on = [module.tes-swarm-cluster]
}
output "worker_ip_addresses" {
  value      = { for k, v in module.tes-swarm-cluster.worker_ip_addresses : k => v }
  depends_on = [module.tes-swarm-cluster]
}