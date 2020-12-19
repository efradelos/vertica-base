locals {
  nodes = var.node_count > 0 ? concat([aws_instance.primary_node.0], aws_instance.secondary_nodes.*) : []
}

resource "aws_key_pair" "ssh_key_pair" {
  count      = var.create_ssh_key_pair ? 1 : 0
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_key_path)
}

resource "aws_security_group" "vertica_sg" {
  count       = var.create_security_group ? 1 : 0
  vpc_id      = var.vpc_id
  name        = var.security_group_name
  description = "security group that allows traffic for vertica communication"


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5433
    to_port     = 5433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5450
    to_port     = 5450
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

resource "aws_s3_bucket" "communal_storage" {
  count  = var.create_communal_storage_bucket ? 1 : 0
  bucket = var.communal_storage_bucket
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # logging {
  #   target_bucket = "logging-${var.aws_region}-${var.aws_account_number}"
  #   target_prefix = "${var.bucket_prefix}/"
  # }

  tags = {
    Platform = "vertica"
    Name     = var.communal_storage_bucket
  }
}

resource "aws_s3_bucket_public_access_block" "s3_block" {
  count  = var.create_communal_storage_bucket ? 1 : 0
  bucket = aws_s3_bucket.communal_storage.0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "role" {
  count = var.create_instance_profile ? 1 : 0
  name  = "ServiceRoleForVertica"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "role_policy" {
  count  = var.create_instance_profile ? 1 : 0
  name   = "VerticaFullAccess"
  policy = data.aws_iam_policy_document.full_access.json
  role   = aws_iam_role.role.0.name
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.instance_profile_name
  role  = aws_iam_role.role.0.name
}

resource "aws_instance" "management_console" {
  count                  = var.create_mc ? 1 : 0
  ami                    = var.mc_ami
  instance_type          = var.mc_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.vertica_sg.0.id]
  key_name               = var.ssh_key_name
  iam_instance_profile   = var.instance_profile_name
  user_data_base64       = data.cloudinit_config.config_mc.rendered

  tags = {
    Platform = "vertica"
    Name     = "vertica-mc"
  }
}

resource "aws_instance" "secondary_nodes" {
  count                  = var.node_count > 0 ? var.node_count - 1 : 0
  ami                    = var.node_ami
  instance_type          = var.node_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.vertica_sg.0.id]
  key_name               = var.ssh_key_name
  iam_instance_profile   = var.instance_profile_name
  user_data_base64       = data.cloudinit_config.config_secondary.rendered

  tags = {
    Platform = "vertica"
    Name     = "vertica-node-${count.index + 2}"
  }

  root_block_device {
    volume_size = var.node_volume_size
  }
}

resource "aws_instance" "primary_node" {
  count                  = var.node_count > 0 ? 1 : 0
  ami                    = var.node_ami
  instance_type          = var.node_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.vertica_sg.0.id]
  key_name               = var.ssh_key_name
  iam_instance_profile   = var.instance_profile_name
  user_data_base64       = data.cloudinit_config.config_primary.rendered

  tags = {
    Platform = "vertica"
    Name     = "vertica-node-1"
  }

  root_block_device {
    volume_size = var.node_volume_size
  }
}

module "lb" {
  count  = var.create_lb ? 1 : 0
  source = "terraform-aws-modules/alb/aws"

  name = "vertica-nodes-lb"

  load_balancer_type = "network"

  vpc_id  = var.vpc_id
  subnets = [var.public_subnet_id]

  # access_logs = {
  #   bucket = "my-nlb-logs"
  # }

  target_groups = [
    {
      name             = "vertica-ssh-target-group"
      backend_port     = 22
      backend_protocol = "TCP"
    },
    {
      # name_prefix      = "pref-"
      name             = "vertica-db-target-group"
      backend_port     = 5433
      backend_protocol = "TCP"
    },
  ]

  http_tcp_listeners = [
    {
      port               = 22
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 5433
      protocol           = "TCP"
      target_group_index = 1
    }
  ]

  tags = {
    Environment = "Test"
  }
}

resource "aws_lb_target_group_attachment" "ssh_attachments" {
  count            = var.create_lb ? 1 : 0
  target_group_arn = module.lb.0.target_group_arns.0
  target_id        = aws_instance.primary_node.0.id
  port             = 22
}

resource "aws_lb_target_group_attachment" "db_attachments" {
  count = var.create_lb ? var.node_count : 0

  target_group_arn = module.lb.0.target_group_arns.1
  target_id        = local.nodes[count.index].id
  port             = 5433
}

