resource "aws_vpc" "My_AWS_VPC" {
  cidr_block = var.VPC_BLOCK

  tags = {
    Name = "My_AWS_VPC_Prod"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id                  = aws_vpc.My_AWS_VPC.id
  # map_public_ip_on_launch = true

  for_each          = var.VPC_Subnets
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name = "Subnet in ${each.value.availability_zone}"
  }
}
resource "aws_internet_gateway" "My_VPC_IGW" {
  vpc_id = aws_vpc.My_AWS_VPC.id
  tags = {
    Name = "My_VPC_IGW"
  }
}
resource "aws_route_table" "My_route_table" {
  vpc_id = aws_vpc.My_AWS_VPC.id

  route {
    cidr_block = var.subnet_route
    gateway_id = aws_internet_gateway.My_VPC_IGW.id
  }

}

resource "aws_route_table_association" "subnets" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.My_route_table.id
}

resource "aws_instance" "VMs" {
  ami                    = var.ami
  for_each               = aws_subnet.subnets
  subnet_id              = each.value.id
  availability_zone      = each.value.availability_zone
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.EC2_key.key_name
  vpc_security_group_ids = [aws_security_group.My_EC2_SG.id]
  user_data              = file("user_cmd.sh")


  depends_on = [aws_key_pair.EC2_key, aws_security_group.My_EC2_SG]
}

resource "aws_key_pair" "EC2_key" {
  key_name   = "My_EC2_key"
  public_key = file("My_EC2_key.pub")
}

resource "aws_security_group" "My_EC2_SG" {
  name   = "My_EC2_SG"
  vpc_id = aws_vpc.My_AWS_VPC.id

  tags = {
    Name = "My_EC2_SG"
  }
  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.subnet_route]

    }
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.My_EC2_SG.id
  cidr_ipv4         = var.subnet_route
  ip_protocol       = "-1"
}
resource "aws_s3_bucket" "My-s3-bucket" {
  bucket = "my-aws-resource-bucket-21idiayeau7"
}

resource "aws_lb" "My_LB" {
  name               = "My-APP-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.My_EC2_SG.id]
  subnets            = [for subnet in aws_subnet.subnets : subnet.id]
}

resource "aws_lb_target_group" "My_TG" {
  name            = "My-TG-GRP"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = aws_vpc.My_AWS_VPC.id
  ip_address_type = "ipv4"

  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "LB" {
  target_group_arn = aws_lb_target_group.My_TG.arn
  for_each         = aws_instance.VMs
  target_id        = each.value.id #This are the target instances
  port             = 80
}
resource "aws_lb_listener" "My-listener" {
  load_balancer_arn = aws_lb.My_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.My_TG.arn
  }
} 