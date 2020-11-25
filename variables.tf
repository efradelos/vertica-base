variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "secrets/mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "secrets/mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

variable "NODE_COUNT" {
  default = "3"
}

variable "NODE_AMI" {
  default = "ami-083bcfe5f5bf588bd"
}

variable "NODE_INSTANCE_TYPE" {
  default = "c5.large"
}

variable "NODE_VOLUME_SIZE" {
  default = 50
}

variable "MANAGEMENT_ENABLED" {
  default = true
}

variable "MANAGEMENT_AMI" {
  default = "ami-083bcfe5f5bf588bd"
}

variable "MANAGEMENT_INSTANCE_TYPE" {
  default = "c5.large"
}

variable "MANAGEMENT_VOLUME_SIZE" {
  default = 50
}

variable DATABASE_NAME {
  default = "database-1"
}

variable DATABASE_PASSWORD {
  default = "dbadmin"
}

variable "EON_MODE" {
  default = true
}

variable "EON_SHARD_COUNT" {
  default = 6
}

variable "EON_COMMUNAL_STORAGE" { }

variable "EON_DEPOT_PATH" { 
  default = "/vertica/data"
}
