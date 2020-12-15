variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

variable "vpc_id" { description = "ID of VPC to install vertica cluster" }
variable "subnet_id" { description = "ID of subnet to install vertica cluster" }

variable "node_count" {
  description = "Number of nodes in cluster"
  default     = 3
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

variable "key_name" { description = "Name of AWS key pair to use for ssh access" }

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

variable "db_license" {
  description = "The license to use for cluster"
  default     = "CE"
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

variable "db_depot_path" {
  description = "Path to depot directory.  (EON Mode only)"
  default     = "/vertica/data"
}

variable "db_is_secodary_cluster" {
  description = "Determines if nodes are a secondary sub cluster.  (EON Mode only)"
  default     = false
}

variable "db_subcluster_name" {
  description = "Name of the subcluster to create.  (EON Mode only)"
  default     = "default_subcluster"
}
