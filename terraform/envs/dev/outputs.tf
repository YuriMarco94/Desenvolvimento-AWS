output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_master_secret_arn" {
  value = module.rds.master_user_secret_arn
}
