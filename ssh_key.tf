resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/maklai"
  content  = tls_private_key.ssh_key.private_key_pem
}

resource "hcloud_ssh_key" "default" {
  name      = "key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

