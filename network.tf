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
    port        = "22"
    source_ips  = ["89.151.25.40/32"]
  }

  rule {
    description = "K8s API server"
    direction   = "in"
    protocol    = "tcp"
    port        = "6443"
    source_ips  = ["0.0.0.0/0"]
  }

  rule {
    description = "Allow all outgoing traffic"
    direction   = "out"
    protocol    = "tcp"
    port        = "any"
    destination_ips  = ["0.0.0.0/0"]
  }
}