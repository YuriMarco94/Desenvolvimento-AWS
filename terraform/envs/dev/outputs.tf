output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }

output "eks_cluster_name" { value = module.eks.cluster_name }

output "ecr_repository_url" { value = module.ecr.repository_url }
output "github_actions_role_arn" { value = module.cicd_github.role_arn }

output "alb_dns_name" { value = module.edge.alb_dns_name }
#output "cloudfront_domain" { value = module.edge.cloudfront_domain }
