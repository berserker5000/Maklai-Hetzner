output "server_ip" {
  value = hcloud_server.master_node.ipv4_address
}

# output "public_key" {
#   description = "Public key"
#   value       = tls_private_key.ssh_key.public_key_openssh
# }

# output "kubeconfig" {
#   depends_on = [null_resource.wait_for_admin_conf]
#   value = file("${path.module}/kubeconfig")
# }