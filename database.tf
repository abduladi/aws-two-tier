
# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "db-subnets"
  subnet_ids   = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description  = "subnet group created for DB high availability"

  tags   = {
    Name = "Database Subnets"
  }
}



# using AWS managed key. to use cmk, comment these out
# resource "aws_kms_key" "dbkms" {
#   description = "Database KMS Key"
# }

# resource "aws_kms_alias" "dbkms_alias" {
#   name          = "alias/dbkms"
#   target_key_id = aws_kms_key.dbkms.key_id
# }



resource "aws_rds_cluster" "app_db" {
  cluster_identifier = "app-db-instance"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = "15.4"
  database_name      = "n26prod"
  master_username    = "dbuser"
#   master_user_secret_kms_key_id = aws_kms_key.dbkms.key_id
  manage_master_user_password = true
  storage_encrypted  = true
  db_subnet_group_name     = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids      = [aws_security_group.database-security-group.id]



  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "app_db" {
  cluster_identifier = aws_rds_cluster.app_db.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.app_db.engine
  engine_version     = aws_rds_cluster.app_db.engine_version
  publicly_accessible = false
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.id
}