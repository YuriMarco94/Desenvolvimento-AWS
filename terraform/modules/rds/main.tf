resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-${var.environment}-db-subnets"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment}-db-subnets"
    Environment = var.environment
  })
}

resource "aws_security_group" "db" {
  name        = "${var.name}-${var.environment}-rds-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment}-rds-sg"
    Environment = var.environment
  })
}

# Allow inbound from provided SGs (EKS nodes / app SG)
resource "aws_vpc_security_group_ingress_rule" "from_allowed_sgs" {
  for_each = toset(var.allowed_security_group_ids)

  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = each.value
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.db.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_db_instance" "this" {
  identifier = "${var.name}-${var.environment}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = "postgres"

  # IMPORTANT: avoids storing master password in your code
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection
  skip_final_snapshot = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment}-postgres"
    Environment = var.environment
  })
}
