data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../cloud/terraform.tfstate"
  }
}


locals {
  prepare  = templatefile("./scripts/prepare.sh", { user = var.INSTANCE_USERNAME })
  ssh_init = templatefile("./scripts/ssh-init.sh", { user = var.INSTANCE_USERNAME, ip_addrs = aws_instance.nodes.*.private_ip })
  install  = templatefile("./scripts/install_vertica.sh", { user = var.INSTANCE_USERNAME, ip_addrs = aws_instance.nodes.*.private_ip })
}

data "cloudinit_config" "management" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/x-shellscript"
    content      = local.ssh_init
    filename     = "ssh-init.sh"
  }
  # part {
  #   content_type = "text/x-shellscript"
  #   content      = local.prepare
  #   filename     = "prepare.sh"
  # }

  part {
    content_type = "text/x-shellscript"
    content      = local.install
    filename     = "install_vertica.sh"
  }
}

data "cloudinit_config" "node" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/x-shellscript"
    content      = local.prepare
    filename     = "prepare.sh"
  }
}
