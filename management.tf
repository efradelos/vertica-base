resource "aws_instance" "management" {
  count                  = var.MANAGEMENT_ENABLED ? 1 : 0
  ami                    = var.MANAGEMENT_AMI
  instance_type          = var.MANAGEMENT_INSTANCE_TYPE
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = aws_key_pair.ssh.key_name
  user_data_base64       = data.cloudinit_config.management.rendered

  tags = {
    Platform = "vertica"
    Name     = "vertica-management"
  }

  root_block_device {
    volume_size = var.MANAGEMENT_VOLUME_SIZE
  }

  provisioner "file" {
    source      = "mykey"
    destination = "key"
  }

  connection {
    user        = var.INSTANCE_USERNAME
    host        = self.public_ip
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}
