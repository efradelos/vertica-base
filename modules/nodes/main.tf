resource "aws_security_group" "vertica_node" {
  vpc_id      = var.vpc_id
  name        = "vertica-node-sg"
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
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

resource "aws_instance" "nodes" {
  count                  = var.node_count
  ami                    = var.node_ami
  instance_type          = var.node_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.vertica_node.id]
  key_name               = var.key_name
  user_data_base64       = data.cloudinit_config.config.rendered

  tags = {
    Platform = "vertica"
    Name     = "vertica-node-${count.index + 1}"
  }

  root_block_device {
    volume_size = var.node_volume_size
  }
}
