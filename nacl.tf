
# NACL for DB subnets

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
    protocol   = "-1"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Name = "DB Subnet NACL"
  }
}


# NACL for App server subnets

resource "aws_network_acl" "app_nacl" {
  vpc_id = aws_vpc.vpc.id

  subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public-subnet-1-cidr
    from_port  = 443
    to_port    = 443
  }
  ingress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public-subnet-2-cidr
    from_port  = 443
    to_port    = 443
  }

  ingress {
    rule_no    = 102
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public-subnet-1-cidr
    from_port  = 80
    to_port    = 80
  }
  ingress {
    rule_no    = 103
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public-subnet-2-cidr
    from_port  = 80
    to_port    = 80
  }
  
  # deny all outbound traffic
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Name = "App Subnet NACL"
  }
}


# NACL for public subnet
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.vpc.id

  subnet_ids = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # deny all outbound traffic
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Name = "App Subnet NACL"
  }
}