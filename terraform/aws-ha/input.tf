variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "region" {
  type = "string"

  default = "us-east-1"
}

variable "instance-size" {
  type = "string"

  default = "m5.2xlarge"
}

variable "name" {
  type = "string"

  default = "stoplight"
}

variable "az-subnet-mapping" {
  type = "list"

  default = [
    {
      name = "us-east-1a"
      az   = "us-east-1a"
      cidr = "10.0.0.0/24"
    },
    {
      name = "us-east-1b"
      az   = "us-east-1b"
      cidr = "10.0.1.0/24"
    },
  ]
}

variable "cidr" {
  type    = "string"
  default = "10.0.0.0/16"
}
