variable "region" {
  default = "us-east-1"
}

variable "VPC_block" {
  default = "192.168.20.0/23"
}

variable "sub1" {
  default = "192.168.20.0/24"
}

variable "default-Route" {
  default = "0.0.0.0/0"
}

variable "Jenkins_allowed_ports_ports" {
  type    = list(any)
  default = [22, 8080, 9090, 50000]
}
variable "ami" {
  default = "ami-0e86e20dae9224db8"
}
variable "ami_type" {
  default = "t3.medium"
}
