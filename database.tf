
# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "db-subnets"
  subnet_ids   = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description  = "subnet group created for DB high availability"

  tags   = {
    Name = "Database Subnets"
  }
}


resource "aws_db_instance" "app_db" {
  allocated_storage           = 10
  db_name                     = "n26prod"
  engine                      = "mysql"
  engine_versi                = "8.0"
  multi_az                    = true
  identifier                  = "app-db-instance"
  instance_class              = "db.t2.micro"
  manage_master_user_password = true
  username                    = "dbuser"
  parameter_group_name        = "default.mysql8.0"
  db_subnet_group_name        = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids      = [aws_security_group.database-security-group.id]
  skip_final_snapshot         = true
}