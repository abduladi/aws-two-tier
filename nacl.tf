
# # NACL for DB subnets

resource "aws_network_acl" "db_nacl" {
  vpc_id = aws_vpc.vpc.id

  subnet_ids = [aws_subnet.private-subnet-4.id, aws_subnet.private-subnet-3.id]

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private-subnet-2-cidr
    from_port  = 3306
    to_port    = 3306
  }
  ingress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private-subnet-1-cidr
    from_port  = 3306
    to_port    = 3306
  }
  
  # deny all outbound traffic
  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.vpc-cidr
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Name = "DB Subnet NACL"
  }
}


# # NACL for App server subnets

# resource "aws_network_acl" "app_nacl" {
#   vpc_id = aws_vpc.vpc.id

#   subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

# # Allow inbound traffic from the VPC CIDR on the ALB listener port and health check port (port 80 serves both purposes)
#   ingress {
#     rule_no    = 100
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = var.vpc-cidr
#     from_port  = 443
#     to_port    = 443
#   }

#   ingress {
#     rule_no    = 101
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = var.vpc-cidr
#     from_port  = 80
#     to_port    = 80
#   }


  
#   # Allow outbound traffic to the VPC CIDR on the ephemeral ports
#   egress {
#     rule_no    = 100
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = var.vpc-cidr
#     from_port  = 1024
#     to_port    = 65535
#   }


#   tags = {
#     Name = "App Subnet NACL"
#   }
# }


# NACL for public subnet
# resource "aws_network_acl" "public_nacl" {
#   vpc_id = aws_vpc.vpc.id

#   subnet_ids = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

#   ingress {
#     rule_no    = 100
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }

#   ingress {
#     rule_no    = 101
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }

#   ingress {
#     rule_no    = 102
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = var.vpc-cidr
#     from_port  = 1024
#     to_port    = 65535
#   }

#   egress {
#     rule_no    = 100
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = var.vpc-cidr
#     from_port  = 443
#     to_port    = 443
#   }

#   egress {
#     rule_no    = 101
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = var.vpc-cidr
#     from_port  = 80
#     to_port    = 80
#   }

#   # Allow outbound traffic on the ephemeral ports
#   egress {
#     rule_no    = 102
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }


#   tags = {
#     Name = "Public Subnet NACL"
#   }
# }
