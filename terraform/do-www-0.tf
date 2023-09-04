resource "digitalocean_droplet" "www-0" {
  image = "ubuntu-22-04-x64"
  name = "www0-ubuntu-lon1"
  region = "lon1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.ssh_pvt_key)
    timeout = "3m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }
}

