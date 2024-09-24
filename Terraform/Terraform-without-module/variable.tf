variable "region" {
  default = "us-east-1"
}

variable "VPC_BLOCK" {
  default = "192.168.0.0/16"
}

variable "VPC_Subnets" {
  type = map(object({
    availability_zone = string
    cidr_block        = string
  }))

  default = {
    "subnet1" = {
      availability_zone = "us-east-1a"
      cidr_block        = "192.168.1.0/24"
    }
    "subnet2" = {
      availability_zone = "us-east-1b"
      cidr_block        = "192.168.2.0/24"
    }
  }
}

variable "subnet_route" {
  default = "0.0.0.0/0"
}

variable "ingress_ports" {
  type    = list(any)
  default = [22, 80]
}

variable "ami" {
  default = "ami-0e86e20dae9224db8"
}