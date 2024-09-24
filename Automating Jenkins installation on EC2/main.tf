resource "aws_vpc" "Jenkins_vpc" {
  cidr_block = var.VPC_block
}

resource "aws_subnet" "Jenkins_sub" {
  vpc_id                  = aws_vpc.Jenkins_vpc.id
  cidr_block              = var.sub1
  map_public_ip_on_launch = true

  tags = {
    Name = "Jenkins-Subnet"
  }
}
resource "aws_security_group" "Jenskin-ports" {
  name        = "Jenkins_allowed_ports"
  description = "Ports required for Jenkins communications"
  vpc_id      = aws_vpc.Jenkins_vpc.id

  tags = {
    Name = "Jenkins_ports"
  }

  dynamic "ingress" {
    for_each = var.Jenkins_allowed_ports_ports
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.default-Route]

    }
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.Jenskin-ports.id
  cidr_ipv4         = var.default-Route
  ip_protocol       = "-1"
}

resource "aws_internet_gateway" "Jenkins-IGW" {
  vpc_id = aws_vpc.Jenkins_vpc.id

  tags = {
    Name = "IGW-JENKINS"
  }
}
resource "aws_route_table" "Jenkins_routes_table" {
  vpc_id = aws_vpc.Jenkins_vpc.id

  route {
    cidr_block = var.default-Route
    gateway_id = aws_internet_gateway.Jenkins-IGW.id
  }
}

resource "aws_route_table_association" "Jenkins_R" {
  subnet_id      = aws_subnet.Jenkins_sub.id
  route_table_id = aws_route_table.Jenkins_routes_table.id
}

resource "aws_instance" "Jenkins_VM" {
  ami             = var.ami
  instance_type   = var.ami_type
  subnet_id       = aws_subnet.Jenkins_sub.id
  vpc_security_group_ids = [ aws_security_group.Jenskin-ports.id ]
  key_name        = aws_key_pair.EC2_key.key_name
  user_data       = file("Jenkins_installation.sh")
}

resource "aws_key_pair" "EC2_key" {
  key_name   = "My_EC2_key"
  public_key = file("/home/custyblak/Documents/Terraform/Terraform-without-module/My_EC2_key.pub")
}

output "Pub_ip" {
  value = aws_instance.Jenkins_VM.public_ip
}