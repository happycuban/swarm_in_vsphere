
output "manager_ip_addresses" {
  value      = { for k, v in module.sta-swarm-cluster.manager_ip_addresses : k => v }
  depends_on = [module.sta-swarm-cluster]
}
output "worker_ip_addresses" {
  value      = { for k, v in module.sta-swarm-cluster.worker_ip_addresses : k => v }
  depends_on = [module.sta-swarm-cluster]
}