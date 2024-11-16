resource "hcloud_server" "master_node" {
  name        = "master"
  server_type = "cx22"
  image       = "ubuntu-24.04"
  location    = "nbg1"
  ssh_keys = [hcloud_ssh_key.default.name]
  firewall_ids = [hcloud_firewall.firewall.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  network {
    network_id = hcloud_network.network.id
  }

  user_data = <<-EOT
    #cloud-config
    apt:
      preserve_sources_list: false

    package_update: true
    package_upgrade: true

    packages:
      - curl
      - apt-transport-https
      - ca-certificates
      - software-properties-common

    runcmd:
      - sudo apt update
      - sudo apt upgrade -y
      - sudo apt install -y docker.io
      - echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      - curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      - sudo apt update
      - sudo apt install -y kubelet kubeadm kubectl
      - sudo apt-mark hold kubelet kubeadm kubectl
      - sudo kubeadm init --pod-network-cidr=10.244.0.0/16
      - sudo mkdir -p $HOME/.kube
      - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      - sudo chown $(id -u):$(id -g) $HOME/.kube/config
      - echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
      - kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
      - sleep 30
      - reboot now
  EOT

  depends_on = [
    hcloud_network_subnet.subnet
  ]
}



resource "null_resource" "wait_for_admin_conf" {
  depends_on = [hcloud_server.master_node, tls_private_key.ssh_key]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("${path.module}/maklai")
      host        = hcloud_server.master_node.ipv4_address
    }

    inline = [
      "while [ ! -f /etc/kubernetes/admin.conf ]; do echo 'Waiting for admin.conf...'; sleep 10; done"
    ]
  }

  provisioner "local-exec" {
      command = <<EOT
      scp -i ${path.module}/maklai root@${hcloud_server.master_node.ipv4_address}:/etc/kubernetes/admin.conf ./kubeconfig && \
      chmod 600 ./kubeconfig && \
      kubectl config use-context ./kubeconfig
      EOT
  }
}