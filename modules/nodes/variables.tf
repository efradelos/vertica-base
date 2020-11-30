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

variable "dba_user" {
  description = "The name of the db user account"
  default     = "dbadmin"
}

variable "key_name" { description = "Name of AWS key pair to use for ssh access" }
variable "install_key" { description = "Public key for one time use to install cluster" }
