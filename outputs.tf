output "server_ip" {
  value = hcloud_server.master_node.ipv4_address
}