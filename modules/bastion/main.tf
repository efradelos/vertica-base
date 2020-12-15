resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.vpc_id
  name        = "allow-ssh"
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
}

resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = var.key_name

  tags = {
    Platform = "vertica"
    Name     = "vertica-bastion"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.bastion_allocation_id == "" ? 0 : 1
  instance_id   = aws_instance.bastion.id
  allocation_id = var.bastion_allocation_id
}
