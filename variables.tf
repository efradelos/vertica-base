variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

# DB Variables
variable "dba_user" {
  description = "The name of the db user account"
  default     = "dbadmin"
}

variable "db_name" {
  description = "The name of the database"
  default     = "db1"
}

variable "db_password" {
  description = "The password to use for database"
  default     = "admin"
}

variable "db_data_dir" {
  description = "Specify the directory for database data and catalog files"
  default     = "/home/data"
}

variable "db_eon_mode" {
  description = "Should use EON mode for database"
  default     = true
}

variable "db_shard_count" {
  description = "Shard count for database.  (EON Mode only)"
  default     = 6
}

variable "db_communal_storage" {
  description = "S3 Location of Communal Storage.  (EON Mode only)"
  default     = ""
}

variable "db_license" {
  description = "The license to use for cluster"
  default     = "CE"
}

variable "db_depot_path" {
  description = "Path to depot directory.  (EON Mode only)"
  default     = "/vertica/data"
}


# VPC variables
variable "vpc_id" {
  description = "ID of VPC to install vertica cluster"
}

variable "public_subnet_id" {
  description = "ID of public subnet to install vertica cluster. Used for bastion"
}

variable "private_subnet_id" {
  description = "ID of public subnet to install vertica cluster. Used for nodes"
}


# SSH key variables
variable "create_ssh_key_pair" {
  description = "Determines if AWS key pair for ssh is created"
  default     = false

}
variable "ssh_key_name" {
  description = "Name of key pair to use for ssh"
  default     = "vertica-ssh-key"
}
variable "ssh_key_path" {
  description = "Path of public key for ssh. Only used of create_ssh_key_pair is true"
  default     = ""
}


# Node variables
variable "node_count" {
  description = "Number of nodes in cluster"
  default     = "3"
}

variable "node_ami" {
  description = "AMI to use for each node in cluster"
  default     = "ami-083bcfe5f5bf588bd"
}

variable "node_instance_type" {
  description = "Instance type to use for each node in cluster"
  default     = "c5.large"
}

variable "node_volume_size" {
  description = "Volume size for each node in cluster (in GB)"
  default     = 50
}

# Bastion variables
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
  default     = ""
}

variable "install_key" {
  description = "Path to public key used for one time ssh configutation"
}

variable "private_install_key" {
  description = "Path to private key used for one time ssh configutation"
}
