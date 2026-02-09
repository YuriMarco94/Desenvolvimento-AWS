output "db_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "RDS endpoint"
}

output "db_address" {
  value       = aws_db_instance.this.address
  description = "RDS address"
}

output "db_port" {
  value       = aws_db_instance.this.port
  description = "RDS port"
}

output "db_security_group_id" {
  value       = aws_security_group.db.id
  description = "DB security group id"
}

output "master_user_secret_arn" {
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
  description = "Secret ARN managed by RDS (master user password)"
}
