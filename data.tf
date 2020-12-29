locals {
  config_node = file("${path.module}/templates/cloud-config.yaml")

  install_mc = templatefile(
    "${path.module}/templates/install_mc.sh",
    {
      user        = var.mc_username,
      password    = var.mc_password
      host_id     = aws_instance.primary_node[0].id,
      host        = aws_instance.primary_node[0].private_ip,
      db_name     = var.db_name,
      db_user     = var.dba_user,
      db_password = var.db_password,
    }
  )

  install_vertica = templatefile(
    "${path.module}/templates/install_vertica.sh",
    {
      user             = var.dba_user,
      hosts            = aws_instance.secondary_nodes.*.private_ip,
      instance_ids     = aws_instance.secondary_nodes.*.id,
      data_dir         = var.db_data_dir,
      license          = var.db_license,
      database         = var.db_name,
      password         = var.db_password,
      shard_count      = var.db_shard_count,
      communal_storage = "s3://${var.db_communal_storage_bucket}/${var.db_communal_storage_key}",
      depot_path       = var.db_depot_path
    }
  )
}

data "cloudinit_config" "config_mc" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = local.install_mc
    filename     = "install_mc.sh"
  }

}

data "cloudinit_config" "config_primary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.config_node
    filename     = "cloud-config.yaml"
  }

  part {
    content_type = "text/x-shellscript"
    content      = local.install_vertica
    filename     = "install_vertica.sh"
  }
}

data "cloudinit_config" "config_secondary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.config_node
    filename     = "cloud-config.yaml"
  }
}

