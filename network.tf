resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = "eu-central" # Задайте соответствующую зону, например, "us-west"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_firewall" "firewall" {
  name = "firewall"

  rule {
    description = "Allow SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "any"
    source_ips  = var.personal_ips
  }

  rule {
    description = "K8s API server"
    direction   = "in"
    protocol    = "tcp"
    port        = "6443"
    source_ips  = ["0.0.0.0/0"]
  }
  rule {
    description = "Access Port 80"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0"]
  }
  rule {
    description = "Access Port 443"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = ["0.0.0.0/0"]
  }
  rule {
    description     = "Allow all outgoing traffic"
    direction       = "out"
    protocol        = "tcp"
    port            = "any"
    destination_ips = ["0.0.0.0/0"]
  }
}

resource "hcloud_load_balancer" "load_balancer" {
  name               = "nginx"
  load_balancer_type = "lb11"
  location           = "nbg1"
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.master_node.id
}