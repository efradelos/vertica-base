locals {
  primary_config = templatefile(
    "${path.module}/templates/cloud-config-primary.yaml",
    {
      aws_conf            = base64encode(local.aws_conf),
      private_install_key = base64encode(tls_private_key.install_key.private_key_pem)
    }
  )

  secondary_config = templatefile(
    "${path.module}/templates/cloud-config-secondary.yaml",
    {
      install_key = tls_private_key.install_key.public_key_openssh
    }
  )
  aws_conf = templatefile(
    "${path.module}/templates/aws.conf",
    {
      access_key = var.aws_access_key,
      secret_key = var.aws_secret_key,
      region     = var.aws_region,
    }
  )

  install_vertica = templatefile(
    "${path.module}/templates/install_vertica.sh",
    {
      user             = var.dba_user,
      hosts            = aws_instance.secondary_nodes.*.private_ip,
      data_dir         = var.db_data_dir,
      license          = var.db_license,
      database         = var.db_name,
      password         = var.db_password,
      shard_count      = var.db_shard_count,
      communal_storage = var.db_communal_storage,
      depot_path       = var.db_depot_path
    }
  )
}

resource "tls_private_key" "install_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "cloudinit_config" "secondary_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.secondary_config
    filename     = "cloud-config.yaml"
  }
}


data "cloudinit_config" "primary_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.secondary_config
    filename     = "cloud-config.yaml"
  }

  part {
    content_type = "text/cloud-config"
    content      = local.primary_config
    filename     = "cloud-config.yaml"
  }

  part {
    content_type = "text/x-shellscript"
    content      = local.install_vertica
    filename     = "install_vertica.sh"
  }
}
