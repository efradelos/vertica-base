locals {
  aws_conf = templatefile(
    "${path.module}/templates/aws.conf",
    {
      access_key = var.aws_access_key,
      secret_key = var.aws_secret_key,
      region     = var.aws_region,
    }
  )

  vertica_conf = templatefile(
    "${path.module}/templates/vertica.conf",
    {
      hosts = var.node_hosts,
      user  = var.dba_user
    }
  )

  install_script = templatefile(
    "${path.module}/templates/install_vertica.sh",
    {
      hosts            = var.node_hosts,
      data_dir         = var.db_data_dir,
      user             = var.dba_user,
      license          = var.db_license,
      database         = var.db_name,
      password         = var.db_password,
      shard_count      = var.db_shard_count,
      communal_storage = var.db_communal_storage,
      depot_path       = var.db_depot_path
    }
  )

  cloud_config = "${path.module}/templates/cloud-config.yaml"

  ssh_init = templatefile(
    "${path.module}/templates/ssh-init.sh",
    {
      user  = var.dba_user,
      hosts = var.node_hosts
    }
  )
}

data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content = templatefile(
      local.cloud_config,
      {
        aws_conf            = base64encode(local.aws_conf),
        vertica_conf        = base64encode(local.vertica_conf),
        install_script      = base64encode(local.install_script),
        private_install_key = base64encode(var.private_install_key)
      }
    )
  }

  part {
    content_type = "text/x-shellscript"
    content      = local.ssh_init
    filename     = "ssh-init.sh"
  }
}
