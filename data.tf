locals {
  script_env = {
    mc_name               = var.mc_name
    mc_username           = var.mc_username
    node_prefix           = var.node_prefix
    node_count            = var.node_count
    credentials_secret_id = var.credentials_secret_id
    db_user               = var.dba_user
    db_name               = var.db_name
    db_data_dir           = var.db_data_dir
    db_license_base64     = var.db_license_base64
    db_shard_count        = var.db_shard_count
    db_communal_storage   = "s3://${var.db_communal_storage_bucket}/${var.db_communal_storage_key}"
    db_depot_path         = var.db_depot_path
  }

  setup = templatefile("${path.module}/templates/setup.sh", local.script_env)
}

data "cloudinit_config" "config_mc" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = local.setup
    filename     = "setup.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/prepare_node.sh")
    filename     = "01-prepare_node.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/install_mc.sh")
    filename     = "02-install_mc.sh"
  }
}

data "cloudinit_config" "config_primary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = local.setup
    filename     = "setup.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/prepare_node.sh")
    filename     = "01-prepare_node.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/install_vertica.sh")
    filename     = "02-install_vertica.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/configure_tls.sh")
    filename     = "03-configure_tls.sh"
  }
}

data "cloudinit_config" "config_secondary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = local.setup
    filename     = "setup.sh"
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/prepare_node.sh")
    filename     = "prepare_node.sh"
  }
}
