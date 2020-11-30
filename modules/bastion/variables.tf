variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

variable "vpc_id" { description = "ID of VPC to install bastion" }
variable "subnet_id" { description = "ID of subnet to install bastion" }


variable "node_hosts" { description = "Host that will form cluster" }

variable "dba_user" {
  description = "The name of the db user account"
  default     = "dbadmin"
}

variable "db_name" {
  description = "The name of the database"
  default = "database-1"
}

variable "db_password" {
  description = "The password to use for database"
  default = "admin"
}

variable "db_data_dir" { 
  description = "Specify the directory for database data and catalog files"
  default = "/home/data"
}

variable "db_temp_dir" { 
  description = "The temporary directory used for administrative purposes."
  default = "/tmp"
}

variable "db_eon_mode" {
  description = "Should use EON mode for database"
  default = true
}

variable "db_shard_count" {
  description = "Shard count for database.  (EON Mode only)"
  default = 6
}

variable "db_communal_storage" { 
  description = "S3 Location of Communal Storage.  (EON Mode only)"
}

variable "db_depot_path" { 
  description = "Path to depot directory.  (EON Mode only)"
  default = "/vertica/data"
}


variable "key_name" {}
variable "private_install_key" {}

variable "bastion_ami" {
  description = "AMI to use for bastion"
  default     = "ami-083bcfe5f5bf588bd"
}

variable "bastion_instance_type" {
  description = "Instance type to use for bastion"
  default     = "c5.large"
}

variable "bastion_allocation_id" {
  description = "Allocation id to use if wanting to use elastic ip"
}

