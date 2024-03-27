resource "aws_db_subnet_group" "myDBSubnetGroup" {
  name       = "mydbsubnetgroup"
  subnet_ids = [for subnet in var.subnets : subnet.id if contains(["sn-db-a", "sn-db-b", "sn-db-c"], subnet.tags["Name"])]
}

resource "aws_rds_cluster" "rds_cluster" {
  availability_zones        = [for subnet in var.subnets : subnet.availability_zone if contains(["sn-db-a", "sn-db-b", "sn-db-c"], subnet.tags["Name"])]
  cluster_identifier        = "mydbcluster"
  database_name             = var.db_name
  allocated_storage         = 100
  storage_type              = "io1"
  iops                      = 1000
  engine                    = "mysql"
  engine_version            = "8.0.32"
  db_cluster_instance_class = "db.m6gd.large"
  master_username           = var.db_username
  master_password           = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.myDBSubnetGroup.name
  storage_encrypted         = true
  delete_automated_backups  = true
  deletion_protection       = false
  skip_final_snapshot       = true
  backup_retention_period   = 35
  vpc_security_group_ids    = var.db-sg
}
