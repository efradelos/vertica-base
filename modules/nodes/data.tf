data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = templatefile("${path.module}/templates/cloud-config.yaml", { install_key = var.install_key })
  }

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = templatefile("${path.module}/templates/cloud-config.yaml", { install_key = var.install_key })
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/prepare.sh", { user = var.dba_user })
    filename     = "prepare.sh"
  }

}
