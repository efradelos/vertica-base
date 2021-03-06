# VPC variables
variable "vpc_id" {
  description = "ID of VPC to install vertica cluster"
}

variable "public_subnet_id" {
  description = "ID of public subnet to install vertica cluster. Used for optional management console"
}

variable "private_subnet_id" {
  description = "ID of public subnet to install vertica cluster. Used for nodes"
}

variable "credentials_secret_id" {
  description = "ID of aws secret to retrieve for credentials"
}

# SSH key variables
variable "create_ssh_key" {
  description = "Determines if AWS key pair for ssh is created"
  default     = true
}

variable "ssh_key_name" {
  description = "Name of key pair to use for ssh"
  default     = "vertica-ssh-key"
}

variable "ssh_key_path" {
  description = "Path of public key for ssh. Only used of create_ssh_key_pair is true"
  default     = "secrets/vertica_key.pub"
}

# Security Group
variable "create_security_group" {
  description = "Determines if AWS security group is created"
  default     = true
}

variable "security_group_name" {
  description = "Name of security group that allows traffic for vertica communication"
  default     = "vertica-sg"
}

variable "rga_networks" {
  type        = list(string)
  description = "List of RGA networks"
  default = [
    "0.0.0.0/0", # TODO: Change default to actual rga networks
  ]
}


# Communal Storage
variable "create_communal_storage_bucket" {
  description = "Determines if S3 buckets is created for communal storage (EON Mode only)"
  default     = false
}


# Instance Profile
variable "create_instance_profile" {
  description = "Determines if instance profile should be created"
  default     = false
}

variable "instance_profile_name" {
  description = "Name of instance profilie to use for ec2 instances"
  default     = "vertica-instance-profile"
}


# Management Console variables
variable "create_mc" {
  description = "Create a vertica managment console"
  default     = false
}

variable "mc_name" {
  description = "Name of Management Console instance"
  default     = "vertica-mc"
}

variable "mc_allocation_id" {
  description = "Elastic IP id to use for management console (if any)"
  default     = ""
}

variable "mc_ami" {
  description = "AMI to use for management console"
  default     = "ami-083bcfe5f5bf588bd"
}

variable "mc_instance_type" {
  description = "Instance type to use for management console"
  default     = "c5.large"
}

variable "mc_username" {
  description = "Username for logging into Management Console"
  default     = "mcadmin"
}


# Node variables
variable "node_count" {
  description = "Number of nodes in cluster"
  default     = 3
}

variable "node_prefix" {
  description = "Prefix to use for node names.  i.e. vertica-node will translate to vertica-node-1"
  default     = "vertica-node"
}

variable "node_ami" {
  description = "AMI to use for each node in cluster"
  default     = "ami-083bcfe5f5bf588bd"
}

variable "node_instance_type" {
  description = "Instance type to use for each node in cluster"
  default     = "c5.large"
}

# DB Variables
variable "dba_user" {
  description = "The name of the db user account"
  default     = "dbadmin"
}

variable "db_name" {
  description = "The name of the database"
  default     = "db1"
}

variable "db_data_dir" {
  description = "Specify the directory for database data and catalog files"
  default     = "/vertica/data"
}

variable "db_eon_mode" {
  description = "Should use EON mode for database"
  default     = true
}

variable "db_communal_storage_bucket" {
  description = "Name of S3 bucket used for communal storage (EON Mode only)"
  default     = "vertica-communal-storage"
}

variable "db_communal_storage_key" {
  description = "Key for S3 bucket communal storage data (EON Mode only)"
  default     = "data"
}

variable "db_shard_count" {
  description = "Shard count for database.  (EON Mode only)"
  default     = 6
}

variable "db_license_base64" {
  description = "The license to use for cluster in base64 format. Leave null to use community edition"
  default     = "VmVydGljYSBDb21tdW5pdHkgRWRpdGlvbiANCjIwMTEtMTEtMjINClBlcnBldHVhbA0KMA0KMVRCIENFIE5vZGVzIDMNCjc2NzlCQUI3NENENkUwRjNCQTU2QUNENkY1RENBRkVFOTBEREIwNTUwRTRGMDg2QzdERTEwQ0VCMTk2QUVGRThENDY1RjI3RTlDRjQ4RkIyQkE3NkNENjZDQTE5NTBCNDNEMDQ1N0VCQkU2NkVDMDc2QjIxQTY5OENDMUU2NTc5OTU2QTkwODJGNkQ5RDIyMTY1NzRDRDY2RjcxODg0NDUyODg2MjJGQTYzRkFDNURFODNBQjlDNjk3RjhFMzkxNTczQjlERDRCODAxNTlEMjNBNDU4Mjg2NjQ4RjlEQjJFMUNFMDYwMTkzNTgxRkZFNEZGMTg1NDNFRjEzOTZCQjRDOEFCNDdBNjA4RDU1QjZCQzk0RDVGMzRDNkQ4M0I5RjE4OTRDQjA4OTRDRjMzN0FGODlFQjkzRTc5RTIzQTIzRTE5REZGNkM2NDUyQjU5NTg3QUVGRDM2MTZCRkMwRjkwMzE4MThERkVBMjY4OUI3RUQ0OENFQzIyMjcyMTcwOTI3RUY2MzBENUQ5MjlGOENDOThFQ0VFN0NBMDQ2RkVERTFCRjM2NkM0RTc0MkYxREFDNkI3MzlGNzA5NDY0OEM1REQ2ODZBRjUxMzg0QkJBRUQ3RDEzRDcwNTlBMjU1NzRBQUFGNjI5NEY5QTc5N0FGOEI5NDEzMENDMUNDRTg3DQoNCg=="
}

variable "db_depot_path" {
  description = "Path to depot directory.  (EON Mode only)"
  default     = "/vertica/data"
}

# Load Balancer
variable "create_lb" {
  description = "Create a loadbalancer to access nodes in cluster"
  default     = false
}

variable "lb_name" {
  description = "Name of load balancer"
  default     = "vertica-nodes-lb"
}

variable "lb_allocation_id" {
  description = "Elastic IP id to use for load balancer (if any)"
  default     = null
}

variable "additional_tags" {
  description = "Additional tags to apply to all aws resources"
  default     = {}
}
