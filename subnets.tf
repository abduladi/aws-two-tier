
# public subnets will be used in configuring the load balancer and NAT gateway so the resources
# can have outbound access to the internet. N
# Create Public Subnet 1 in availability zone a in the region
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 1"
  }
}

# Create Public Subnet 2 in availability zone b
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 2"
  }
}


# Independent private subnets will be used to hold both the app server and the DB
# Create Private Subnet 1 for app tier
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 1 for App"
  }
}

# Create Private Subnet 2 for app tier
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 2 for App"
  }
}

# Create Private Subnet 3 for database tier
resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 3 for Database"
  }
}

# Create Private Subnet 4 for database tier
resource "aws_subnet" "private-subnet-4" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-4-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 4 for Database "
  }
}