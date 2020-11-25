data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "kavala13-test"
    key    = "terraform/state/vertica-cloud"
    region = "us-east-1"
  }
}

locals {
  auth_params  = templatefile("./configs/auth_params.conf", { access_key = var.AWS_ACCESS_KEY, secret_key = var.AWS_SECRET_KEY, region = var.AWS_REGION })
  vertica_params  = templatefile("./configs/vertica_params.conf", { hosts = aws_instance.nodes.*.private_ip })
  cloud_config = templatefile("./configs/cloud-config.yaml", { user = var.INSTANCE_USERNAME, auth_params = base64encode(local.auth_params), vertica_params = base64encode(local.vertica_params) })
  prepare  = templatefile("./scripts/prepare.sh", { user = var.INSTANCE_USERNAME })
  ssh_init = templatefile("./scripts/ssh-init.sh", { user = var.INSTANCE_USERNAME, hosts = aws_instance.nodes.*.private_ip })
  install  = templatefile("./scripts/install_vertica.sh", {
    hosts = ["172.30.1.100","172.30.1.101","172.30.1.102"],
    db = var.DATABASE_NAME,
    password = var.DATABASE_PASSWORD,
    eon_mode = var.EON_MODE,
    shard_count = var.EON_SHARD_COUNT,
    communal_storage = var.EON_COMMUNAL_STORAGE,
    depot_path = var.EON_DEPOT_PATH
  })
}

data "cloudinit_config" "management" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = local.cloud_config
  }

  part {
    content_type = "text/x-shellscript"
    content      = local.ssh_init
    filename     = "ssh-init.sh"
  }
}

data "cloudinit_config" "node" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = local.prepare
    filename     = "prepare.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = local.install
    filename     = "install_vertica.sh"
  }

}
