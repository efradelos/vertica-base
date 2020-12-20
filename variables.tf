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


# Communal Storage
variable "create_communal_storage_bucket" {
  description = "Determines if S3 buckets is created for communal storage (EON Mode only)"
  default     = false
}

variable "communal_storage_bucket" {
  description = "Name of S3 bucket used for communal storage (EON Mode only)"
  default     = "vertica-communal-storage"
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

variable "mc_password" {
  description = "Password for logging into Management Console"
  default     = "change-me"
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

variable "node_volume_size" {
  description = "Volume size for each node in cluster (in GB)"
  default     = 50
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

variable "db_subcluster_name" {
  description = "Name of the subcluster to create.  (EON Mode only)"
  default     = "default_cluster"
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

variable "additional_tags" {
  description = "Additional tags to apply to all aws resources"
  default     = {}
}
