resource "aws_instance" "nodes" {
  count                  = var.NODE_COUNT
  ami                    = var.NODE_AMI
  instance_type          = var.NODE_INSTANCE_TYPE
  subnet_id              = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = aws_key_pair.ssh.key_name
  private_ip             = "172.30.1.${count.index + 100}"
  user_data_base64       = data.cloudinit_config.node.rendered

  tags = {
    Platform = "vertica"
    Name     = "vertica-node-${count.index + 1}"
  }

  root_block_device {
    volume_size = var.NODE_VOLUME_SIZE
  }
}
