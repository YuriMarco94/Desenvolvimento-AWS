locals {
  name = "${var.org}-${var.app}-${var.env}"
}

resource "aws_guardduty_detector" "this" {
  count  = var.enable_guardduty ? 1 : 0
  enable = true
  tags   = merge(var.tags, { Name = "guardduty-${var.env}" })
}

resource "aws_securityhub_account" "this" {
  count                  = var.enable_securityhub ? 1 : 0
  auto_enable_controls   = true
  enable_default_standards = true
}

resource "aws_securityhub_standards_subscription" "aws_foundational" {
  count        = var.enable_securityhub_standards ? 1 : 0
  standards_arn = "arn:aws:securityhub:::standards/aws-foundational-security-best-practices/v/1.0.0"
}

resource "aws_accessanalyzer_analyzer" "this" {
  count = var.enable_access_analyzer ? 1 : 0
  analyzer_name = "${local.name}-access-analyzer"
  type          = "ACCOUNT"
  tags          = var.tags
}

# Inspector2 (ativa scanning contínuo / ECR)
resource "aws_inspector2_enabler" "this" {
  count = var.enable_inspector2 ? 1 : 0

  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR"]
}

data "aws_caller_identity" "current" {}
