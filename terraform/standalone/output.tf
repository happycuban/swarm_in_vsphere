
output "server_ip_addresses" {
  value      = { for k, v in module.standalone-server.server_ip_addresses : k => v }
  depends_on = [module.standalone-server]
}