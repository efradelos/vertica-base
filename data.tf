locals {
  config_mc = templatefile(
    "${path.module}/templates/cloud-config-mc.yaml",
    {
      user     = var.mc_username,
      password = var.mc_password
    }
  )
  config_primary = templatefile(
    "${path.module}/templates/cloud-config-primary.yaml",
    {
      private_install_key = base64encode(tls_private_key.install_key.private_key_pem)
    }
  )

  config_secondary = templatefile(
    "${path.module}/templates/cloud-config-secondary.yaml",
    {
      install_key = tls_private_key.install_key.public_key_openssh
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

data "aws_iam_policy_document" "full_access" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",

      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "cloudwatch:*",
      "iam:List*",
      "iam:*Role",
      "iam:*InstanceProfile",
      "iam:*RolePolicy",
      "ec2:Describe*",
      "ec2:*SecurityGroup",
      "ec2:Authorize*",
      "ec2:*Address",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:*Instances",
      "ec2:ModifyInstanceAttribute",
      "iam:PassRole"
    ]

    resources = [
      "*",
    ]
  }
}

data "cloudinit_config" "config_primary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.config_secondary
    filename     = "cloud-config.yaml"
  }

  part {
    content_type = "text/cloud-config"
    content      = local.config_primary
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
    content      = local.config_secondary
    filename     = "cloud-config.yaml"
  }
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "cloudinit_config" "config_mc" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.config_mc
    filename     = "cloud-config.yaml"
  }
}

