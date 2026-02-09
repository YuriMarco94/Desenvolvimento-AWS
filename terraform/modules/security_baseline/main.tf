resource "aws_guardduty_detector" "this" {
  enable = true

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "guardduty-${var.environment}"
  })
}

resource "aws_securityhub_account" "this" {}

# Optional: enable AWS Foundational Security Best Practices (recomendado)
resource "aws_securityhub_standards_subscription" "aws_foundational" {
  depends_on    = [aws_securityhub_account.this]
  standards_arn = "arn:aws:securityhub:::standards/aws-foundational-security-best-practices/v/1.0.0"
}
