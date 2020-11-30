provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "ssh_key_pair" {
  count      = var.create_ssh_key_pair ? 1 : 0
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_key_path)
}

module "vertica_nodes" {
  source = "./modules/nodes"

  node_count         = var.node_count
  vpc_id             = var.vpc_id
  subnet_id          = var.private_subnet_id
  node_ami           = var.node_ami
  node_instance_type = var.node_instance_type
  node_volume_size   = var.node_volume_size
  dba_user           = var.dba_user
  key_name           = var.ssh_key_name
  install_key        = file(var.install_key)
}

module "bastion" {
  source = "./modules/bastion"

  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  bastion_allocation_id = var.bastion_allocation_id
  vpc_id                = var.vpc_id
  subnet_id             = var.public_subnet_id
  key_name              = var.ssh_key_name
  node_hosts            = module.vertica_nodes.private_ips
  aws_region            = var.aws_region
  aws_access_key        = var.aws_access_key
  aws_secret_key        = var.aws_secret_key
  dba_user              = var.dba_user
  db_name               = var.db_name
  db_password           = var.db_password
  db_data_dir           = var.db_data_dir
  db_eon_mode           = var.db_eon_mode
  db_shard_count        = var.db_shard_count
  db_communal_storage   = var.db_communal_storage
  db_license            = var.db_license
  db_depot_path         = var.db_depot_path
  private_install_key   = file(var.private_install_key)
}

module "lb" {
  count     = 0
  source    = "./modules/lb"
  vpc_id    = var.vpc_id
  subnet_id = var.public_subnet_id

  nodes = module.vertica_nodes.ids
}
