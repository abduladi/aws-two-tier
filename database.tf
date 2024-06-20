
# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "db-subnets"
  subnet_ids   = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description  = "subnet group created for DB high availability"

  tags   = {
    Name = "Database Subnets"
  }
}



# # code uses AWS managed key currently. to use cmk, comment these out

# resource "aws_kms_key" "dbkms" {
#   description = "Database KMS Key"
# }

# resource "aws_kms_alias" "dbkms_alias" {
#   name          = "alias/dbkms"
#   target_key_id = aws_kms_key.dbkms.key_id
# }


# Serveless V2 resource
resource "aws_rds_cluster" "app_db" {
  cluster_identifier = "app-db-instance"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = "13.3"
  database_name      = "n26prod"
  master_username    = "dbuser"

# master_user_secret_kms_key_id = aws_kms_key.dbkms.key_id
  manage_master_user_password = true
  storage_encrypted  = true
  db_subnet_group_name     = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids      = [aws_security_group.database-security-group.id]
  db_cluster_parameter_group_name   = aws_rds_cluster_parameter_group.app-db-pg.name
  skip_final_snapshot    = true
  backup_retention_period = 7


# Export logs to cloudwatch
  enabled_cloudwatch_logs_exports = ["postgresql", "audit", "error", "general", "slowquery"]

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



# parameter group for serveless v2 option above

resource "aws_rds_cluster_parameter_group" "app-db-pg" {
  name        = "app-db-pg"
  family      = "aurora-postgresql13"
  description = "RDS default cluster parameter group"

  # Enforcing ssl connection to cluster
  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  # logging parameters

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "0"
  }

  parameter {
    name  = "log_min_messages"
    value = "info"
  }

  parameter {
    name  = "log_temp_files"
    value = "0"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }


}



# resource "aws_rds_cluster" "app_db" {
#   cluster_identifier          = "app-db-instance"
#   engine                      = "aurora-postgresql"
#   engine_mode                 = "serverless"
#   engine_version              = "13.12"
#   database_name               = "n26prod"
#   master_username             = "dbuser"
  
#   # master_user_secret_kms_key_id = aws_kms_key.dbkms.key_id
#   master_password             = "dummydbpass2972797"
#   storage_encrypted           = true
#   db_subnet_group_name        = aws_db_subnet_group.database_subnet_group.id
#   vpc_security_group_ids      = [aws_security_group.database-security-group.id]
#   db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.app-db-pg.name
#   skip_final_snapshot         = true
#   backup_retention_period     = 7
#   scaling_configuration {
#     auto_pause               = false
#     max_capacity             = 2
#     min_capacity             = 2
#     seconds_until_auto_pause = 300
#   }
# }




# resource "aws_rds_cluster_parameter_group" "app-db-pg" {
#   name        = "app-db-pg"
#   family      = "aurora-postgresql13"
#   description = "RDS cluster parameter group for aurora serverless"

#   # Enforcing ssl connection to cluster
#   parameter {
#     name  = "rds.force_ssl"
#     value = "1"
#   }

#   # logging parameters

#   parameter {
#     name  = "log_connections"
#     value = "1"
#   }

#   parameter {
#     name  = "log_disconnections"
#     value = "1"
#   }

#   parameter {
#     name  = "log_lock_waits"
#     value = "1"
#   }

#   parameter {
#     name  = "log_min_duration_statement"
#     value = "0"
#   }

#   parameter {
#     name  = "log_min_messages"
#     value = "info"
#   }

#   parameter {
#     name  = "log_temp_files"
#     value = "0"
#   }

#   parameter {
#     name  = "log_statement"
#     value = "all"
#   }


# }