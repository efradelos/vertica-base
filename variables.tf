variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map
  default = {
  }
}

variable "INSTANCE_USERNAME" {
  # default = "ec2-user"
  default = "dbadmin"
}

variable "NODE_COUNT" {
  default = "3"
  # default = "0"
}

variable "NODE_AMI" {
  # default = "ami-0947d2ba12ee1ff75"
  default = "ami-083bcfe5f5bf588bd"
}

variable "NODE_INSTANCE_TYPE" {
  # default = "c5d.4xlarge"
  # default = "t2.micro"
  default = "c5.large"
}

variable "NODE_VOLUME_SIZE" {
  default = 50
}

variable "MANAGEMENT_ENABLED" {
  default = true
  # default = false
}

variable "MANAGEMENT_AMI" {
  # default = "ami-0947d2ba12ee1ff75"
  default = "ami-083bcfe5f5bf588bd"
}

variable "MANAGEMENT_INSTANCE_TYPE" {
  # default = "c5d.4xlarge"
  # default = "t2.micro"
  # default = "t2.nano"
  default = "c5.large"
}

variable "MANAGEMENT_VOLUME_SIZE" {
  default = 50
}

variable "EON_MODE" {
  default = true
}

variable "EON_SHARD_COUNT" {
  default = 6
}
