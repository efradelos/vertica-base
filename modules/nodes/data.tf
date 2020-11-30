data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = templatefile("${path.module}/templates/cloud-config.yaml", { install_key = var.install_key })
  }
}
