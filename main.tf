terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = ">= 2.19.0"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 100
  retry_limit = 3
}

resource "vultr_ssh_key" "pub_key" {
  name = "id_ed25519_pub"
  ssh_key = var.ssh_public_key
}

data "template_file" "cloud_init" {
  template = file("./scripts/cloud-init.yaml")

  vars = {
    username = var.username
    ssh_public_key = var.ssh_public_key
  }
}

# check cloud resource from vultr api: https://www.vultr.com/api/
resource "vultr_instance" "server" {
  label = "ubuntu_jp_high_freq"
  plan = "vhf-1c-1gb"
  region = "nrt"
  os_id = "1743"
  enable_ipv6 = true
  ssh_key_ids = ["${vultr_ssh_key.pub_key.id}"]
  user_data = data.template_file.cloud_init.rendered

  connection {
    type = "ssh"
    user = var.username
    host = self.main_ip
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }
}
