resource "aws_key_pair" "ssh" {
  key_name   = "ssh-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
