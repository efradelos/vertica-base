variable "vpc_id" { description = "ID of VPC to install bastion" }
variable "subnet_id" { description = "ID of subnet to install bastion" }

variable "key_name" {}

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

